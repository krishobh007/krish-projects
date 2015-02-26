class GuestWeb::HomeController < ApplicationController

  before_filter :check_session, :except=>[:user_activation]
  before_filter :validate_guest_web_reservation,:only=>[:index]

  layout 'guestweb'
  # ****************************************#
  # Method to render webcheckout index page      #
  # ****************************************#
  def index
    @data, status, errors = {}, FAILURE, []
    reservation = Reservation.find_by_id(params[:reservation_id])
    @current_theme = reservation.andand.hotel.andand.settings.theme || reservation.andand.hotel.andand.hotel_chain.settings.theme || 'guestweb'
    if reservation.status.to_s == Setting.reservation_input_status[:checked_in]
      @data = ViewMappings::GuestWeb::WebCheckoutMapping.map_web_checkout_index(reservation)
    end
    @data[:reservation_id] = reservation.id.to_s
    guest_web_token = reservation.guest_web_tokens.find_by_access_token(session[:guest_web_token])
    @data[:is_active_token] = guest_web_token.is_active.to_s
    @data[:reservation_status] = !guest_web_token.is_active ?  ((guest_web_token.email_type ==  Setting.guest_web_email_types[:checkin]) ? 'CHECKIN' : 'CHECKOUT') : reservation.status.to_s
    @data[:is_checkedout] = (reservation.status.to_s == Setting.reservation_input_status[:checked_out]).to_s
    @data[:is_checkin] =  ((reservation.status.to_s == Setting.reservation_input_status[:reserved]) && (reservation.arrival_date == reservation.hotel.active_business_date)).to_s
    @data[:hotel_phone] = reservation.hotel.andand.hotel_phone.to_s
    @data[:is_auto_checkin] = (reservation.andand.hotel.settings.checkin_action.to_s == Setting.checkin_actions[:auto_checkin].to_s).to_s
    @data[:hotel_phone] = reservation.hotel.andand.hotel_phone.to_s
    @data[:access_token] = session[:guest_web_token]
    @data[:is_cc_attached] = reservation.valid_primary_payment_method.andand.credit_card?.to_s # Using the same scope used in listing payment type in staycard reservation.is_cc_attached?.to_s
    @data[:business_date] = reservation.hotel.active_business_date.strftime('%Y-%m-%d') if reservation.hotel.andand.active_business_date.present?
    @data[:currency_symbol] = reservation.hotel.default_currency.andand.symbol
    @data[:date_format] = ViewMappings::GuestWeb::WebCheckinMapping.get_date_format(reservation.hotel.default_date_format)
    @data[:hotel_logo] = reservation.hotel.template_logo.url
    @data[:mli_merchat_id] = reservation.hotel.settings.mli_merchant_id
    @data[:room_verification_instruction] = reservation.hotel.settings.room_verification_instruction
    @data[:is_precheckin_only] = (reservation.hotel.settings.is_pre_checkin_only || Setting.defaults[:pre_checkin_enabled]).to_s
    @data[:payment_gateway]  = reservation.hotel.payment_gateway
    response = {status: status, data: @data,errors: errors}
    respond_to do |format|
      format.html
      format.json  { render json: response }
    end
  end

  # *******************************************#
  # Method to render webcheckout bill details page   #
  # ******************************************#
  def bill_details
    data, status, errors = {}, SUCCESS, []
    reservation = Reservation.find(params[:reservation_id])

    data[:bill_details] = reservation.guest_bill_details
    data[:room_number] = reservation.current_daily_instance.andand.room.andand.room_no
    response = { status: status, data: data, errors: errors }
    respond_to do |format|
      format.html
      format.json  { render json: response }
    end
  end


  #    ---------  Method to verify room number  ---------   #
  def verify_room
    data, status, errors = {}, FAILURE, []
    reservation = Reservation.find(params[:reservation_id])
    status = SUCCESS if reservation.current_room_number == params[:room_number]
    response = { status: status, data: data, errors: errors }
    respond_to do |format|
      format.html
      format.json  { render json: response }
    end

  end
  # *************************************#
  # Method to checkout from guestweb           #
  # *************************************#

  def checkout_guest
    data, status, errors, recipients = {}, FAILURE, [], []
    reservation =  Reservation.find(params[:reservation_id])

    if reservation.present?
      hotel = reservation.hotel

      if reservation.status === :CHECKEDIN &&  hotel.active_business_date <= reservation.dep_date
        if reservation.hotel.is_third_party_pms_configured?
          result = reservation.checkout_with_external_pms
          checkout_status = reservation.update_checkout_details if result[:status]
        else
          checkout_status = reservation.update_checkout_details
        end
        recipients = reservation.hotel.web_checkout_staff_alert_emails.checkout_alerts.pluck(:email)
        is_alert_staff = (reservation.hotel.settings.is_send_checkout_staff_alert.to_s == 'true' && !recipients.empty?)

        if checkout_status
          Action.record!(reservation, :CHECKEDOUT, :WEB, hotel.id)
          activity_status = Setting.user_activity[:success]

          if is_alert_staff
            if reservation.hotel.settings.web_checkout_staff_alert_option == Setting.alert_staff_options[:ALL]
              recipients.each do |recipient|
                ReservationMailer.alert_staff_on_checkout_success(reservation, recipient).deliver
              end
            end
          end
          status = SUCCESS

          GuestWebToken.find_by_access_token(session[:guest_web_token]).update_attributes(is_active: false)
        else
          if is_alert_staff
            recipients.each do |recipient|
              ReservationMailer.alert_staff_on_checkout_failure(reservation, recipient, result[:message]).deliver
            end
          end
          errors << I18n.t(:checkout_failure)
          activity_status = Setting.user_activity[:failure]
        end
      else
        errors << I18n.t(:invalid_reservation_status)
        activity_status = Setting.user_activity[:failure]
      end
    else
      errors << I18n.t(:invalid_parameters)
      activity_status = Setting.user_activity[:failure]
    end
    message = errors
    reservation.primary_guest.record_user_activity(:WEB, reservation.hotel.id, Setting.user_activity[:login], activity_status, message, request.remote_ip)
    response = { status: status, data: data, errors: errors }
    respond_to do |format|
      format.html
      format.json  { render json: response }
    end
  end

  def user_activation
    @data, errors = {}, []
    user = User.find_by_perishable_token(params[:perishable_token])
    hotel_chain = HotelChain.find_by_code(params[:chain_code])
    @current_theme = hotel_chain.settings.theme 
    if user.present?
      @data[:login] = user.login
      @data[:token] = user.perishable_token
      @data[:id] = user.id 
      user.update_attributes(is_email_verified: true) if params[:password_reset] == "false"
    else
      @data[:token] =params[:perishable_token]
      @data[:is_token_expired] = "true"
    end
    @data[:is_password_reset] = params[:password_reset]
    render layout: "guestweb_zest"       
  end

end
