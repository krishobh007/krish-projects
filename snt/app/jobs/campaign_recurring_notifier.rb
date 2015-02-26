class CampaignRecurringNotifier
  include Resque::Plugins::UniqueJob
  extend Resque::Plugins::Logger

  @queue = :Campaign_Recurring_Notifier

  def self.perform
    logger.debug 'Campaign Recurring notifier'
    # begin
      ActiveRecord::Base.verify_active_connections!
      hotels = Hotel.all
      hotels.each do |hotel|
        logger.debug "Campaign Recurring notifier in Hotel_id #{hotel.id}"
        campaigns = hotel.campaigns
        campaigns.each do |campaign|
          if campaign.is_recurring && campaign.is_not_completed
            logger.debug "Campaign Recurring notifier for campaign_id #{campaign.id}"
            if campaign.status ==  "ACTIVE"
              if campaign.day_of_week.titlecase == hotel.active_business_date.strftime('%A')
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
                logger.debug "Campaign Recurring notifier with audience_type : #{audience_type}"
                
                reservations.each do |reservation|
                  logger.debug "Campaign Recurring notifier for reservation_id : #{reservation.id}"
                  begin
                    NotificationDetail.create_campaign_notification(campaign, reservation)
                  rescue Exception => e
                    logger.error "Error in Campaign Recurring Notifier , #{e.message}"
                  end
                end
              end
            end
          end
        end
      end
    # rescue => e
    #   ExceptionNotifier.notify_exception(e)
    #   logger.warn "Error in Campaign Recurring Notifier , #{e.message}"
    # end
  end
end
