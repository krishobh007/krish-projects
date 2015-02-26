class RoomStatusImport
  include Resque::Plugins::UniqueJob
  extend Resque::Plugins::Logger

  @queue = :Room_Status_Import

  def self.perform(hotel_chain_id)
    logger.debug "Starting room status import for hotel_chain_id #{hotel_chain_id}"

    begin
      # Work around for the MySQL server has gone away error
      ActiveRecord::Base.verify_active_connections!
      chain = HotelChain.find(hotel_chain_id)

      chain.hotels.each do |hotel|
        if hotel.is_third_party_pms_configured?
          begin
            Room.sync_external_room_status(hotel.id, '', '')
          rescue => e
            logger.warn "Encountered error for hotel #{hotel.code}: #{e.message}"
            ExceptionNotifier.notify_exception(e)
          end
        end
      end
    rescue => e
      ExceptionNotifier.notify_exception(e)
    end
  end
end
