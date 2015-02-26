class CampaignOneTimeNotifier
  include Resque::Plugins::UniqueJob
  extend Resque::Plugins::Logger

  @queue = :Campaign_One_Time_Notifier

  def self.perform(campaign_id=nil)
    logger.debug 'Campaign OneTime Notifier'
     # begin
      # Work around for the MySQL server has gone away error
      ActiveRecord::Base.verify_active_connections!
      if campaign_id.present?
        campaign = Campaign.find(campaign_id)
        hotel = campaign.hotel
        logger.debug "Campaign_One_Time_Notifier in Hotel #{hotel.id}"
        audience_type = campaign.audience_type.value
        if audience_type == "DUE_IN_GUESTS"
          reservations = Reservation.due_in_list(campaign.hotel.id)
        elsif audience_type == "IN_HOUSE_GUESTS"
          reservations = Reservation.inhouse_list(campaign.hotel.id)
        elsif audience_type == "EVERYONE"
          reservations = hotel.reservations
        elsif audience_type == "SPECIFIC_USERS"
          reservations = campaign.guest_details.first.reservations if campaign.guest_details.present?
        end
        logger.debug "Campaign_One_Time_Notifier with audience_type : #{audience_type}"

        if reservations
          reservations.each do |reservation|
            logger.debug "Campaign_One_Time_Notifier for reservation_id : #{reservation.id}"
            begin
              NotificationDetail.create_campaign_notification(campaign, reservation)
            rescue => e
              logger.error "Error in Campaign OneTime Notifier, #{e.message }"
            end
            campaign.update_attributes(:status => :COMPLETED)
          end
        end
      end
     # rescue => e
     #   ExceptionNotifier.notify_exception(e)
     #   logger.warn "Error in Campaign OneTime Notifier, #{e.message }"
     # end
  end
end
