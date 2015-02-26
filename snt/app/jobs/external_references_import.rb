require 'csv'

class ExternalReferencesImport
  include Resque::Plugins::UniqueJob
  extend Resque::Plugins::Logger

  @queue = :External_References_Import

  def self.perform(hotel_id)
    fail 'hotel_id is required' unless hotel_id

    logger.debug "Starting external references import for hotel ID: #{hotel_id}"

    # Work around for the MySQL server has gone away error
    ActiveRecord::Base.verify_active_connections!

    hotel = Hotel.find(hotel_id)
    chain = hotel.hotel_chain

    if chain.batch_process_enabled
      # Get the updated external references file for this hotel from the SFTP server, and process if found
      file = import_sftp_external_references(hotel)
      process_external_references(hotel, file) if file
    else
      logger.warn 'Batch process disabled for hotel chain: ' + chain.code
    end

    logger.debug "Finished external references import for hotel ID: #{hotel_id}"
  rescue => e
    logger.error "*******     An exception occured during external references import  #{e.message}   *******"
    ExceptionNotifier.notify_exception(e)
  end

  # Connect to the SFTP server and get external references
  def self.import_sftp_external_references(hotel)
    chain = hotel.hotel_chain
    chain_code = chain.code
    hotel_code = hotel.code

    latest_file = nil

    sftp_path = chain.settings.sftp_respath

    SftpUtility.new(chain).process lambda { |sftp|
      if hotel.is_third_party_pms_configured? && hotel.is_external_references_import_on
        logger.debug 'Checking for new external references for hotel: ' + hotel_code

        begin
          # Change to the SFTP hotel directory
          remote_dir = sftp_hotel_dir(sftp_path, chain_code, hotel_code)

          # Create the local hotel directory if not present
          check_hotel_dir(chain_code, hotel_code)

          # Get the remote filenames sorted that matches the name stayntouchextref####.txt
          filenames = sftp.dir.glob(remote_dir, Setting.external_references_import_remote_filename)
            .sort { |a, b| a.attributes.mtime <=> b.attributes.mtime }.map(&:name)

          # Get the latest file if we haven't loaded it yet
          latest_file = get_latest_file(filenames, hotel)

          if latest_file
            logger.debug "Importing #{latest_file[:filename]} file for #{chain_code}/#{hotel_code}"

            # Get the CSV file from the SFTP server and save it locally
            sftp.download!(File.join(remote_dir, latest_file[:filename]),
                           hotel_file(chain_code, hotel_code, Setting.external_references_import_local_filename))

            # Set the hotel's last external references update to now
            hotel.update_attributes(last_external_references_update: Time.now.utc, last_external_references_filename: latest_file[:filename])
          else
            logger.debug "No new external references file found for #{chain_code}/#{hotel_code}"
          end

          # Delete older files
          delete_old_files(sftp, remote_dir, filenames)
        rescue Net::SFTP::StatusException => e
          logger.debug e.message
          logger.debug "Unable to get #{latest_file[:filename]} file for #{chain_code}/#{hotel_code}"
        end
      else
        logger.debug "External references import is disabled for the hotel #{hotel_code}"
      end
    }

    latest_file
  end

  # Process the new external references
  def self.process_external_references(hotel, file)
    start_time = Time.now
    import_count = 0
    logger.debug 'Processing external references for hotel: ' + hotel.code

    # Process the hotel external references CSV file, changing the column headers to lowercase
    CSV.foreach(hotel_file(hotel.hotel_chain.code, hotel.code, Setting.external_references_import_local_filename),
                headers: true, col_sep: "\t", quote_char: "\x00", header_converters: :symbol, encoding: 'utf-8') do |row|
      begin
        # Convert the row into a hash using the headers as the keys
        attributes = row.to_hash

        if attributes[:hotel_code] == hotel.code
          # Find existing reservation by confirmation number
          reservation = hotel.reservations.where(confirm_no: attributes[:confirmation_no]).first

          if reservation
            external_reference_attributes = {
              value: attributes[:external_reference],
              description: attributes[:external_reference_type],
              reference_type: :CONFIRMATION_NUMBER
            }

            external_reference = reservation.external_references.build(external_reference_attributes)

            import_count += 1 if external_reference.save
          end
        else
          logger.error "Imported reservation's hotel code '#{attributes[:hotel_code]}' does not match our hotel code '#{hotel.code}'"
        end
      rescue => ex
        logger.error " *****   An Exception occured while importing the record from file -- #{ex.message}  ****"
      end
    end

    duration = Time.now - start_time
    logger.info "Import duration for hotel #{hotel.code}: #{duration} seconds / #{import_count} external references"
  end

  # Check if local chain and hotel directories exist and create them if not
  def self.check_hotel_dir(chain_code, hotel_code)
    external_references_path = Setting.external_references_import_local_dir
    chain_path = File.join(external_references_path, chain_code)
    hotel_path = File.join(chain_path, hotel_code)

    Dir.mkdir(external_references_path) unless Dir.exist?(external_references_path)
    Dir.mkdir(chain_path) unless Dir.exist?(chain_path)
    Dir.mkdir(hotel_path) unless Dir.exist?(hotel_path)
  end

  # Get the path to the hotel external references file
  def self.hotel_file(chain_code, hotel_code, filename)
    File.join(Setting.external_references_import_local_dir, chain_code, hotel_code, filename)
  end

  # Changes the SFTP directory to the hotel directory
  def self.sftp_hotel_dir(sftp_path, chain_code, hotel_code)
    File.join(sftp_path, chain_code, hotel_code)
  end

  # Get the latest filename for the hotel, if it wasn't the last one loaded
  def self.get_latest_file(filenames, hotel)
    latest_filename = filenames.last
    (latest_filename.present? && latest_filename != hotel.last_external_references_filename) ? { filename: latest_filename } : nil
  end

  # Delete old files. Only keep X files total.
  def self.delete_old_files(sftp, remote_dir, filenames)
    # Get all files except the last X
    older_filenames = filenames[0..-(Setting.external_references_import_remote_files_to_keep + 1)]

    older_filenames.each do |older_filename|
      sftp.remove(File.join(remote_dir, older_filename))
    end
  end
end
