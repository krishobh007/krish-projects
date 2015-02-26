class GuestWeb::CheckinsController < ApplicationController

  before_filter :check_session
  layout 'guestweb'

  # ************************************************#
  # Method to render webchekin confirm reservation page  #
  # ***********************************************#
  def get_checkin_reservation
    data, errors, status = {}, [], FAILURE
      mailed_reservation =  Reservation.find(params[:reservation_id])
      is_auto_checkin = (mailed_reservation.hotel.settings.is_pre_checkin_only =="true" ? true : false || Setting.defaults[:pre_checkin_enabled]) && (mailed_reservation.hotel.settings.checkin_action.to_s == Setting.checkin_actions[:auto_checkin].to_s)
      validate_cc = (is_auto_checkin && mailed_reservation.is_cc_attached) || !is_auto_checkin 
    if params[:departure_date].present? && ( validate_cc ? params[:credit_card].present? : true )
      guest_detail = GuestWebToken.find_by_access_token(request.headers['Authorization']).guest_detail
      confirmed_reservation = guest_detail.reservations.where('dep_date=? and confirm_no=?', Date.strptime(params[:departure_date], '%m-%d-%Y'), mailed_reservation.confirm_no).first

      if (confirmed_reservation.present?) && (confirmed_reservation.dep_date == mailed_reservation.dep_date)
        payment_method = confirmed_reservation.primary_payment_method
        if ( validate_cc ? payment_method.mli_token_display == params[:credit_card].to_s : true )
          data = ViewMappings::GuestWeb::WebCheckinMapping.map_web_checkin_reservation_details(mailed_reservation)
          status = SUCCESS
        else
          errors = [I18n.t(:invalid_credit_card)]
        end
      else
        errors = [I18n.t(:invalid_dep_date)]
      end

      data[:is_reservation_available] = confirmed_reservation.present?
      data[:hotel_phone] = mailed_reservation.hotel.hotel_phone
      data[:terms_and_conditions] = mailed_reservation.hotel.settings.terms_and_conditions
    else
      errors << 'Invalid Parameters'
    end

    response = { status: status, data: data, errors: errors }

    respond_to do |format|
      format.html
      format.json  { render json: response }
    end
  end

  # ************************************************#
  # Method to render webchekin confirm reservation page  #
  # ***********************************************#
  def upgrade_options
    data, errors, status = {}, [], FAILURE
    reservation =  Reservation.find(params[:reservation_id])
    if reservation.current_daily_instance && reservation.current_daily_instance.room_type
      data = ViewMappings::RoomTypesMapping.upsell_options(reservation)
    end
    status = SUCCESS
    response = { status: status, data: data, errors: errors }
    respond_to do |format|
      format.html
      format.json  { render json: response }
    end
  end

  # **********************************#
  # Method to checkin from Guest-Web      #
  # **********************************#
  def checkin
    data, errors, status = {}, [], FAILURE
    reservation =  Reservation.find(params[:reservation_id])
    third_party_pms_configured = reservation.hotel.is_third_party_pms_configured?
    web_checkedin_count = reservation.hotel.actions.with_action_type(:CHECKEDIN).with_application(:WEB).where(actionable_type: 'Reservation').where(business_date: reservation.hotel.active_business_date).count
    if reservation.hotel.settings.is_pre_checkin_only == "true" && web_checkedin_count >= reservation.hotel.settings.max_webcheckin.to_i
      errors = ['No more web checkins allowed today']
      activity_status = Setting.user_activity[:failure]
      message = errors
    else
      signature_image = nil # #Can be used if there is signature requirement from GuestWeb Checkin
      number_of_keys = 1
      result = reservation.checkin(signature_image, :WEB)
      recipients =  reservation.hotel.web_checkin_staff_alert_emails.pluck(:email)
      if result[:success]
        activity_status = Setting.user_activity[:success]
        message = I18n.t(:web_login_success)
        # Inactivate guest web token
        GuestWebToken.find_by_access_token(session[:guest_web_token]).update_attributes(is_active: false)
        # Send checkin success staff alert emails
        reservation.send_checkin_success_staff_alert(recipients)
        #Removed Sync reservation with external pms as per CICO-10462
         
        #Generate key
        begin
          new_key = reservation.create_reservation_key('false', number_of_keys)
          key_api = KeyApi.new(reservation.hotel_id)
          result = key_api.create_key(reservation, new_key, reservation.primary_guest.email, request.host_with_port, {})
          if result[:status]
            data[:key_info] = Base64.encode64(reservation.andand.reservation_keys.last.andand.qr_data.to_s)
          end
          data[:room_no] = reservation.current_daily_instance.room.room_no
          data[:delivery_message] = reservation.hotel.settings.key_delivery_message
          status = SUCCESS
        rescue ActiveRecord::RecordInvalid => ex
          status, data = FAILURE, []
          errors << ex.message
        end
      
      else
        #Send checkin failure staff alerts
        reservation.send_checkin_failure_staff_alert(recipients, result[:message].to_s)
        errors = ['Unable to check-in']
        activity_status = Setting.user_activity[:failure]
        message = errors
      end
    end
    reservation.primary_guest.record_user_activity(:WEB, reservation.hotel.id, Setting.user_activity[:login], activity_status, message, request.remote_ip)
    response = { status: status, data: data, errors: errors }
    respond_to do |format|
      format.html
      format.json  { render json: response }
    end
  end

  # *************************************#
  # Method to upgrade room from guest-web  #
  # ************************************#
  def upgrade_room
    data, errors, status = {}, [], FAILURE
    if params[:reservation_id] && params[:upsell_amount_id] && params[:room_no]
      reservation =  Reservation.find(params[:reservation_id])

      upsell_amount = reservation.hotel.upsell_amounts.find(params[:upsell_amount_id]).amount.to_f

      result = reservation.upgrade_room(upsell_amount, params[:room_no], Ref::Application[:WEB])

      if result[:status] && result[:errors].blank?
        reservation.sync_booking_with_external_pms if reservation.hotel.is_third_party_pms_configured?
        data = ViewMappings::GuestWeb::WebCheckinMapping.map_web_checkin_reservation_details(reservation)
        status = SUCCESS
      end
    else
      errors << 'Unable to upgrade room'
    end
    response = { status: status, data: data, errors: errors }
    respond_to do |format|
      format.html
      format.json  { render json: response }
    end
  end
end
