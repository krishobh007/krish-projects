class CheckinNotifier
  include Resque::Plugins::UniqueJob
  extend Resque::Plugins::Logger

  @queue = :Checkin_Notifier

  def self.perform
    logger.debug 'In checkin notifier'
    begin
      # Work around for the MySQL server has gone away error
      ActiveRecord::Base.verify_active_connections!
      hotels = Hotel.all
      hotels.each do |hotel|
        qualified_reservations = []
        due_in_reservations = Reservation.due_in_list(hotel.id)
        due_in_reservations.each do  |reservation|
          qualified_response = reservation.is_qualified_for_checkin_alert
          if qualified_response[:status]
            qualified_reservations << reservation
          else
            logger.debug " **********   #{qualified_response[:message]}   *********"
          end
        end
        logger.debug " **********   Listing Total #{qualified_reservations.count} Reservations  *********"
        
        qualified_reservations.each do |due_in_reservation|
          room =  due_in_reservation.current_daily_instance.room
          if  hotel.settings.checkin_alert_is_on
            notification = NotificationDetail.find_by_notification_id_and_notification_type_and_notification_section(due_in_reservation.id, Setting.notification_type[:reservation], Setting.notification_section_text[:check_in])
            NotificationDetail.create_reservation_notification(due_in_reservation, Setting.notification_section_text[:check_in], nil) if !notification
          end
        end
      end
    rescue => e
      ExceptionNotifier.notify_exception(e)  
    end
  end
end
