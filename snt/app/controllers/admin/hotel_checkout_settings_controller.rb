class Admin::HotelCheckoutSettingsController < ApplicationController
  before_filter :check_session

  def index
    status, data, errors = SUCCESS, {}, []
    data = map_checkout_alert_time
    checkout_alert_emails = current_hotel.web_checkout_staff_alert_emails.checkout_alerts.pluck(:email)
    late_checkout_alert_emails = current_hotel.web_checkout_staff_alert_emails.late_checkout_alerts.pluck(:email)
    data[:is_send_checkout_staff_alert] = current_hotel.settings.is_send_checkout_staff_alert.to_s
    data[:checkout_staff_alert_option] = current_hotel.settings.web_checkout_staff_alert_option.to_s
    data[:room_verification_instruction] = current_hotel.settings.room_verification_instruction.to_s
    data[:emails] =  checkout_alert_emails.join(';')
    #Hotel admin can configure separate email address for staff alert incase of late checkouts
    data[:staff_emails_for_late_checkouts] = late_checkout_alert_emails.join(';')
    data[:require_cc_for_checkout_email] =  current_hotel.settings.checkout_require_cc_for_email.to_s
    data[:include_cash_reservations] = current_hotel.settings.include_cash_reservations.to_s
    respond_to do |format|
      format.html { render partial: 'checkout', locals: { data: data,  errors: [] } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  def save
    status, data, errors = SUCCESS, {}, []
    set_checkout_settings_parameters
    begin
      if params[:emails]
        current_hotel.web_checkout_staff_alert_emails.checkout_alerts.destroy_all
        alert_mails = params[:emails].split(';').map(&:strip)
        alert_mails.each do |email|
          current_hotel.web_checkout_staff_alert_emails.create(email: email, email_type: Setting.staff_alert_types[:checkout])
        end
      end
      if params[:staff_emails_for_late_checkouts]
        current_hotel.web_checkout_staff_alert_emails.late_checkout_alerts.destroy_all
        alert_mails = params[:staff_emails_for_late_checkouts].split(';').map(&:strip)
        alert_mails.each do |email|
          current_hotel.web_checkout_staff_alert_emails.create(email: email, email_type: Setting.staff_alert_types[:late_checkout])
        end
      end
    rescue NoMethodError => e
      errors, status = [e.message], FAILURE
    end
    render json: { status: status,  data: data, errors: errors }
  end

  def send_checkout_notification
    status, data, errors = SUCCESS, {}, []
    due_out_reservations = current_hotel.reservations.where('id IN (?)', params[:reservations])
    total_reservations =  get_qualified_reservations(Reservation.due_out_list(current_hotel.id)).count
    total_emails_sent = 0
    email_type = Setting.guest_web_email_types[:checkout]
    due_out_reservations.each do |due_out_reservation|
      if due_out_reservation.primary_guest.present?
        begin
          if due_out_reservation.is_late_checkout_available?
            email_type = Setting.guest_web_email_types[:late_checkout]
            checkout_email_template  = current_hotel.email_templates.find_by_title('LATE_CHECKOUT_EMAIL_TEXT')
          else
            checkout_email_template  = current_hotel.email_templates.find_by_title('CHECKOUT_EMAIL_TEXT')
          end
          guest_web_token = GuestWebToken.find_by_guest_detail_id_and_is_active_and_reservation_id_and_email_type(due_out_reservation.primary_guest.id,true,due_out_reservation.id, email_type)
          guest_web_token = GuestWebToken.create(:access_token=>SecureRandom.hex,:guest_detail_id=>due_out_reservation.primary_guest.id,:reservation_id=>due_out_reservation.id,:email_type=>email_type) if !guest_web_token
          if checkout_email_template
            ReservationMailer.send_guestweb_email_notification(due_out_reservation, checkout_email_template).deliver!

            Action.record!(due_out_reservation, :EMAIL_CHECKOUT, :ROVER, due_out_reservation.hotel_id)

            total_emails_sent += 1
          else
            status = FAILURE
            errors = ["Email template is missing."]
          end
        rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError  => ex
          @logger ||= Logger.new('log/EmailNotifications.log')
          @logger.debug "==Exception: Manual email notification from Hotel Admin -->>#{ex.message}"
        end
      end
    end
    data[:message] = I18n.t(:checkout_email_success_message, Y: (total_emails_sent), X: total_reservations)
    render json: { status: status, data: data , errors: errors }
  end

  def get_due_out_guests
    page_number = params[:page] || 1
    per_page    = params[:per_page] || 100
    query       = params[:query]
    sort_by     = ["first_name", "email", "room_number"].include?(params[:sort_field]) ? params[:sort_field] : "room_number"
    direction   = params[:sort_dir].nil? ? 'ASC': (params[:sort_dir] == 'true' ? 'ASC' : 'DESC')
   
   case params[:sort_field]
    when 'first_name'
      sort_by = "guest_details.first_name #{direction}"
    when 'email'
      sort_by =  "additional_contacts.value #{direction}"
    when 'room_number'
      sort_by = "rooms.room_no #{direction}"
    end

    due_out_reservations = Reservation.due_out_list(current_hotel.id)
      .joins("INNER JOIN reservation_daily_instances ON rs.id = reservation_daily_instances.reservation_id") 
      .joins("LEFT OUTER JOIN rooms ON reservation_daily_instances.reservation_id = rs.id AND reservation_daily_instances.room_id = rooms.id") 
      .joins("LEFT OUTER JOIN reservations_guest_details on reservations_guest_details.reservation_id = rs.id")
      .joins("LEFT OUTER JOIN guest_details ON guest_details.id = reservations_guest_details.guest_detail_id")  
      .joins("LEFT OUTER JOIN additional_contacts ON guest_details.id = additional_contacts.associated_address_id")
      .joins("LEFT OUTER JOIN additional_contacts as email_contacts ON guest_details.id = email_contacts.associated_address_id AND email_contacts.associated_address_type = 'GuestDetail' AND email_contacts.contact_type_id = #{Ref::ContactType[:EMAIL].id}")
      .select("rs.id as id, guest_details.first_name as first_name, guest_details.last_name as last_name, rooms.room_no, email_contacts.value as email").order("#{sort_by}").uniq
      
      search_fields = ['guest_details.first_name', 'guest_details.last_name', 'room_no', 'additional_contacts.value']
      search_conditions = search_fields.map { |field| "upper(#{field}) like :query" }.join(' OR ')
      
      due_out_reservations = due_out_reservations.where(search_conditions, query: "%#{query}%" )
    
    status,data, errors = SUCCESS, {}, []
    data[:due_out_guests] = []
    if due_out_reservations
      qualified_reservations = get_qualified_reservations(due_out_reservations)
      qualified_reservations.each do |reservation|
            data[:due_out_guests] << {
              first_name: reservation.primary_guest.andand.first_name.to_s,
              reservation_id: reservation.id.to_s,
              last_name: reservation.primary_guest.andand.last_name.to_s,
              email: reservation.primary_guest.andand.email.to_s,
              room_number: reservation.current_daily_instance.room.andand.room_no.to_s
            }  if qualified_reservations.present?
      end
    end
    
    data[:total_count] = data[:due_out_guests].count
    data[:due_out_guests] = Kaminari.paginate_array(data[:due_out_guests]).page(params[:page]).per(params[:per_page])
    
    status, data, errors = SUCCESS, data, []
    respond_to do |format|
      format.html { render partial: 'checkout_guests', locals: { data: data,  errors: [] } }
      format.json { render json: { status: status, data: data, errors: [] }}
    end
  end

  private

  def get_qualified_reservations(due_out_reservations)
    qualified_reservations = []
    due_out_reservations.each do |reservation|
      if reservation.primary_guest && reservation.primary_guest.email
        should_alert = true
        if reservation.hotel.settings.checkout_require_cc_for_email &&  reservation.hotel.settings.include_cash_reservations
            should_alert = false unless reservation.is_cc_attached || reservation.primary_payment_method.andand.cash?
        elsif reservation.hotel.settings.checkout_require_cc_for_email
            should_alert = false unless reservation.is_cc_attached
        elsif reservation.hotel.settings.include_cash_reservations
            should_alert = false unless reservation.primary_payment_method.andand.cash?
        end
        if should_alert
          qualified_reservations << reservation
        end
      end
    end
    qualified_reservations
  end

  def set_checkout_settings_parameters
   status, data, errors = SUCCESS, {}, []
    checkout_alert_time =
      ActiveSupport::TimeZone[current_hotel.tz_info]
        .parse(params[:checkout_email_alert_time]) if params[:checkout_email_alert_time].present?
    alternate_checkout_email_alert_time =
      ActiveSupport::TimeZone[current_hotel.tz_info]
        .parse(params[:alternate_checkout_email_alert_time]) if params[:alternate_checkout_email_alert_time].present?
    weekends_checkout_email_alert_time =
      ActiveSupport::TimeZone[current_hotel.tz_info]
        .parse(params[:weekends_checkout_email_alert_time]) if params[:weekends_checkout_email_alert_time].present?
    alternate_weekends_checkout_email_alert_time =
      ActiveSupport::TimeZone[current_hotel.tz_info]
        .parse(params[:alternate_weekends_checkout_email_alert_time]) if params[:alternate_weekends_checkout_email_alert_time].present?

    if checkout_alert_time.present? &&  alternate_checkout_email_alert_time.present?
      errors = [t(:invalid_email_alert_time)] if checkout_alert_time >= alternate_checkout_email_alert_time
    end
    if  weekends_checkout_email_alert_time.present? &&  alternate_weekends_checkout_email_alert_time.present?
      errors = [t(:invalid_weekends_email_alert_time)] if weekends_checkout_email_alert_time >= alternate_weekends_checkout_email_alert_time
    end
    if errors.empty?
     current_hotel.settings.checkout_email_alert_time = checkout_alert_time
     current_hotel.settings.alternate_checkout_email_alert_time = alternate_checkout_email_alert_time
     current_hotel.settings.weekends_checkout_email_alert_time = weekends_checkout_email_alert_time
     current_hotel.settings.alternate_weekends_checkout_email_alert_time = alternate_weekends_checkout_email_alert_time
     current_hotel.settings.checkout_require_cc_for_email = params[:require_cc_for_checkout_email] == 'true'
     current_hotel.settings.is_send_checkout_staff_alert = params[:is_send_checkout_staff_alert]
     current_hotel.settings.web_checkout_staff_alert_option = params[:checkout_staff_alert_option]
     current_hotel.settings.include_cash_reservations = params[:include_cash_reservations] == 'true'
     current_hotel.settings.room_verification_instruction = params[:room_verification_instruction]
   else
       render json: { status: FAILURE, data: data, errors: errors }
    end
  end

  def map_checkout_alert_time
    checkout_email_alert_time = current_hotel.settings.checkout_email_alert_time
      .in_time_zone(current_hotel.tz_info) if  current_hotel.settings.checkout_email_alert_time.present?
    alternate_checkout_email_alert_time = current_hotel.settings.alternate_checkout_email_alert_time
      .in_time_zone(current_hotel.tz_info) if  current_hotel.settings.alternate_checkout_email_alert_time.present?
    weekends_checkout_email_alert_time = current_hotel.settings.weekends_checkout_email_alert_time
      .in_time_zone(current_hotel.tz_info) if  current_hotel.settings.weekends_checkout_email_alert_time.present?
    alternate_weekends_checkout_email_alert_time = current_hotel.settings.alternate_weekends_checkout_email_alert_time
      .in_time_zone(current_hotel.tz_info) if  current_hotel.settings.alternate_weekends_checkout_email_alert_time.present?
    {
        checkout_email_alert_time_hour:  checkout_email_alert_time.andand.strftime('%I'),
        checkout_email_alert_time_minute:  checkout_email_alert_time.andand.strftime('%M'),
        alternate_checkout_email_alert_time_hour:  alternate_checkout_email_alert_time.andand.strftime('%I'),
        alternate_checkout_email_alert_time_minute:  alternate_checkout_email_alert_time.andand.strftime('%M'),
        weekends_checkout_email_alert_time_hour:  weekends_checkout_email_alert_time.andand.strftime('%I'),
        weekends_checkout_email_alert_time_minute:  weekends_checkout_email_alert_time.andand.strftime('%M'),
        alternate_weekends_checkout_email_alert_time_hour:  alternate_weekends_checkout_email_alert_time.andand.strftime('%I'),
        alternate_weekends_checkout_email_alert_time_minute:  alternate_weekends_checkout_email_alert_time.andand.strftime('%M')
    }
  end

end
