class CheckoutNotifier
  include Resque::Plugins::UniqueJob
  extend Resque::Plugins::Logger

  @queue = :Checkout_Notifier
  def self.perform
    logger.debug " ********************  In checkout notifier ***************** "
    begin
    # Work around for the MySQL server has gone away error
      ActiveRecord::Base.verify_active_connections!
      hotels = Hotel.all
      hotels.each do |hotel|
        due_out_reservations = Reservation.due_out_list(hotel.id)
        due_out_reservations.each do |due_out_reservation|
          notification = NotificationDetail.find_by_notification_id_and_notification_type_and_notification_section(due_out_reservation.id, Setting.notification_type[:reservation], Setting.notification_section_text[:check_out])
          if hotel.late_checkout_available?
            NotificationDetail.create_reservation_notification(due_out_reservation, Setting.notification_section_text[:check_out], hotel.settings.late_checkout_upsell_alert_time) if !notification
          end
        end
      end
    rescue => e
      ExceptionNotifier.notify_exception(e)
    end
  end
end
