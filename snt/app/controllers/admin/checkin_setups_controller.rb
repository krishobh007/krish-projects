class Admin::CheckinSetupsController < ApplicationController
  before_filter :check_session

  def list_setup
    data = {
      checkin_alert_message: current_hotel.settings.checkin_alert_message,
      is_send_alert: current_hotel.settings.checkin_alert_is_on.to_s,
      is_notify_on_room_ready: current_hotel.settings.checkin_alert_on_room_ready.to_s,
      require_cc_for_checkin_email: current_hotel.settings.checkin_require_cc_for_email.to_s,
      is_precheckin_only: current_hotel.settings.is_pre_checkin_only,
      is_sent_to_queue: current_hotel.settings.is_sent_to_queue.to_s,
      prior_to_arrival: current_hotel.settings.queue_prior_to_arrival.to_s,
      excluded_rate_codes: current_hotel.pre_checkin_excluded_rate_codes.pluck(:rate_id),
      excluded_block_codes: current_hotel.pre_checkin_excluded_block_codes.pluck(:group_id),
      pre_checkin_email_title: current_hotel.settings.pre_checkin_email_title,
      pre_checkin_email_body: current_hotel.settings.pre_checkin_email_body,
      pre_checkin_email_bottom_body: current_hotel.settings.pre_checkin_email_bottom_body,
      max_webcheckin: current_hotel.settings.max_webcheckin,
      checkin_action: current_hotel.settings.checkin_action,
      is_sent_none_cc_reservations_to_front_desk_only: current_hotel.settings.is_sent_none_cc_reservations_to_front_desk_only,
      checkin_complete_confirmation_screen_text: current_hotel.settings.checkin_complete_confirmation_screen_text,
      start_auto_checkin_from: current_hotel.settings.start_auto_checkin_from,
      start_auto_checkin_from_prime_time: current_hotel.settings.start_auto_checkin_from_prime_time,
      start_auto_checkin_to: current_hotel.settings.start_auto_checkin_to,
      start_auto_checkin_to_prime_time: current_hotel.settings.start_auto_checkin_to_prime_time
    }

    checkin_alert_time = current_hotel.settings.checkin_alert_time

    if checkin_alert_time.present?
      local_time = current_hotel.utc_to_hotel_time(checkin_alert_time)

      data[:checkin_alert_time_hour] = local_time.strftime('%I')
      data[:checkin_alert_time_minute] = local_time.strftime('%M')
      data[:checkin_alert_primetime] = local_time.strftime('%p')
    end
    data[:is_send_checkin_staff_alert] = current_hotel.settings.web_checkin_staff_alert_enabled.to_s
    data[:emails] =  current_hotel.web_checkin_staff_alert_emails.present? ? current_hotel.web_checkin_staff_alert_emails.pluck(:email).join(';') : ''
    data[:checkin_staff_alert_option] = current_hotel.settings.web_checkin_staff_alert_to.to_s
    respond_to do |format|
      format.html { render partial: '/admin/zest_checkin/checkin', locals: { data: data,  errors: [] } }
      format.json { render json: { status: SUCCESS,  data: data, errors: [] } }
    end
  end

  def save_setup
    status = SUCCESS
    errors = []
    data = {}
    checkin_alert_time = ''
    if params['checkin_alert_time'].present?
      checkin_alert_time = ActiveSupport::TimeZone[current_hotel.tz_info].parse(params['checkin_alert_time'] + ' ' + params['prime_time'])
    end

    setup_params = {
      is_on: params[:is_send_alert] == 'true',
      alert_message: params[:checkin_alert_message].present? ? params[:checkin_alert_message] : nil,
      is_alert_on_room_ready: params[:is_notify_on_room_ready] == 'true',
      checkin_require_cc_for_email: params[:require_cc_for_checkin_email] == 'true',
      alert_time: checkin_alert_time,
      is_sent_to_queue: params[:is_sent_to_queue] == 'true',
      queue_prior_to_arrival: params[:prior_to_arrival],
      pre_checkin_email_title: params[:pre_checkin_email_title],
      pre_checkin_email_body: params[:pre_checkin_email_body],
      pre_checkin_email_bottom_body: params[:pre_checkin_email_bottom_body],
      max_webcheckin: params[:max_webcheckin],
      checkin_action: params[:checkin_action],
      is_sent_none_cc_reservations_to_front_desk_only: params[:is_sent_none_cc_reservations_to_front_desk_only],
      checkin_complete_confirmation_screen_text: params[:checkin_complete_confirmation_screen_text],
      start_auto_checkin_from: params[:start_auto_checkin_from],
      start_auto_checkin_from_prime_time: params[:start_auto_checkin_from_prime_time],
      start_auto_checkin_to: params[:start_auto_checkin_to],
      start_auto_checkin_to_prime_time: params[:start_auto_checkin_to_prime_time]
    }

    setup = HotelCheckinSetup.new(setup_params)
    setup.hotel = current_hotel
    staff_emails = params[:emails].to_s.split(';').map(&:strip)
    current_hotel.settings.web_checkin_staff_alert_enabled = params[:is_send_checkin_staff_alert]
    
    current_hotel.settings.is_pre_checkin_only = params[:is_precheckin_only]
    if current_hotel.settings.web_checkin_staff_alert_enabled == 'true'
      current_hotel.web_checkin_staff_alert_emails.destroy_all
      staff_emails.each do |staff_email|
        current_hotel.web_checkin_staff_alert_emails.create(email: staff_email)
      end
      current_hotel.settings.web_checkin_staff_alert_to = params[:checkin_staff_alert_option].present? ? params[:checkin_staff_alert_option] :  Setting.alert_staff_options[:ALL]
    end
    
    current_hotel.pre_checkin_excluded_rate_codes.destroy_all
    if params[:excluded_rate_codes]
      params[:excluded_rate_codes].each do |rate_id|
        current_hotel.pre_checkin_excluded_rate_codes.create(rate_id: rate_id) 
      end
    end
    current_hotel.pre_checkin_excluded_block_codes.destroy_all
    if params[:excluded_block_codes]
      params[:excluded_block_codes].each do |group_id|
        current_hotel.pre_checkin_excluded_block_codes.create(group_id: group_id) 
      end
    end
    
    unless setup.save
      status = FAILURE
      errors = setup.errors.full_messages
    else
      data[:checkin_staff_alert_option] = current_hotel.settings.web_checkin_staff_alert_to
    end
    respond_to do |format|
      format.html { render partial: '', locals: { data: {},  errors: errors } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  def send_checkin_notification
    status, data, errors = SUCCESS, {}, []
    due_in_reservations = current_hotel.reservations.where('id IN (?)', params[:reservations])
    total_reservations = Reservation.due_in_list(current_hotel.id)
    total_emails_sent = 0
    qualified_reservations = get_qualified_reservations(total_reservations)
    due_in_reservations.each do |due_in_reservation|
      if due_in_reservation.primary_guest.present?
        begin
          result = due_in_reservation.send_checkin_email
          status_flag = result ? result[:status] : false
          if status_flag == true
            total_emails_sent += 1
          else
            status = FAILURE
            errors = result[:errors]
          end
        rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError  => ex
          logger.debug ex.message
        end
      end
    end
    data[:message] = I18n.t(:checkin_email_success_message, Y: (total_emails_sent), X: qualified_reservations.count)
    render json: { status: status, data: data , errors: errors }
  end

  def get_due_in_guests
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
   
    due_in_reservations = Reservation.due_in_list(current_hotel.id)
      .joins("INNER JOIN reservation_daily_instances ON rs.id = reservation_daily_instances.reservation_id") 
      .joins("LEFT OUTER JOIN rooms ON reservation_daily_instances.reservation_id = rs.id AND reservation_daily_instances.room_id = rooms.id") 
      .joins("LEFT OUTER JOIN reservations_guest_details on reservations_guest_details.reservation_id = rs.id")
      .joins("LEFT OUTER JOIN guest_details ON guest_details.id = reservations_guest_details.guest_detail_id")  
      .joins("LEFT OUTER JOIN additional_contacts ON guest_details.id = additional_contacts.associated_address_id")
      .joins("LEFT OUTER JOIN additional_contacts as email_contacts ON guest_details.id = email_contacts.associated_address_id AND email_contacts.associated_address_type = 'GuestDetail' AND email_contacts.contact_type_id = #{Ref::ContactType[:EMAIL].id}")
      .where("email_contacts.value IS NOT NULL")
      .select("rs.id as id, guest_details.first_name as first_name, guest_details.last_name as last_name, rooms.room_no, email_contacts.value as email").order("#{sort_by}").uniq
      
      search_fields = ['guest_details.first_name', 'guest_details.last_name', 'room_no', 'additional_contacts.value']
      search_conditions = search_fields.map { |field| "upper(#{field}) like :query" }.join(' OR ')
      
      due_in_reservations = due_in_reservations.where(search_conditions, query: "%#{query}%" )
    
    status, data, errors = FAILURE, {}, []
    data[:due_out_guests]  = []
   
    if due_in_reservations
      qualified_reservations = get_qualified_reservations(due_in_reservations)

      qualified_reservations.each do |reservation|
        data[:due_out_guests] << {
          first_name: reservation.andand.first_name,
          last_name: reservation.andand.last_name,
          reservation_id: reservation.id.to_s,
          email: reservation.andand.email,
          room_number: reservation.current_daily_instance.room.andand.room_no.to_s
        }
      end if qualified_reservations.present?
    end

    data[:total_count] = data[:due_out_guests].count

    data[:due_out_guests] = Kaminari.paginate_array(data[:due_out_guests]).page(page_number).per(per_page)

    status, data, errors = SUCCESS, data, []
    respond_to do |format|
      format.html { render partial: '/admin/zest_checkin/checkin_guests', locals: { data: data,  errors: [] } }
      format.json { render json: { status: status, data: data, errors: [] } }
    end
  end

  private

  def get_qualified_reservations(due_in_reservations)
    qualified_reservations = []
    excluded_rate_ids = current_hotel.pre_checkin_excluded_rate_codes.pluck(:rate_id)
    excluded_group_ids = current_hotel.pre_checkin_excluded_block_codes.pluck(:group_id)
    
    due_in_reservations.each do  |reservation|
      qualified_response = reservation.is_qualified_for_checkin_alert
      if qualified_response[:status]
       qualified_reservations << reservation
      else
        logger.debug " **********   #{qualified_response[:message]}   *********"
      end
    end
    logger.debug " **********   Listing Total #{qualified_reservations.count} Reservations  *********"
    qualified_reservations
  end

end
