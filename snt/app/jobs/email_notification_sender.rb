class EmailNotificationSender
  include Resque::Plugins::UniqueJob
  extend Resque::Plugins::Logger

  @queue = :EmailNotifications

  def self.perform
    logger.debug " *****   Started Email Notification Job ****"
    begin
      list_of_hotels_for_checkin_email = []
      list_of_hotels_for_checkout_email = []
      @hotel_ids_with_alternate_alert_time = []
      response = {}
      # Work around for the MySQL server has gone away error
      ActiveRecord::Base.verify_active_connections!
      Hotel.find_each do |hotel|
        list_of_hotels_for_checkin_email << hotel if has_checkin_reservations_for_alert(hotel)
        list_of_hotels_for_checkin_email << hotel if !has_checkin_reservations_for_alert(hotel) && had_failed_to_schedule_checkin_emails_in_time(hotel)
        response[hotel.id] = has_checkout_reservations_for_alert(hotel)
        response[hotel.id] = had_failed_to_schedule_checkout_emails_in_time(hotel) unless response[hotel.id][:status]
        list_of_hotels_for_checkout_email << hotel if response[hotel.id][:status]
      end
      list_of_hotels_for_checkin_email.each do |hotel|
        logger.debug " *****  Its Time for Checkin Emails for hotel :  #{hotel.code}    *****"
        checkin_reservations = Reservation.due_in_list(hotel.id)
        send_staff_checkin_confirmation_emails(alert_guests(checkin_reservations)) if hotel.settings.checkin_alert_is_on
      end
      list_of_hotels_for_checkout_email.each do |hotel|
        logger.debug " *****  Its Time for Checkout Emails for hotel :  #{hotel.code}   *****"
        checkout_reservations = Reservation.due_out_list(hotel.id)
        send_staff_checkout_confirmation_emails(alert_guests(checkout_reservations), response[hotel.id][:alert_time])
      end
    rescue => e
      ExceptionNotifier.notify_exception(e)
      logger.error e.message
      logger.error e.backtrace.join("\n")
    end
  end

  def self.alert_guests(reservations)
    alerted_reservations = []
    reservations.each do |reservation|
      begin
        if reservation.primary_guest.present?
          if reservation.primary_guest.email.present?
            @email_template = nil
            logger.debug " *****   Alerting Reservation #{reservation.confirm_no}   ****"
            reservation.create_web_token_for_email
            set_email_template(reservation)

            if @email_template.present?
              ReservationMailer.send_guestweb_email_notification(reservation, @email_template).deliver!
              alerted_reservations << reservation
              record_action(reservation)
            end
          else
            logger.debug " *****   Alerting Reservation #{reservation.confirm_no} - Failed due to missing guest email address  ****"
          end
        else
          logger.debug " *****   Alerting Reservation #{reservation.confirm_no} - Failed due to missing primary_guest  ****"
        end
      rescue Exception => ex
        logger.debug " *****   An Exception occured while alerting the #{reservation.confirm_no} -- #{ex.message}  ****"
      end
    end
    alerted_reservations
  end

  def self.set_email_template(reservation)
    # Setting Email Templates for checkout reservations
    if (reservation.status === :CHECKEDIN )
      should_alert = true
      if (reservation.hotel.settings.checkout_require_cc_for_email && reservation.hotel.settings.include_cash_reservations)
        should_alert = false unless (reservation.is_cc_attached || reservation.primary_payment_method.andand.cash?)
      elsif reservation.hotel.settings.checkout_require_cc_for_email
        should_alert = false unless reservation.is_cc_attached
      elsif reservation.hotel.settings.include_cash_reservations
        should_alert = false unless reservation.primary_payment_method.andand.cash?
      end
      should_alert &= !reservation.is_opted_late_checkout if @hotel_ids_with_alternate_alert_time.include?(reservation.hotel.id)
      if (reservation.is_late_checkout_available? &&
      should_alert && reservation.hotel.settings.checkout_email_alert_time)
        @email_template  = reservation.hotel.email_templates.find_by_title("LATE_CHECKOUT_EMAIL_TEXT")
        message = "Late Checkout Email Template Was Not Found For The Hotel : #{reservation.hotel.code}" if @email_template.nil?
        log_messages(reservation,false,message) if @email_template.nil?
      elsif should_alert && reservation.hotel.settings.checkout_email_alert_time
        @email_template  = reservation.hotel.email_templates.find_by_title("CHECKOUT_EMAIL_TEXT")
        message = "Checkout Email Template Was Not Found For The Hotel : #{reservation.hotel.code}" if @email_template.nil?
        log_messages(reservation,false,message) if @email_template.nil?
      end
    #Setting Template for Checking-In Reservations
    else
      qualified_response = reservation.is_qualified_for_checkin_alert
      should_alert = qualified_response[:status]
      log_messages(reservation,false,qualified_response[:message],true) unless should_alert
      if reservation.hotel.is_pre_checkin_only?
        @email_template =  reservation.hotel.email_templates.find_by_title("PRE_CHECKIN_EMAIL_TEXT") if should_alert
      else
        @email_template =  reservation.hotel.email_templates.find_by_title("CHECKIN_EMAIL_TEMPLATE") if should_alert
      end
      message = "Checkin Email Template Was Not Found For The Hotel : #{reservation.hotel.code}" if (@email_template.nil? && should_alert)
      log_messages(reservation,false,message,true) if (@email_template.nil? && should_alert)
    end
  end

  def self.had_failed_to_schedule_checkin_emails_in_time(hotel)
    status =  hotel.settings.checkin_alert_time.present?
    should_alert = false
    if status
      if !hotel.settings.last_checkin_alerted.present? || hotel.settings.last_checkin_alerted != Date.today
        if Time.parse(ActiveSupport::TimeZone[hotel.tz_info]
        .parse(hotel.settings.checkin_alert_time.in_time_zone(hotel.tz_info).strftime('%H:%M')).utc.strftime('%H:%M')) < Time.parse(Time.now.utc.strftime('%H:%M'))
          hotel.settings.last_checkin_alerted = Date.today
        should_alert = true
        end
      end
    end
    should_alert
  end

  def self.had_failed_to_schedule_checkout_emails_in_time(hotel)
    response = {status: false}
    if !hotel.settings.last_checkout_alerted_date.present? || hotel.settings.last_checkout_alerted_date != Date.today
      if hotel.is_business_date_on_weekends
        if hotel.settings.alternate_weekends_checkout_email_alert_time.present? && Time.parse(ActiveSupport::TimeZone[hotel.tz_info]
        .parse(hotel.settings.alternate_weekends_checkout_email_alert_time.in_time_zone(hotel.tz_info).strftime('%H:%M')).utc.strftime('%H:%M')) < Time.parse(Time.now.utc.strftime('%H:%M'))
          response = {status: true, alert_time: hotel.settings.alternate_weekends_checkout_email_alert_time}
          hotel.settings.last_checkout_alerted_date = Date.today

        elsif hotel.settings.weekends_checkout_email_alert_time.present? && Time.parse(ActiveSupport::TimeZone[hotel.tz_info]
        .parse(hotel.settings.weekends_checkout_email_alert_time.in_time_zone(hotel.tz_info).strftime('%H:%M')).utc.strftime('%H:%M')) < Time.parse(Time.now.utc.strftime('%H:%M'))
          response = {status: true, alert_time: hotel.settings.weekends_checkout_email_alert_time}
          hotel.settings.last_checkout_alerted_date = Date.today
        end
      else
        if hotel.settings.alternate_checkout_email_alert_time.present? && Time.parse(ActiveSupport::TimeZone[hotel.tz_info]
        .parse(hotel.settings.alternate_checkout_email_alert_time.in_time_zone(hotel.tz_info).strftime('%H:%M')).utc.strftime('%H:%M')) < Time.parse(Time.now.utc.strftime('%H:%M'))
          response = {status: true, alert_time: hotel.settings.alternate_checkout_email_alert_time}
          hotel.settings.last_checkout_alerted_date = Date.today

        elsif hotel.settings.checkout_email_alert_time.present? && Time.parse(ActiveSupport::TimeZone[hotel.tz_info]
        .parse(hotel.settings.checkout_email_alert_time.in_time_zone(hotel.tz_info).strftime('%H:%M')).utc.strftime('%H:%M')) < Time.parse(Time.now.utc.strftime('%H:%M'))
          response = {status: true, alert_time: hotel.settings.checkout_email_alert_time}
          hotel.settings.last_checkout_alerted_date = Date.today
        end
      end

    elsif hotel.settings.last_checkout_alerted_date.present? && hotel.settings.last_checkout_alerted_date == Date.today
      if hotel.is_business_date_on_weekends && hotel.settings.weekends_checkout_email_alert_time.present? && hotel.settings.weekends_checkout_email_alert_time == hotel.settings.last_checkout_alerted_time &&
      Time.parse(ActiveSupport::TimeZone[hotel.tz_info].parse(hotel.settings.alternate_weekends_checkout_email_alert_time.in_time_zone(hotel.tz_info).strftime('%H:%M')).utc.strftime('%H:%M')) < Time.parse(Time.now.utc.strftime('%H:%M'))
        response = {status: true, alert_time: hotel.settings.weekends_checkout_email_alert_time}
      hotel.settings.last_checkout_alerted_time = hotel.settings.alternate_weekends_checkout_email_alert_time
      elsif !hotel.is_business_date_on_weekends && hotel.settings.alternate_checkout_email_alert_time.present? && hotel.settings.checkout_email_alert_time.present? && hotel.settings.checkout_email_alert_time == hotel.settings.last_checkout_alerted_time && Time.parse(ActiveSupport::TimeZone[hotel.tz_info]
      .parse(hotel.settings.alternate_checkout_email_alert_time.andand.in_time_zone(hotel.tz_info).andand.strftime('%H:%M')).utc.strftime('%H:%M')) < Time.parse(Time.now.utc.strftime('%H:%M'))
        response = {status: true, alert_time: hotel.settings.alternate_checkout_email_alert_time}
      hotel.settings.last_checkout_alerted_time = hotel.settings.alternate_checkout_email_alert_time
      end
    end
    response
  end

  def self.has_checkin_reservations_for_alert(hotel)
    status =  hotel.settings.checkin_alert_time.present? && (ActiveSupport::TimeZone[hotel.tz_info]
    .parse(hotel.settings.checkin_alert_time.in_time_zone(hotel.tz_info).strftime('%H:%M')).utc.strftime('%H:%M') == Time.now.utc.strftime('%H:%M'))
    hotel.settings.last_checkin_alerted = Date.today if status
    return status
  end

  def self.has_checkout_reservations_for_alert(hotel)
    is_normal_alert_time, @is_alternate_alert_time = false, false
    if hotel.is_business_date_on_weekends && (hotel.settings.weekends_checkout_email_alert_time.present? || hotel.settings.alternate_weekends_checkout_email_alert_time.present?)
      is_normal_alert_time = hotel.settings.weekends_checkout_email_alert_time.present? && (ActiveSupport::TimeZone[hotel.tz_info]
      .parse(hotel.settings.weekends_checkout_email_alert_time.in_time_zone(hotel.tz_info).strftime('%H:%M')).utc.strftime('%H:%M') == Time.now.utc.strftime('%H:%M'))
      is_alternate_alert_time = hotel.settings.alternate_weekends_checkout_email_alert_time.present? && (ActiveSupport::TimeZone[hotel.tz_info]
      .parse(hotel.settings.alternate_weekends_checkout_email_alert_time.in_time_zone(hotel.tz_info).strftime('%H:%M')).utc.strftime('%H:%M') == Time.now.utc.strftime('%H:%M'))
    @hotel_ids_with_alternate_alert_time << hotel.id if  is_alternate_alert_time
    alert_time = hotel.settings.alternate_weekends_checkout_email_alert_time if is_alternate_alert_time
    alert_time = hotel.settings.weekends_checkout_email_alert_time if is_normal_alert_time
    else
      is_normal_alert_time = hotel.settings.checkout_email_alert_time.present? && (ActiveSupport::TimeZone[hotel.tz_info]
      .parse(hotel.settings.checkout_email_alert_time.in_time_zone(hotel.tz_info).strftime('%H:%M')).utc.strftime('%H:%M') == Time.now.utc.strftime('%H:%M'))
      is_alternate_alert_time = hotel.settings.alternate_checkout_email_alert_time.present? && (ActiveSupport::TimeZone[hotel.tz_info]
      .parse(hotel.settings.alternate_checkout_email_alert_time.in_time_zone(hotel.tz_info).strftime('%H:%M')).utc.strftime('%H:%M') == Time.now.utc.strftime('%H:%M'))
    @hotel_ids_with_alternate_alert_time << hotel.id if  is_alternate_alert_time
    alert_time = hotel.settings.alternate_checkout_email_alert_time if is_alternate_alert_time
    alert_time = hotel.settings.checkout_email_alert_time if is_normal_alert_time
    end
    status = is_normal_alert_time || is_alternate_alert_time
    response = {status: status, alert_time: alert_time}
    hotel.settings.last_checkout_alerted_date = Date.today if response[:status]
    hotel.settings.last_checkout_alerted_time = alert_time if response[:status]
    return response
  end

  # Log error messages and success messages in server log at EmailNotifications.log
  def self.log_messages(reservation,success,message,is_checkin=false)
    logger.error " *****   Email Notification Failed For Reservation :  #{reservation.confirm_no}" unless success
    logger.debug " ***** #{message} *****" unless message.nil?
    logger.debug " *****  Automatic Email Notification Sent  For Reservation :  #{reservation.confirm_no}" if success
    logger.debug " *****  Reservation Status :   #{reservation.status.to_s}"
    logger.debug " *****  Alerted Time (In Hotel Time Zone):   #{Time.now.utc.in_time_zone(reservation.hotel.tz_info)}" if (success)
    logger.debug " *****  Room Number :   #{reservation.current_daily_instance.andand.room.andand.room_no}" if (success && is_checkin)
  end

  # Send emails to the hotel staff confirming the guest emails were sent for check in
  def self.send_staff_checkin_confirmation_emails(reservations)
    reservations.map(&:hotel).uniq.each do |hotel|
      hotel_reservations = reservations.select { |reservation| reservation.hotel_id == hotel.id }

      hotel.web_checkin_staff_alert_emails.each do |recipient|
        begin
          HotelMailer.send_staff_checkin_confirmation(hotel, recipient.email, hotel_reservations).deliver! if (hotel.settings.web_checkin_staff_alert_enabled == 'true')
        rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError  => ex
          logger.debug "*********** error in notifying staff on checkin reservation list for hotel : #{hotel.code}"
          logger.debug "#{ex.message}"
        end
      end

      logger.debug "Sent check in confirmation email to hotel #{hotel.code} staff for #{hotel_reservations.count} reservations"
    end
  end

  # Send emails to the hotel staff confirming the guest emails were sent for check out
  def self.send_staff_checkout_confirmation_emails(reservations, alert_time)
    reservations.map(&:hotel).uniq.each do |hotel|
      hotel_reservations = reservations.select { |reservation| reservation.hotel_id == hotel.id }

      hotel.web_checkout_staff_alert_emails.checkout_alerts.each do |recipient|
        begin
          HotelMailer.send_staff_checkout_confirmation(hotel, recipient.email, hotel_reservations, alert_time).deliver!  if  (hotel.settings.is_send_checkout_staff_alert == 'true')
        rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError  => ex
          logger.debug "*********** error in notifying staff on checkout reservation list for hotel : #{hotel.code}"
          logger.debug "#{ex.message}"
        end
      end

      logger.debug "Sent check out confirmation email to hotel #{hotel.code} staff for #{hotel_reservations.count} reservations"
    end
  end

  # Record the email actions for reporting
  def self.record_action(reservation)
    if %W(CHECKOUT_EMAIL_TEXT LATE_CHECKOUT_EMAIL_TEXT).include?(@email_template.title)
      Action.record!(reservation, :EMAIL_CHECKOUT, :ROVER, reservation.hotel_id)
    end

    if %W(CHECKIN_EMAIL_TEMPLATE PRE_CHECKIN_EMAIL_TEXT).include?(@email_template.title)
      Action.record!(reservation, :EMAIL_CHECKIN, :ROVER, reservation.hotel_id)
    end
  end
end
