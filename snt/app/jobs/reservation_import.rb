require 'csv'

class ReservationImport
  include Resque::Plugins::UniqueJob
  extend Resque::Plugins::Logger

  @queue = :Reservation_Import

  def self.perform(hotel_id)
    begin
      fail 'hotel_id is required' unless hotel_id

      logger.debug "Starting reservation import for hotel ID: #{hotel_id}"
      # Work around for the MySQL server has gone away error
      ActiveRecord::Base.verify_active_connections!
      hotel = Hotel.find(hotel_id)
      chain = hotel.hotel_chain

      if chain.batch_process_enabled
        # Get the updated reservation file for this hotel from the SFTP server, and process if found
        file = import_sftp_reservations(hotel)
        process_reservations(hotel, file) if file
      else
        logger.warn 'Reservation batch process disabled for hotel chain: ' + chain.code
      end
      logger.debug "Finished reservation import for hotel ID: #{hotel_id}"
    rescue => e
      logger.error "*******     An exception occured during reservation import  #{e.message}   *******"
      ExceptionNotifier.notify_exception(e)
    end
  end

  # Connect to the SFTP server and get reservations
  def self.import_sftp_reservations(hotel)
    chain = hotel.hotel_chain
    chain_code = chain.code
    hotel_code = hotel.code

    latest_file = nil

    sftp_respath = chain.settings.sftp_respath

    SftpUtility.new(chain).process lambda { |sftp|
      if hotel.is_third_party_pms_configured? && hotel.is_res_import_on
        logger.debug 'Checking for updated reservations for hotel: ' + hotel_code

        begin
          # Change to the SFTP hotel directory
          remote_dir = sftp_hotel_dir(sftp_respath, chain_code, hotel_code)

          # Create the local hotel directory if not present
          check_hotel_dir(chain_code, hotel_code)

          # Get the remote guest filenames sorted that matches the name stayntouchres####.txt
          guest_filenames = sftp.dir.glob(remote_dir, Setting.res_import_remote_guest_filename)
            .sort { |a, b| a.attributes.mtime <=> b.attributes.mtime }.map(&:name)

          # Get the latest file if we haven't loaded it yet
          latest_file = get_latest_guest_file(guest_filenames, hotel)

          if latest_file
            logger.debug "Importing #{latest_file[:filename]} file for #{chain_code}/#{hotel_code}"

            latest_filepath = File.join(remote_dir, latest_file[:filename])

            # Get the CSV file from the SFTP server and save it locally
            sftp.download!(latest_filepath, hotel_file(chain_code, hotel_code, Setting.res_import_local_guest_filename))

            file_created_at = Time.at(sftp.stat!(latest_filepath).mtime)
            logger.debug "File created_at: #{file_created_at}"

            # Set the hotel's last reservation update to now
            hotel.update_attributes(last_reservation_update: Time.now.utc, last_reservation_filename: latest_file[:filename])

            # Set the hotel's last daily update file
            hotel.settings.last_reservation_daily_filename = latest_file[:filename] if latest_file[:is_daily]

            # Add hotel to changed list
            latest_file[:created_at] = created_at
          else
            logger.debug "No new reservations file found for #{chain_code}/#{hotel_code}"
          end

          # Delete older files
          delete_old_files(sftp, remote_dir, guest_filenames)
        rescue Net::SFTP::StatusException => e
          logger.debug e.message
          logger.debug "Unable to get #{latest_file[:filename]} file for #{chain_code}/#{hotel_code}"
        end
      else
        logger.debug "Reservation import is disabled for the hotel #{hotel_code}"
      end
    }

    latest_file
  end

  # Process the updated reservations
  def self.process_reservations(hotel, file)
    rooms_for_due_in_alert = []
    start_time = Time.now
    import_count = 0
    ignore_count = 0
    rooms_for_due_in_alert = []
    logger.debug 'Processing reservations for hotel: ' + hotel.code

    hotel_details = ReservationImporter.hotel_details(hotel)

    # Process the hotel reservations CSV file, changing the column headers to lowercase
    CSV.foreach(hotel_file(hotel.hotel_chain.code, hotel.code, Setting.res_import_local_guest_filename),
                headers: true, col_sep: "\t", quote_char: "\x00", header_converters: :symbol, encoding: 'utf-8') do |row|
      begin
        # Convert the row into a hash using the headers as the keys
        attributes = row.to_hash
        had_previous_ready_room_for_checkin_alert = true
        if attributes[:hotel_code] == hotel.code
          # Find existing reservation by confirmation number

          reservation = hotel.reservations.where(confirm_no: attributes[:confirm_no]).first

          if reservation.present? && reservation.due_in?
              current_room = reservation.current_daily_instance.andand.room
              had_previous_ready_room_for_checkin_alert = current_room.present? ? current_room.is_ready? : false
          elsif !reservation.present?
            had_previous_ready_room_for_checkin_alert = false
          end

          last_updated = calculate_last_updated(attributes)

          # Only import the reservation if something has changed since the last import
          if !ignore_import?(last_updated, attributes, reservation, hotel, file)
            status = false
            structured_attributes = structure_attributes(hotel, attributes)

            # Create or update reservation from booking attributes
            if !reservation
              reservation = ReservationImporter.create_from_booking_attributes(hotel, hotel_details, structured_attributes)
              status = reservation.andand.persisted?
            else
              status = ReservationImporter.new(reservation, hotel_details: hotel_details).sync_booking_attributes(structured_attributes)
            end

            reservation.update_attributes(last_imported: last_updated) if status
            current_room = reservation.current_daily_instance.room if status
            if current_room.present? && reservation.due_in? &&  !had_previous_ready_room_for_checkin_alert
              rooms_for_due_in_alert << current_room if current_room.is_ready?
              logger.info "********** found ready room got assigned from pms **********" if current_room.is_ready?
              logger.info "*********     room number : #{current_room.room_no}    *********" if current_room.is_ready?
              logger.info "*********     reservation to alert : #{reservation.confirm_no}    *********" if current_room.is_ready?
            end

            import_count += 1
          else
            ignore_count += 1
          end
        else
          logger.error "Imported reservation's hotel code '#{attributes[:hotel_code]}' does not match our hotel code '#{hotel.code}'"
        end
      rescue Exception => ex
          logger.debug " *****   An Exception occured while importing the record from file -- #{ex.message}  ****"
      end
    end

    duration = Time.now - start_time
    logger.info "Import duration for hotel #{hotel.code}: #{duration} seconds / #{import_count} reservations (#{ignore_count} ignored)"

    #CICO-10336 - Alerting guest when due-in reservation got room assigned from pms
    logger.info "************   starting email alert for room assigned due in reservations   ****************"
    hotel.alert_due_in_guests_on_room_status_change(rooms_for_due_in_alert) unless rooms_for_due_in_alert.empty?
  end

  # Check if local chain and hotel directories exist and create them if not
  def self.check_hotel_dir(chain_code, hotel_code)
    reservations_path = Setting.res_import_local_dir
    chain_path = File.join(reservations_path, chain_code)
    hotel_path = File.join(chain_path, hotel_code)

    Dir.mkdir(reservations_path) unless Dir.exist?(reservations_path)
    Dir.mkdir(chain_path) unless Dir.exist?(chain_path)
    Dir.mkdir(hotel_path) unless Dir.exist?(hotel_path)
  end

  # Get the path to the hotel reservations file
  def self.hotel_file(chain_code, hotel_code, filename)
    File.join(Setting.res_import_local_dir, chain_code, hotel_code, filename)
  end

  # Changes the SFTP directory to the hotel directory
  def self.sftp_hotel_dir(sftp_respath, chain_code, hotel_code)
    File.join(sftp_respath, chain_code, hotel_code)
  end

  # Get the latest guest filename for the hotel, if it wasn't the last one loaded
  def self.get_latest_guest_file(guest_filenames, hotel)
    latest_daily_file(guest_filenames, hotel) || latest_standard_file(guest_filenames, hotel)
  end

  # Get the latest standard filename, if it wasn't already loaded
  def self.latest_standard_file(guest_filenames, hotel)
    latest_filename = guest_filenames.last
    (latest_filename.present? && latest_filename != hotel.last_reservation_filename) ? { filename: latest_filename, is_daily: false } : nil
  end

  # Get the latest daily filename, if it wasn't already loaded
  def self.latest_daily_file(guest_filenames, hotel)
    latest_filename = guest_filenames.select { |filename| filename =~ Setting.daily_filename_pattern }.last
    (latest_filename.present? && latest_filename != hotel.settings.last_reservation_daily_filename) ? { filename: latest_filename, is_daily: true } : nil
  end

  # Delete old files. Only keep X files total.
  def self.delete_old_files(sftp, remote_dir, guest_filenames)
    # Get all files except the last X
    older_filenames = guest_filenames[0..-(Setting.res_import_remote_files_to_keep + 1)]

    older_filenames.each do |older_filename|
      sftp.remove(File.join(remote_dir, older_filename))
    end
  end

  # Gets the last update time on the external pms, comparing the reservation and guest timestamps
  def self.calculate_last_updated(attributes)
    reservation_last_updated = attributes[:last_reservation_update_date] && Time.parse(attributes[:last_reservation_update_date])
    guest_last_updated = attributes[:last_guest_update_date] && Time.parse(attributes[:last_guest_update_date])

    if reservation_last_updated && guest_last_updated
      reservation_last_updated > guest_last_updated ? reservation_last_updated : guest_last_updated
    end
  end

  # Determines if the reservation should be imported or not
  def self.ignore_import?(last_updated, attributes, reservation, hotel, file)
    status = ExternalMapping.map_external_system_value(hotel.pms_type, attributes[:status], Setting.mapping_types[:reservation_status])

    locally_changed?(reservation, file) ||
      (file[:is_daily] && !externally_changed?(last_updated, reservation) && !due_in?(status, attributes, hotel) && !checked_out?(status))
  end

  def self.due_in?(status, attributes, hotel)
    Ref::ReservationStatus[status] === :RESERVED && Date.parse(attributes[:arrival_date]) == hotel.active_business_date
  end

  def self.checked_out?(status)
    Ref::ReservationStatus[status] === :CHECKEDOUT
  end

  # Checks if the reservation has changed locally since the time that the import file was created
  def self.locally_changed?(reservation, file)
    local_updated_at = reservation.andand.updated_at
    file[:created_at] && local_updated_at && file[:created_at] < local_updated_at
  end

  # Checks if the reservation or guest has been updated since the last time this reservation was imported
  def self.externally_changed?(last_updated, reservation)
    last_imported = reservation.andand.last_imported
    !last_imported || !last_updated || last_updated > last_imported
  end

  # Structure attributes as needed for import
  def self.structure_attributes(hotel, attributes)
    structured_attributes = {
      guest: {
        title: attributes[:title],
        first_name: attributes[:first_name],
        last_name: attributes[:last_name],
        vip: attributes[:vip],
        guest_id: attributes[:guest_id]
      },
      membership: {
        membership_type: attributes[:membership_type],
        membership_card_number: attributes[:membership_no],
        membership_level: attributes[:membership_level],
        external_id: attributes[:membership_id]
      },
      payment_type: {
        credit_card_type: attributes[:payment_method],
        mli_token: attributes[:card_token],
        card_expiry: format_expiration_date(attributes[:credit_card_exp_date]),
        card_name: attributes[:card_name],
        is_swiped: attributes[:is_swiped]
      },
      accompanying_guests: map_accompanying_guests(attributes)
    }

    # Add email attributes
    structured_attributes[:guest][:emails] = [
      { value: attributes[:email], external_id: attributes[:email_id], contact_type: :EMAIL, label: :HOME, is_primary: true }
    ] if attributes[:email]

    # Set all accessible attributes for the reservation into the structure
    Reservation.attr_accessible[:default].to_a.each do |attribute|
      attr_sym = attribute.to_sym
      structured_attributes[attr_sym] = attributes[attr_sym] if attributes.key?(attr_sym)
    end

    # convert the time to nil if arrival and departure time has 00:00 as they are default times if no arival and departure is specified
    structured_attributes[:arrival_time] = convert_time_to_nil(structured_attributes[:arrival_time])
    structured_attributes[:departure_time] = convert_time_to_nil(structured_attributes[:departure_time])

    arrival_date = Date.parse(attributes[:arrival_date])
    dep_date = Date.parse(attributes[:dep_date])

    # Construct the daily instances
    structured_attributes[:daily_instances] = []
    (arrival_date..dep_date).each do |day|
      structured_attributes[:daily_instances] << {
        reservation_date: day,
        room_type_info: {
          room_type: attributes[:room_type]
        },
        group_info: {
          code: attributes[:block_code],
          block_name: attributes[:block_name]
        },
        room: attributes[:room_no],
        rate_amount: attributes[:rate_amount],
        currency_code: attributes[:currency_code],
        adults: attributes[:adults],
        children: attributes[:children],
        is_from_import: true
      }
    end

    structured_attributes
  end

  # Takes an expiration date in the format MM/YY and converts it to YYYY-MM-DD. It may be masked.
  def self.format_expiration_date(card_expiry)
    new_card_expiry = card_expiry

    if card_expiry.present?
      is_masked = card_expiry.to_s.downcase.count('x') > 0
      new_card_expiry = !is_masked ? Date.strptime(card_expiry, '%m/%y').strftime('%Y-%m-%d') : 'XXXX-XX-XX'
    end

    new_card_expiry
  end

  # Method to convert midnight time to nil as that's default time
  def self.convert_time_to_nil(in_time)
    if in_time == '00:00'
      return nil
    else
      return in_time
    end
  end

  def self.map_accompanying_guests(attributes)
    accompanying_guests = []
    # The accompanying guest information is received as  : accompanying_guests=>"Dehler, Nicole Nikki / Becerra, Iska",
    accompanying_guest_full_names = attributes[:accompanying_guests].present? ? attributes[:accompanying_guests].split('/') : nil
    accompanying_guest_full_names.each do |guest|
     accompanying_guests << {
        last_name: guest.split(',')[0].to_s,
        first_name: guest.split(',')[1].to_s
      }
    end if accompanying_guest_full_names.present?
    accompanying_guests
  end
end
