require 'csv'

class SmartBandImport
  extend Resque::Plugins::Logger
  include Resque::Plugins::UniqueJob

  @queue = :Smartband_Import

  def self.perform(hotel_id)
    begin
      hotel = Hotel.find(hotel_id)
      logger.debug "*** Starting smartband import for hotel ID: #{hotel.code}"
      # Work around for the MySQL server has gone away error
      ActiveRecord::Base.verify_active_connections!
      if hotel.hotel_chain.batch_process_enabled
        process_smartband_import_files(hotel) if import_sftp_smartbands(hotel)
        logger.debug "Finished smartbands import for hotel ID: #{hotel.code}"
      else
        logger.warn 'Smartbands import batch process disabled for hotel chain: ' + chain.code
      end
    rescue => e
      logger.error "*****     An exception occured during smartbands import  #{e.message}   *******"
      ExceptionNotifier.notify_exception(e)
    end
  end

  # Connect to the SFTP server and get smartband files
  def self.import_sftp_smartbands(hotel)
    chain = hotel.hotel_chain
    chain_code = chain.code
    hotel_code = hotel.code
    changed = false
    sftp_respath = chain.settings.sftp_respath

    SftpUtility.new(chain).process lambda { |sftp|
      if hotel.is_third_party_pms_configured? && hotel.settings.icare_enabled
        logger.debug 'Checking for updated smartbands for hotel: ' + hotel_code

        begin
          # Change to the SFTP hotel directory
          remote_dir = sftp_hotel_dir(sftp_respath, chain_code, hotel_code)

          # Create the local hotel directory if not present
          check_hotel_dir(chain_code, hotel_code)

          # Get the remote smartband filenames sorted that matches the name stayntouchsmartbands*.txt
          smartband_filenames = sftp.dir.glob(remote_dir, Setting.smart_bands_import_filename)
            .sort { |a, b| a.attributes.mtime <=> b.attributes.mtime }.map(&:name)
          latest_filename = smartband_filenames.last

          # Get the latest file if we haven't loaded it yet
          if latest_filename
            logger.debug "Importing #{latest_filename} file for #{chain_code}/#{hotel_code}"

            # Get the CSV file from the SFTP server and save it locally
            sftp.download!(File.join(remote_dir, latest_filename), hotel_file(chain_code, hotel_code, Setting.smart_bands_import_local_filename))
            changed = true
          else
            logger.debug "No new smartbands file found for #{chain_code}/#{hotel_code}"
          end

          # Delete older files
          delete_old_files(sftp, remote_dir, smartband_filenames)
        rescue Net::SFTP::StatusException => e
          logger.debug e.message
          logger.debug "Unable to get #{latest_filename} file for #{chain_code}/#{hotel_code}"
        end
      else
        logger.debug "Reservation import is disabled for the hotel #{hotel_code}"
      end
    }

    changed
  end

  def self.sftp_hotel_dir(sftp_respath, chain_code, hotel_code)
    File.join(sftp_respath, chain_code, hotel_code)
  end

  # Delete old files. Only keep X files total.
  def self.delete_old_files(sftp, remote_dir, smartband_filenames)
    # Get all files except the last X
    older_filenames = smartband_filenames[0..-(Setting.smartbands_import_remote_files_to_keep + 1)]

    older_filenames.each do |older_filename|
      sftp.remove(File.join(remote_dir, older_filename))
    end
  end

  def self.hotel_file(chain_code, hotel_code, filename)
    File.join(Setting.smartbands_local_dir, chain_code, hotel_code, filename)
  end

  # Process the updated smartband files
  def self.process_smartband_import_files(hotel)
    start_time = Time.now
    import_count = 0
    ignore_count = 0

    logger.debug 'Processing smartbands for hotel: ' + hotel.code

    # Process the hotel smartbands CSV file, changing the column headers to lowercase
    CSV.foreach(hotel_file(hotel.hotel_chain.code, hotel.code, Setting.smart_bands_import_local_filename),
                headers: true, col_sep: "\t", quote_char: "\x00", header_converters: :symbol, encoding: 'ISO-8859-1') do |row|
      # Convert the row into a hash using the headers as the keys
      attributes = row.to_hash

      if attributes[:hotel_code] == hotel.code
        if attributes[:reservation_id]
          # Find existing reservation by confirmation number
          reservation = hotel.reservations.where(external_id: attributes[:reservation_id]).first

          if reservation
            existing_smartband = reservation.smartbands.find_by_account_number(attributes[:account_id])
            structured_attributes = structure_attributes(attributes)

            # Only import the reservation if something has changed since the last import
            begin
              if existing_smartband.present?
                if reservation_smartband_changed?(attributes, existing_smartband)
                  existing_smartband.update_attributes!(structured_attributes)
                  import_count += 1
                else
                  ignore_count += 1
                end
              else
                reservation.smartbands.create!(structured_attributes)
                import_count += 1
              end
            rescue ActiveRecord::RecordInvalid => e
              logger.debug e.message
              logger.debug "SmartBand Import failure for Hotel - #{attributes[:hotel_code]} with
                            external_id - #{attributes[:reservation_id]} Reason for failure - #{e.message}"
              ignore_count += 1
            end
          else
            logger.debug "Reservation with external_id #{attributes[:reservation_id]} is not available"
          end
        else
          logger.debug 'Reservation ID does not present in the import attributes'
        end
      else
        logger.error "Imported smartband's hotel code '#{attributes[:hotel_code]}' does not match our hotel code '#{hotel.code}'"
      end
    end

    hotel.update_attributes(last_smartband_imported: Time.now.utc)

    duration = Time.now - start_time
    logger.debug "Import duration for hotel #{hotel.code}: #{duration} seconds / #{import_count} smartbands (#{ignore_count} ignored)"
  end

  # Checks if the smartband has been updated since the last time this smartband was imported
  def self.reservation_smartband_changed?(attributes, smartband)
    last_imported = smartband.andand.updated_at
    ows_last_updated = Time.parse(attributes[:last_update_date])
    !last_imported || ows_last_updated > last_imported
  end

  def self.structure_attributes(attributes)
    {
      first_name: attributes[:first_name],
      last_name: attributes[:last_name],
      account_number: attributes[:account_id],
      is_fixed: attributes[:stored_yn] == 'Y',
      amount: attributes[:credit_issued] || 0
    }
  end

  # Check if local chain and hotel directories exist and create them if not
  def self.check_hotel_dir(chain_code, hotel_code)
    smartbands_path = Setting.smartbands_local_dir
    chain_path = File.join(smartbands_path, chain_code)
    hotel_path = File.join(chain_path, hotel_code)
    Dir.mkdir(smartbands_path) unless Dir.exist?(smartbands_path)
    Dir.mkdir(chain_path) unless Dir.exist?(chain_path)
    Dir.mkdir(hotel_path) unless Dir.exist?(hotel_path)
  end
end
