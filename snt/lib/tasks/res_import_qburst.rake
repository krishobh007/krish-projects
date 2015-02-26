require 'resque/tasks'
require 'resque_scheduler'
require 'net/ftp'
require 'csv'

namespace :pms_qburst do
  
  desc "Imports a CSV reservation file into a reservations table"
  
  task :res_import, [:hotel_chain_id] => :environment do |task,args|
    
    raise "hotel_chain_id is required" if !args[:hotel_chain_id]
    
    logger.debug "Starting reservation import for hotel chain ID: " + args[:hotel_chain_id]
    
    # Get the hotel chain information
    chain = HotelChain.find_by_id(args[:hotel_chain_id])
    
    if chain
      if chain.batch_process_enabled        
        # Get the updated reservation files for this chain from the FTP server
        changed_hotels = import_ftp_reservations(chain)
        
        # Parse the updated reservation files and update our reservations
        process_reservations(chain, changed_hotels)
      else
        logger.warn "Reservation batch process disabled for hotel chain: " + chain.code
      end
    else
      logger.warn "Could not find hotel chain for ID: " + args[:hotel_chain_id]
    end
    
    logger.debug "Finished reservation import for hotel chain ID: " + args[:hotel_chain_id]
    
  end
  
end


private
  
  # Connect to the FTP server and get reservations
  def self.import_ftp_reservations(chain)      
    chain_code = chain.code     
    hotels = chain.hotels

    logger.debug "Getting reservations from FTP server for chain: " + chain_code
 
    changed_hotels = Array.new
      
    # Retrieve the FTP information from the product config
    ftp_location = chain.settings.ftp_location
    ftp_user = chain.settings.ftp_user
    ftp_password = chain.settings.ftp_password
    ftp_respath = chain.settings.ftp_respath

    # Login to the FTP server
    ftp = Net::FTP.new(ftp_location, ftp_user, ftp_password)
    ftp.login(ftp_user, ftp_password)

    # Set the FTP connection to passive mode
    ftp.passive = true
     
    logger.debug "Connected to FTP server"
    
    hotels.each do |hotel|
      hotel_code = hotel.code
      
      logger.debug "Checking for updated reservations for hotel: " + hotel_code
      
      begin
        # Change to the FTP hotel directory
        ftp_hotel_dir(ftp, ftp_respath, chain_code, hotel_code)
                        
        # Create the local hotel directory if not present
        check_hotel_dir(chain_code, hotel_code)
        
        # Get the remote guest filenames sorted that matches the name stayntouchres####.txt
        guest_filenames = ftp.nlst(Setting.res_import_remote_guest_filename).sort
        
        # Get the latest file if we haven't loaded it yet
        latest_filename = get_latest_guest_filename(guest_filenames, hotel)          
        
        if latest_filename
          logger.debug "Importing #{latest_filename} file for #{chain_code}/#{hotel_code}"
          
          # Get the CSV file from the FTP server and save it locally                    
          ftp.gettextfile(latest_filename, hotel_file(chain_code, hotel_code, Setting.res_import_local_guest_filename))
                  
          # Set the hotel's last reservation update to now
          hotel.update_attributes(:last_reservation_update => Time.now.utc, :last_reservation_filename => latest_filename)        
                    
          # Add hotel to changed list
          changed_hotels << hotel
        else
          logger.debug "No new reservations file found for #{chain_code}/#{hotel_code}"        
        end
        
        # Delete older files
        delete_old_files(ftp, guest_filenames)
        
      rescue Net::FTPPermError => e
        logger.debug e.message
        logger.debug "Unable to get #{latest_filename} file for #{chain_code}/#{hotel_code}"
      end
    end
    
    # We're done, so we need to close the connection
    ftp.close
    
    changed_hotels
  end
  
  
  # Process the updated reservations
  def self.process_reservations(chain, changed_hotels)
    chain_code = chain.code
    
    # Iterate through the changed hotels and load the csv files for them
    changed_hotels.each do |hotel|
      logger.debug "Processing reservations for hotel: " + hotel.code

      # Process the hotel reservations file, changing the column headers to lowercase
      CSV.foreach(hotel_file(chain_code, hotel.code, Setting.res_import_local_guest_filename), :headers => true, :col_sep => "\t", :header_converters => :symbol) do |row|
        # Convert the row into a hash using the headers as the keys
        attributes = row.to_hash        
        
        if attributes[:hotel_code] == hotel.code
          # Find existing reservation by confirmation number
          reservation = Reservation.where(:hotel_id => hotel.id, :confirm_no => attributes[:confirm_no]).first                 
          
          structured_attributes = structure_attributes(attributes)

          # Create or update reservation from booking attributes
          if !reservation
            ReservationImporter.create_from_booking_attributes(hotel, structured_attributes)                            
          else
            ReservationImporter.new(reservation).sync_booking_attributes(structured_attributes)
          end       
        else
          logger.error "Imported reservation's hotel code '#{attributes[:hotel_code]}' does not match our hotel code '#{hotel.code}'"
        end           
      end
    end
  end


  # Check if local chain and hotel directories exist and create them if not
  def self.check_hotel_dir(chain_code, hotel_code)
    reservations_path = Setting.res_import_local_dir
    chain_path = File.join(reservations_path, chain_code)
    hotel_path = File.join(chain_path, hotel_code)
    
    if !Dir.exists?(reservations_path)
      Dir.mkdir(reservations_path)
    end
          
    if !Dir.exists?(chain_path)
      Dir.mkdir(chain_path)
    end
    
    if !Dir.exists?(hotel_path)        
      Dir.mkdir(hotel_path)
    end
  end
  
  # Get the path to the hotel reservations file
  def self.hotel_file(chain_code, hotel_code, filename)
    File.join(Setting.res_import_local_dir, chain_code, hotel_code, filename)
  end

  # Changes the FTP directory to the hotel directory
  def self.ftp_hotel_dir(ftp, ftp_respath, chain_code, hotel_code)
    dir = File.join(ftp_respath, chain_code, hotel_code)
    ftp.chdir(dir)
  end
  
  # Get the latest guest filename for the hotel, if it wasn't the last one loaded
  def self.get_latest_guest_filename(guest_filenames, hotel)
    latest_filename = guest_filenames.last
    latest_filename != hotel.last_reservation_filename ? latest_filename : nil
  end
  
  # Delete old files. Only keep X files total.
  def self.delete_old_files(ftp, guest_filenames)
    # Get all files except the last X
    older_filenames = guest_filenames[0..-(Setting.res_import_remote_files_to_keep+1)]
    
    older_filenames.each do |older_filename|
      ftp.delete(older_filename)
    end    
  end
  
  # Structure attributes as needed for import
  def self.structure_attributes(attributes)    
    structured_attributes = {
      :guest => {
        :email => attributes[:email],
        :title => attributes[:title],
        :first_name => attributes[:first_name],
        :last_name => attributes[:last_name],
        :birthday => attributes[:birthday],
        :language => attributes[:language],
        :nationality => attributes[:nationality],
        :vip => attributes[:vip],
        :passport_no => attributes[:passport_no]
      },
      :payment_type => {
        :card_number => attributes[:credit_card_no],
        :card_expiry => attributes[:credit_card_exp_date],
        :credit_card_type => attributes[:credit_card_type]
      },
      :membership => {
        :membership_type => attributes[:membership_type],
        :membership_card_number => attributes[:membership_no],
        :membership_level => attributes[:membership_level]
      }
    }
    
    # Set all accessible attributes for the reservation into the structure
    Reservation.attr_accessible[:default].to_a.each do |attribute|
      attr_sym = attribute.to_sym
      structured_attributes[attr_sym] = attributes[attr_sym] if attributes.has_key?(attr_sym)    
    end
    
    arrival_date = Date.parse(attributes[:arrival_date])
    dep_date = Date.parse(attributes[:dep_date])
    
    # Construct the daily instances
    structured_attributes[:daily_instances] = []
    (arrival_date..dep_date).each do |day|
      structured_attributes[:daily_instances] << {
        :reservation_date => day,
        :room_type_info => {
          :room_type => attributes[:room_type],
          :no_of_rooms => attributes[:total_rooms]
        },
        :rate_info => {
          :rate_desc => attributes[:rate_code],
          :market_segment => attributes[:market_segment],
          :currency_code => attributes[:currency_code]
        },
        :group_info => {
          :code => attributes[:block_code]
        },
        :room => attributes[:room_no],
        :rate_amount => attributes[:rate_amount], 
        :currency_code => attributes[:currency_code],
        :market_segment => attributes[:market_segment], 
        :adults => attributes[:adults], 
        :children => attributes[:children],
        :company_id => attributes[:company_id],
        :travel_agent_id => attributes[:travel_agent_id]
      }
    end
        
    structured_attributes
end

