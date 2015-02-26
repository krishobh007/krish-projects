class UpdateHotelBusinessDate
  include Resque::Plugins::UniqueJob
  extend Resque::Plugins::Logger

  @queue = :Update_Hotel_Business_Date

  def self.perform(hotel_id=nil)
    logger.debug 'Updating hotel business dates'
    begin
      # Work around for the MySQL server has gone away error
      ActiveRecord::Base.verify_active_connections!
      if hotel_id.present?
        hotel = Hotel.find(hotel_id)
        begin
          hotel.end_of_day_process
        rescue Exception=>ex
          logger.debug "exception in business date updation process for hotel code - #{hotel.code}"
          logger.debug ex
          ExceptionNotifier.notify_exception(ex)
          hotel.update_attributes({:is_eod_in_progress => false, :is_eod_manual_started => false}) if !hotel.is_third_party_pms_configured?
        end
        hotel.update_attributes({:is_eod_in_progress => false, :is_eod_manual_started => false}) if !hotel.is_third_party_pms_configured?
      else
        # Sync the business date for each of the hotels
        HotelBusinessDate.outdated.each do |business_date|
          hotel = business_date.hotel
          logger.debug "Syncing business date for hotel: #{hotel.code}"
          if hotel.is_third_party_pms_configured?
            begin
              hotel.sync_business_date_with_external_pms
            rescue Exception=>ex
              ExceptionNotifier.notify_exception(ex)  
              logger.warn "Encountered error for hotel #{hotel.code}: #{ex.message}"
            end
          elsif hotel.settings.is_auto_change_bussiness_date &&
            ActiveSupport::TimeZone[hotel.tz_info].parse(hotel.settings.business_date_change_time.in_time_zone(hotel.tz_info).strftime('%H:%M')).between?((Time.now.in_time_zone(hotel.tz_info) - 240), Time.now.in_time_zone(hotel.tz_info))
            logger.debug "***********    Its time for updating the EOD process for hotel : #{hotel.code}    ***********"
            hotel.update_attribute(:is_eod_in_progress, true)
            hotel.end_of_day_process
            hotel.update_attribute(:is_eod_in_progress, false)
            logger.debug "***********    Completed the EOD process for hotel : #{hotel.code}    ***********"
          end
        end
      end
    rescue Exception=>ex
      ExceptionNotifier.notify_exception(ex)
      logger.warn "Error in business date updation" + ex.message 
    end
  end
  
end
