class ReservationMailer < ActionMailer::Base
  include ApplicationHelper
  def staff_send_reservation_key(reservation_key_id, host, reservation, email = nil)
    @key_id = reservation_key_id
    host =  ReservationMailer.default_url_options[:host]
    from_address = reservation.hotel.hotel_from_address
    email_template = reservation.hotel.email_templates.find_by_title!('Key Delivery Email Text')
    # Based on CICO-9497 QA comment.
    email_subject = (EmailTemplateTheme.find(email_template.email_template_theme_id).code == 'guestweb_huntley') ? email_template.subject : 'Welcome. Your Room Key is Enclosed!'
    email_body = get_email_body(reservation, from_address, host, email_template)
    mail(from: from_address, to: email ? email : reservation.primary_guest.andand.email,
         subject: email_subject, body: email_body, content_type: 'text/html')
  end
  
  def auto_checkin_reservation_key(reservation_key_id, host, reservation, email = nil)
    @key_id = reservation_key_id
    host          =  ReservationMailer.default_url_options[:host]
    hotel         = reservation.hotel
    from_address  = hotel.hotel_from_address
    is_cc_reservation = reservation.primary_payment_method.present? ? reservation.primary_payment_method.payment_type.is_cc?(hotel) : false
    email_template = ""
    email_subject = 'Welcome. Your Room Key is Enclosed!'
    
    if is_cc_reservation && !(hotel.settings.room_key_delivery_for_guestzest_check_in == 'front_desk')
      email_template = hotel.email_templates.find_by_title!('Key Delivery Email Text - QRCODE')
    else
      email_template = hotel.email_templates.find_by_title!('Key Delivery Email Text')
      email_subject = email_template.subject
    end
    
    email_body = get_email_body(reservation, from_address, host, email_template)
    mail(from: from_address, to: email ? email : reservation.primary_guest.andand.email,
         subject: email_subject, body: email_body, content_type: 'text/html')
         
  end

  def guest_send_reservation_key(reservation_key_id, host, reservation)
    @key_id = reservation_key_id
    host =  ReservationMailer.default_url_options[:host]
    from_address = reservation.hotel.hotel_from_address
    email_template = reservation.hotel.email_templates.find_by_title('Key Delivery Email Text')
    email_subject = (EmailTemplateTheme.find(email_template.email_template_theme_id).code == 'guestweb_huntley') ? email_template.subject : 'Welcome. Your Room Key is Enclosed!'
    email_body = get_email_body(reservation, from_address, host, email_template)
    mail(from: from_address, to: reservation.primary_guest.email,
         subject: email_subject, body: email_body,
         content_type: 'text/html')
  end

  def send_guestweb_email_notification(reservation, email_template)
    if reservation.hotel.is_pre_checkin_only? && email_template.title == 'PRE_CHECKIN_EMAIL_TEXT'
      subject = reservation.hotel.settings.pre_checkin_email_title
    else
      subject = email_template.subject
    end
    host =  ReservationMailer.default_url_options[:host]
    from_address = reservation.hotel.hotel_from_address
    email_body = get_email_body(reservation, from_address, host, email_template)
    mail(from: from_address, to: reservation.primary_guest.email, subject: subject , body: email_body, content_type: 'text/html')
  end

  def alert_staff_on_checkin_success(reservation, recipient)
    email_template = EmailTemplate.find_by_title('STAFF_SUCCESS_CHECKIN_ALERT_EMAIL')
    host =  ReservationMailer.default_url_options[:host]
    subject = email_template.subject.gsub('@full_name', reservation.primary_guest.full_name.to_s)
    .gsub('@room_number', reservation.current_daily_instance.room.andand.room_no.to_s)
    from_address = reservation.hotel.hotel_from_address
    email_body = get_email_body(reservation, from_address, host, email_template, true)
    email_body = email_body.gsub('@staff_email', recipient)
    mail(from: from_address, to: recipient, subject: subject , body: email_body, content_type: 'text/html')
  end

  def alert_staff_on_pre_checkin_success(reservation, recipient)
     hotel = reservation.hotel
     @guest_name = reservation.primary_guest.andand.full_name
     @arrival_date = reservation.arrival_date.strftime(hotel.date_format) if reservation.arrival_date.present?
     @departure_date = reservation.dep_date.strftime(hotel.date_format) if reservation.dep_date.present?
     @room_number = reservation.current_daily_instance.room.andand.room_no.to_s
     @confirmation_number = reservation.confirm_no
     @guest_phone = reservation.primary_guest.phone || reservation.primary_guest.mobile
     @guest_eta = reservation.arrival_time.in_time_zone(hotel.tz_info).strftime("%I:%M %p") if reservation.arrival_time.present?
     @hotel_name = hotel.name
     @staff_email = recipient
     @guest_comments = reservation.comments
     @from_address = hotel.hotel_from_address
     @logo = default_url_options[:host] + "/assets/logo.png"
    mail(from: reservation.hotel.hotel_from_address, to: recipient, subject: I18n.t('mailer.subject.staff_pre_checkin_success',confirmation_number: @confirmation_number,guest_name: @guest_name)) do |format|
      format.html { render 'alert_staff_on_pre_checkin_success' }
    end
  end

  def alert_staff_on_checkin_failure(reservation, recipient, error_message)
    email_template = EmailTemplate.find_by_title('STAFF_FAILURE_CHECKIN_ALERT_EMAIL')
    host =  ReservationMailer.default_url_options[:host]
    subject = email_template.subject.gsub('@full_name', reservation.primary_guest.full_name.to_s)
              .gsub('@room_number', reservation.current_daily_instance.room.andand.room_no.to_s)
    from_address = reservation.hotel.hotel_from_address
    email_body = get_email_body(reservation, from_address, host, email_template, true)
    email_body = email_body.gsub('@staff_email', recipient).gsub('@error_description', error_message)
    mail(from: from_address, to: recipient, subject: subject , body: email_body, content_type: 'text/html')
  end

  def alert_staff_on_checkout_success(reservation, recipient)
    email_template = EmailTemplate.find_by_title('STAFF_SUCCESS_CHECKOUT_ALERT_EMAIL')
    host =  ReservationMailer.default_url_options[:host]
    subject = email_template.subject.gsub('@full_name', reservation.primary_guest.full_name.to_s)
    .gsub('@room_number', reservation.current_daily_instance.room.andand.room_no.to_s)
    from_address = reservation.hotel.hotel_from_address
    email_body = get_email_body(reservation, from_address, host, email_template, true)
    email_body = email_body.gsub('@staff_email', recipient)
    mail(from: from_address, to: recipient, subject: subject , body: email_body, content_type: 'text/html')
  end

  def alert_staff_on_checkout_failure(reservation, recipient, error_message)
    email_template = EmailTemplate.find_by_title('STAFF_FAILURE_CHECKOUT_ALERT_EMAIL')
    host =  ReservationMailer.default_url_options[:host]
    subject = email_template.subject.gsub('@full_name', reservation.primary_guest.full_name.to_s)
    .gsub('@room_number', reservation.current_daily_instance.room.andand.room_no.to_s)
    from_address = reservation.hotel.hotel_from_address
    email_body = get_email_body(reservation, from_address, host, email_template, true)
    email_body = email_body.gsub('@staff_email', recipient).gsub('@error_description', error_message)
    mail(from: from_address, to: recipient, subject: subject , body: email_body, content_type: 'text/html')
  end

  def alert_staff_on_late_checkout_success(reservation, recipient)
    email_template = EmailTemplate.find_by_title('STAFF_SUCCESS_LATE_CHECKOUT_ALERT_EMAIL')
    host =  ReservationMailer.default_url_options[:host]
    selected_late_checkout = reservation.hotel.late_checkout_charges.where('extended_checkout_time= ?',  reservation.late_checkout_time).first
    subject = email_template.subject.gsub('@full_name', reservation.primary_guest.full_name.to_s)
    .gsub('@room_number', reservation.current_daily_instance.room.andand.room_no.to_s)
    .gsub('@late_checkout_time', selected_late_checkout.extended_checkout_time.strftime('%I:%M'))
    from_address = reservation.hotel.hotel_from_address
    email_body = get_email_body(reservation, from_address, host, email_template, true)
    email_body = email_body.gsub('@staff_email', recipient)
    subject = subject.gsub('@late_checkout_time', selected_late_checkout.extended_checkout_time.strftime('%I:%M'))
    .gsub('@late_checkout_amount', ( reservation.hotel.default_currency.andand.symbol + selected_late_checkout.extended_checkout_charge.to_s)) if selected_late_checkout
    mail(from: from_address, to: recipient, subject: subject , body: email_body, content_type: 'text/html')
  end

  def alert_staff_on_late_checkout_failure(reservation, recipient, error_message)
    email_template = EmailTemplate.find_by_title('STAFF_FAILURE_LATE_CHECKOUT_ALERT_EMAIL')
    host =  ReservationMailer.default_url_options[:host]
    subject = email_template.subject.gsub('@full_name', reservation.primary_guest.full_name.to_s)
    .gsub('@room_number', reservation.current_daily_instance.room.andand.room_no.to_s)
    from_address = reservation.hotel.hotel_from_address
    email_body = get_email_body(reservation, from_address, host, email_template, true)
    email_body = email_body.gsub('@staff_email', recipient).gsub('@error_description', error_message)
    mail(from: from_address, to: recipient, subject: subject , body: email_body, content_type: 'text/html')
  end

  # Send confirmation number to guest in stand-alone pms
  def send_confirmation_number_mail(reservation, recipient)
    from_address = reservation.hotel.hotel_from_address
    @confirmation_number = reservation.confirm_no
    guest = reservation.primary_guest
    company = reservation.company
    travel_agent = reservation.travel_agent
    current_daily_instance = reservation.current_daily_instance

    reservation_rate = reservation.current_daily_instance.rate

    # Guest Information
    @reservation = reservation
    @is_reservation_hourly = reservation.is_hourly
    if guest.present?
      @guest_name = guest.full_name
      @primary_email =  guest.email
      @phone = guest.phone
      unless guest.addresses.empty?
        @state = guest.addresses.first.state
        @city = guest.addresses.first.city
        @street1 = guest.addresses.first.street1
        @street2 = guest.addresses.first.street2
        @street3 = guest.addresses.first.street3
      end
    end
    # Company Information
    if company
      @company_name = company.account_name
      @company_state = company.address.state
      @company_city = company.address.city
      @company_street1 = company.address.street1
      @company_street2 = company.address.street2
      @company_street3 = company.address.street3
    end

    # Travel Agent Information
    if travel_agent
      @travel_agent = travel_agent.account_name
      @travel_agent_state = travel_agent.address.state
      @travel_agent_city = travel_agent.address.city
      @travel_agent_street1 = travel_agent.address.street1
      @travel_agent_street2 = travel_agent.address.street2
      @travel_agent_street3 = travel_agent.address.street3
    end
    # Room Type Information
    room_type = current_daily_instance.room_type
    @room_type = room_type.room_type_name
    @room_type_description = room_type.description

    # Reservation Details
    @has_distinct_adults_count_during_stay = reservation.daily_instances.count(:adults, distinct: true) > 1

    @adults = current_daily_instance.adults
    @children = current_daily_instance.children
    @infants = current_daily_instance.infants
    @total_guest = current_daily_instance.total_guests
    @total_nights = reservation.total_nights
    @is_suppress_rate = reservation.is_rate_suppressed
    @arrival_time = reservation.arrival_time
    @departure_time = reservation.departure_time
    unless @is_suppress_rate
      @adr = reservation.standalone_average_rate_amount
      @total_stay_cost = reservation.standalone_total_stay_amount.to_i
    end

    @arrival_date =   reservation.arrival_date
    @dept_date =  reservation.dep_date

    if reservation_rate
      @rate_name = reservation_rate.rate_name
      @rate_desc = reservation_rate.rate_desc
    end
    @currency = reservation.hotel.default_currency.to_s

    @has_multiple_rate = reservation.daily_instances.exclude_dep_date.count(:rate_id, distinct: true) > 1
    @daily_instances = reservation.daily_instances if @has_multiple_rate
    @addons = reservation.addons.select('reservations_addons.quantity as quantity,
                                         addons.name as name,
                                         addons.description as description,
                                         addons.amount as amount')

    # Return the Tax details for the given reservation
    @tax = reservation.tax_details || []
    # Return the Bill Routing Informations
    @bill_routing_informations = mapped_routing_informations(reservation) || []

    # Payment Methods
    @payment_method = reservation.primary_payment_methods.first.andand.payment_type unless reservation.primary_payment_methods.empty?
    subject = I18n.t('mailer.reservation_mailer.reservation_confirmation_mail', confirmation_number: reservation.confirm_no.to_s,
                                                                                hotel_name: reservation.hotel.name)
    email_template = reservation.hotel.email_templates.find_by_title('CONFIRMATION')
    if email_template
      body = get_confirmation_email_body(reservation, email_template.body)
      mail(from: from_address, to: recipient, subject: subject, body: body, content_type: 'text/html')
    else
      mail(from: from_address, to: recipient, subject: subject) do |format|
        format.html { render 'send_confirmation_number_mail' }
      end
    end
  end

  def send_guest_bill(reservation, bill)
    subject = I18n.t('mailer.subject.guest_bill', hotel_name: reservation.hotel.name, confirmation_number: reservation.confirm_no.to_s)
    @data = bill.bill_data_for_email(reservation)
    from_address = reservation.hotel.hotel_from_address
    attachments['Invoice.pdf'] = WickedPdf.new.pdf_from_string(
      render_to_string(file: 'reservation_mailer/send_guest_bill_pdf.haml')
      )
    # mail to company card if bill is attached to company card
    if bill.account_id.present?
      to_address = reservation.company.andand.emails.andand.first.andand.value
    else
      to_address = reservation.primary_guest.andand.email
    end
    mail(from: from_address, to: to_address, subject: subject) if to_address
  end
  
  def guest_send_cancellation_email(reservation, refund_amount)
    subject       = reservation.hotel.settings.cancellation_communication_title
    from_address  = reservation.hotel.hotel_from_address
    to_address    = reservation.primary_guest.andand.email
    cust_name1    = reservation.primary_guest.andand.first_name
    booking_ref    = reservation.confirm_no
    acc_refund    = "%.2f" % refund_amount.to_i
    cancellation_communication_text = "\"#{reservation.hotel.settings.cancellation_communication_text}\""
    @email_text   = ""
    @email_text   = eval(cancellation_communication_text) if reservation.hotel.settings.cancellation_communication_text.present?
    mail(from: from_address, to: to_address, subject: subject) if to_address && @email_text.present?
  end

  private

  def get_confirmation_email_body(reservation, email_body)
    guest = reservation.primary_guest
    hotel = reservation.hotel
    total_stay_cost = hotel.is_third_party_pms_configured? ? reservation.get_total_stay_amount : reservation.standalone_total_stay_amount
    duration = reservation.is_hourly ? (reservation.departure_time - reservation.arrival_time) / 1.hour : (reservation.dep_date - reservation.arrival_date).to_i

    duration_time = "%g" % ("%.2f" % duration)
    duration_time = reservation.is_hourly ? duration_time + " hours" : duration_time + " days"
    dynamic_text = {
      '@confirm_no' => reservation.confirm_no,
      '@guest_name' => [guest.title, guest.full_name].reject(&:blank?).join(". "),
      '@street' => hotel.street,
      '@city' => hotel.city,
      '@state' => hotel.state,
      '@country' => hotel.country.andand.name,
      '@zipcode' => hotel.zipcode,
      '@custom_confirm_text' => hotel.settings.confirmation_template_text,
      '@arrival_date' => reservation.arrival_date.andand.strftime('%A, %B %d, %Y'),
      '@arrival_time' => reservation.arrival_time.andand.in_time_zone(hotel.tz_info).andand.strftime('%H:%M'),
      '@departure_time' => reservation.departure_time.andand.in_time_zone(hotel.tz_info).andand.strftime('%H:%M'),
      '@departure_date' => reservation.departure_date.andand.strftime('%A, %B %d, %Y'),
      '@room_type_desc' => reservation.current_daily_instance.andand.room_type.andand.room_type_name,
      '@hotel_currency' => hotel.default_currency.andand.symbol,
      '@total_stay_cost' => total_stay_cost,
      '@template_logo' => hotel.template_logo.url,
      '@location_image' => hotel.andand.guest_bill_print_setting.andand.location_image.andand.image.andand.url,
      '@duration' => duration_time,
      '@hotel_name' => hotel.name
    }
    dynamic_text.each do |key, value|
      email_body = email_body.gsub(key, value.to_s) if email_body.include?(key)
    end
    email_body
  end

  def get_email_body(reservation, from_address, host, email_template, alert_staff_email = false)
    email_body = email_template.body
    if reservation.hotel.template_logo
      hotel_logo = reservation.hotel.template_logo.url
    else
      hotel_logo = host + '/assets/logo.png'
    end
    email_type = Setting.guest_web_email_types[:checkout]
    if ((reservation.status.to_s == Setting.reservation_input_status[:checked_in]) &&
       reservation.is_late_checkout_available?)
      email_type = Setting.guest_web_email_types[:late_checkout]
    elsif (reservation.status.to_s == Setting.reservation_input_status[:reserved])
      if reservation.hotel.is_pre_checkin_only? && reservation.hotel.settings.checkin_action.to_s != Setting.checkin_actions[:auto_checkin].to_s
        email_type = Setting.guest_web_email_types[:pre_checkin]
      else
        email_type = Setting.guest_web_email_types[:checkin]
      end
    end
    if reservation.primary_guest.title.present?
      title = reservation.primary_guest.title
      guest_title = title[title.length-1] == '.' ? title : (title + ".")
    else
      guest_title = ""
    end
    guest_web_token = GuestWebToken.find_by_guest_detail_id_and_is_active_and_reservation_id_and_email_type(reservation.primary_guest.andand.id, true, reservation.id, email_type).andand.access_token
    support_from_address = from_address
    # Need to change following key_delivery_message hard coded message once CICO-9633 is added to release
    email_body = email_body.gsub('@image_path', host + '/' + guest_reservation_qr_code_image_path(key_id: @key_id).to_s)
      .gsub('@title', guest_title.to_s)
      .gsub('@first_name', reservation.primary_guest.first_name.to_s)
      .gsub('@last_name', reservation.primary_guest.last_name.to_s)
      .gsub('@guest_email', reservation.primary_guest.email.to_s)
      .gsub('@snt_logo', "#{host}/assets/logo.png")
      .gsub('@room_number', reservation.current_daily_instance.room.andand.room_no.to_s)
      .gsub('@hotel_name', reservation.hotel.name.to_s)
      .gsub('@full_name',  reservation.primary_guest.full_name.to_s)
      .gsub('@arrival_date',  reservation.arrival_date.andand.strftime(reservation.hotel.date_format).to_s)
      .gsub('@departure_date',  reservation.dep_date.andand.strftime(reservation.hotel.date_format).to_s)
      .gsub('@confirmation_number',  reservation.confirm_no.to_s)
      .gsub('@from_address', support_from_address)
      .gsub('@address', from_address)
      .gsub('@user_email', reservation.primary_guest.email.to_s)
      .gsub('@hotel_brand', reservation.hotel.hotel_brand.andand.name.to_s)
      .gsub('@hotel_phone', reservation.hotel.hotel_phone.to_s)
      .gsub('@key_icon', host + '/assets/key_icon.png')
      .gsub('@checkin_icon', host + '/assets/checkin-now.png')
      .gsub('@checkout_icon', host + '/assets/checkout-now.png')
      .gsub('@latecheckout_icon', host + '/assets/late-checkout.png')
      .gsub('@key_black', host + '/assets/key-icon-black.png')
      .gsub('@mgm_bg', host + '/assets/email_header_bg_mgm.jpg')
      .gsub('@key_delivery_message',reservation.hotel.settings.key_delivery_message.to_s)
      .gsub('@mgm_bg', host + '/assets/email_header_bg_mgm.jpg')
      .gsub('@hotellogo', hotel_logo)
      .gsub("@url", host.to_s + '/guest_web/home/index?guest_web_token=' + guest_web_token.to_s + '&reservation_id=' + reservation.id.to_s)
      .gsub('@qr_link', host + '/' + guest_reservation_qr_code_image_path(key_id: @key_id).to_s)
      .gsub('@hotel_address', [reservation.hotel.name.to_s, reservation.hotel.city.to_s, reservation.hotel.state.to_s, reservation.hotel.country.name.to_s].join(', '))
    if reservation.is_upsell_applied && alert_staff_email
      email_body = email_body.gsub('@upgrade_option', reservation.current_daily_instance.andand.room_type.andand.room_type_name.to_s).gsub('@upgrade_description', '')
    else
      email_body = email_body.gsub('@upgrade_option', I18n.t(:none)).gsub('@upgrade_description', '')
    end
    if reservation.is_opted_late_checkout && alert_staff_email
      selected_late_checkout = reservation.hotel.late_checkout_charges.where('extended_checkout_time= ?',  reservation.late_checkout_time).first
      email_body = email_body.gsub('@late_checkout_time', selected_late_checkout.extended_checkout_time.strftime('%I:%M')).gsub('@late_checkout_amount',(reservation.hotel.default_currency.andand.symbol.to_s + ('%.2f' % selected_late_checkout.extended_checkout_charge).to_s)) if selected_late_checkout
    end
    pre_checkin_email_body = reservation.hotel.settings.pre_checkin_email_body.gsub(/\n/, "<br/>") if reservation.hotel.settings.pre_checkin_email_body
    pre_checkin_email_bottom_body = reservation.hotel.settings.pre_checkin_email_bottom_body.gsub(/\n/, "<br/>") if reservation.hotel.settings.pre_checkin_email_bottom_body
    email_body = email_body.gsub('@pre_checkin_email_body', pre_checkin_email_body.to_s) if email_body.include?('@pre_checkin_email_body')
    email_body = email_body.gsub('@pre_checkin_email_bottom_body', pre_checkin_email_bottom_body.to_s) if email_body.include?('@pre_checkin_email_bottom_body')


    email_body += email_template.signature
    email_body
  end

  def mapped_routing_informations(reservation)

    entity_result = reservation.billing_informations

    current_hotel = reservation.hotel


    entity_result.map do |entity|
      attached_charge_codes = current_hotel.charge_codes
                              .joins('INNER JOIN charge_routings on charge_routings.charge_code_id = charge_codes.id')
                              .where('charge_routings.bill_id = ? AND charge_routings.to_bill_id = ?', entity.from_bill_id, entity.to_bill_id)
                              .select('charge_codes.id, charge_codes.charge_code, charge_codes.description')
      attached_entity = entity.account_id.present? ? current_hotel.hotel_chain.accounts.find(entity.account_id) :
                                                   current_hotel.reservations.find(entity.reservation_id)
      attached_billing_groups = current_hotel.billing_groups
                               .joins('INNER JOIN charge_routings on charge_routings.billing_group_id = billing_groups.id')
                               .where('charge_routings.bill_id = ? AND charge_routings.to_bill_id = ? ', entity.from_bill_id, entity.to_bill_id)
                               .select('billing_groups.id, billing_groups.name')
      {
        entity: attached_entity,
        entity_type: entity.account_id.present? ? map_account_type(reservation.hotel, entity.account_id)  : Setting.routing_entity_types[:reservation],
        attached_charge_codes: attached_charge_codes,
        attached_billing_groups: attached_billing_groups,
        bill_no: entity.to_bill_no
      }
     end
  end

  def map_account_type(current_hotel, account_id)
    account = current_hotel.hotel_chain.accounts.find(account_id)
    account.andand.account_type === :COMPANY ? Setting.routing_entity_types[:company_card] : Setting.routing_entity_types[:travel_agent]
  end

end
