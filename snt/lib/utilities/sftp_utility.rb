require 'net/sftp'

class SftpUtility
  # Initialize the SFTP configuration
  def initialize(chain)
    @chain_code = chain.code

    # Retrieve the SFTP information from the product config
    @sftp_location = chain.settings.sftp_location
    @sftp_port = chain.settings.sftp_port.present? ? chain.settings.sftp_port : 22 # default to port 22
    @sftp_user = chain.settings.sftp_user
    @sftp_password = chain.decrypt_pswd(chain.settings.sftp_password)
    @sftp_respath = chain.settings.sftp_respath.to_s
  end

  # Process a closure after connecting to the SFTP server. Return whether it was successful or not.
  def process(closure)
    status = false

    if @sftp_location && @sftp_user && @sftp_password && @sftp_respath
      begin
        Net::SFTP.start(@sftp_location, @sftp_user, password: @sftp_password, port: @sftp_port, timeout: Setting.sftp_timeout) do |sftp|
          # Execute closure
          closure.call(sftp)
        end

        status = true
      rescue => e
        logger.error e.message
      end
    else
      logger.debug "SFTP not configured for hotel chain #{@chain_code}"
    end

    status
  end

  # Create the chain directory
  def create_chain_dir
    process lambda { |sftp|
      # Switch to the reservation directory (create if it doesn't exist)
      make_dir(sftp)
      # Switch to the hotel chain directory (create if it doesn't exist)
      make_dir(sftp, @chain_code)
    }
  end

  # Create the hotel_directory
  def create_hotel_dir(hotel_code)
    process lambda { |sftp|
      # Switch to the hotel chain directory (create if it doesn't exist)
      make_dir(sftp, @chain_code)

      # Switch to the hotel directory (create if it doesn't exist)
      make_dir(sftp, @chain_code + '/' + hotel_code)
    }
  end

  # Rename the chain_directory
  def rename_chain_dir(old_name, new_name)
    rename_file(@sftp_respath, old_name, new_name)
  end

  # Rename the hotel directory
  def rename_hotel_dir(old_name, new_name)
    rename_file(File.join(@sftp_respath), @chain_code + '/' + old_name, @chain_code + '/' + new_name)
  end

  private

  # Rename a file or directory under the base directory (make if it doesn't exist)
  def rename_file(base_directory, old_name, new_name)
    process lambda { |sftp|
      begin
        sftp.rename!(File.join(base_directory, old_name), File.join(base_directory, new_name))
      rescue Net::SFTP::StatusException
        make_dir(sftp, new_name)
      end
    }
  end

  # Create directory if it doesn't exist
  def make_dir(sftp, dir = nil)
    begin
      if dir
        sftp.mkdir!(File.join(@sftp_respath, dir))
      else
        sftp.mkdir!(@sftp_respath)
      end
    rescue Net::SFTP::StatusException => e
      logger.debug e.message
    end
  end
end
