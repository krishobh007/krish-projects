# View Model for the checkin admin page
class HotelCheckinSetup
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :hotel, :is_on, :alert_message, :is_alert_on_room_ready, :alert_time,
                :checkin_require_cc_for_email, :is_sent_to_queue,
                :queue_prior_to_arrival, :pre_checkin_email_title,
                :pre_checkin_email_body, :pre_checkin_email_bottom_body,
                :max_webcheckin, :checkin_action, :is_sent_none_cc_reservations_to_front_desk_only, 
                :checkin_complete_confirmation_screen_text, :start_auto_checkin_from, :start_auto_checkin_from_prime_time,
                :start_auto_checkin_to, :start_auto_checkin_to_prime_time
                

  def initialize(params = {})
    self.attributes = params
  end

  def save
    if valid?
      hotel.settings.checkin_alert_is_on = is_on
      hotel.settings.checkin_alert_message = alert_message
      hotel.settings.checkin_alert_on_room_ready = is_alert_on_room_ready
      hotel.settings.checkin_alert_time = alert_time
      hotel.settings.checkin_require_cc_for_email = checkin_require_cc_for_email
      hotel.settings.is_sent_to_queue = is_sent_to_queue
      hotel.settings.queue_prior_to_arrival = queue_prior_to_arrival
      hotel.settings.pre_checkin_email_title = pre_checkin_email_title
      hotel.settings.pre_checkin_email_body = pre_checkin_email_body
      hotel.settings.pre_checkin_email_bottom_body = pre_checkin_email_bottom_body
      hotel.settings.max_webcheckin = max_webcheckin
      hotel.settings.checkin_action                                   = checkin_action
      hotel.settings.is_sent_none_cc_reservations_to_front_desk_only  = is_sent_none_cc_reservations_to_front_desk_only
      hotel.settings.checkin_complete_confirmation_screen_text        = checkin_complete_confirmation_screen_text
      hotel.settings.start_auto_checkin_from                          = start_auto_checkin_from
      hotel.settings.start_auto_checkin_from_prime_time               = start_auto_checkin_from_prime_time
      hotel.settings.start_auto_checkin_to                            = start_auto_checkin_to
      hotel.settings.start_auto_checkin_to_prime_time                 = start_auto_checkin_to_prime_time
      true
    else
      false
    end
  end

  def attributes=(attributes)
    attributes = (attributes || {}).symbolize_keys
    attributes.keys.each do |k|
      if self.class.instance_methods.include?(:"#{k}=")
        send(:"#{k}=", attributes[k])
      end
    end
  end
end
