class Api::HotelSettingsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date

  # Returns a hash of the hotel's settings
  def index
  end

  def icare
    data = icare_params
    render partial: 'admin/icare/icare_services', locals: { data: data }
  end

  # Update the settings
  def change_settings
    hotel_setting_params = mapped_params
    if hotel_setting_params[:error_message].present?
      render(json: [hotel_setting_params[:error_message]], status: :unprocessable_entity)
    else
      hotel_setting = HotelSetting.new(mapped_params)
      staff_emails = params[:housekeeping][:email].to_s.split(';').map(&:strip) if params[:housekeeping].present? && params[:housekeeping][:email].present?
      current_hotel.staff_alert_emails.queue_reservation_alerts.destroy_all
      staff_emails.each do |staff_email|
       staff_email =  current_hotel.staff_alert_emails.queue_reservation_alerts.create(email: staff_email)
       render(json: staff_email.errors.full_messages, status: :unprocessable_entity) if staff_email.errors.present?
      end if staff_emails && current_hotel.settings.is_queue_rooms_on
      hotel_setting.save || render(json: hotel_setting.errors.full_messages, status: :unprocessable_entity)
    end
  end

  def save_hotel_reservation_settings
    current_hotel.settings.use_recommended_rate_display = params[:recommended_rate_display]
    current_hotel.settings.default_rate_display_name = params[:default_rate_display_name]
    current_hotel.settings.is_hourly_rate_on =  params[:is_hourly_rate_on]
    current_hotel.settings.is_addon_on = params[:is_addon_on]
    max_guests = params[:max_guests]
    if max_guests.present?
      current_hotel.settings.reservation_max_adults = max_guests[:max_adults].andand.to_i
      current_hotel.settings.reservation_max_children = max_guests[:max_children].andand.to_i
      current_hotel.settings.reservation_max_infants = max_guests[:max_infants].andand.to_i
    end
    current_hotel.settings.disable_cc_swipe = params[:disable_cc_swipe]
    current_hotel.settings.disable_terms_conditions_checkin = params[:disable_terms_conditions_checkin]
    current_hotel.settings.disable_email_phone_dialog = params[:disable_email_phone_dialog]
    current_hotel.settings.disable_early_departure_penalty = params[:disable_early_departure_penalty]
    current_hotel.settings.disable_reservation_posting_control = params[:disable_reservation_posting_control]
  end

  def show_hotel_reservation_settings
    @settings = current_hotel.settings
  end

  def icare
    data = icare_params
    respond_to do |format|
      format.html { render partial: 'admin/icare/icare_services', locals: { data: data } }
      format.json { render json: data }
    end
  end

  def test_mli_payment_gate_way
    result = Mli.new(nil).test_mli_payment_gate_way_connection
    render json: { status: result["status"]=="OPERATING" ? SUCCESS : FAILURE, data: nil, errors: result[:errors]}
  end

  def payment_types
    @payment_types = PaymentType.activated_non_credit_card(current_hotel).order(:description)
  end

  def credit_card_types
    @credit_card_types = Ref::CreditCardType.activated(current_hotel).order(:description)
    @payment_types_marked_as_is_cc = PaymentType.activated_credit_card(current_hotel).order(:description)
  end

  private

  def mapped_params
    settings = { hotel: current_hotel }

    housekeeping = params[:housekeeping]
    if housekeeping
      settings.merge!(
        checkin_inspected_only: housekeeping[:checkin_inspected_only],
        use_pickup: housekeeping[:use_pickup],
        use_inspected: housekeeping[:use_inspected],
        is_queue_rooms_on: housekeeping[:is_queue_rooms_on],
        enable_room_status_at_checkout: housekeeping[:enable_room_status_at_checkout]
      )
    end

    icare = params[:icare]

    if icare
      settings.merge!(

        icare_enabled: icare[:enabled],
        icare_combined_key_room_charge_create: icare[:combined_key_room_charge_create],
        icare_save_customer_info: icare[:save_customer_info],
        icare_enabled: icare[:icare_enabled],
        icare_debit_charge_code_id: icare[:icare_debit_charge_code_id],
        icare_credit_charge_code_id: icare[:icare_credit_charge_code_id],
        icare_username: icare[:icare_username],
        icare_password: icare[:icare_password],
        icare_url: icare[:icare_url],
        icare_account_preamble: icare[:icare_account_preamble],
        icare_account_length: icare[:icare_account_length],
        pms_alert_code: icare[:pms_alert_code]
      )
    end

    business_date = params[:business_date]
    if business_date.present?
      if business_date[:changing_hour].present? && business_date[:changing_minute].present? && business_date[:business_date_prime_time].present?
        auto_change_time = ActiveSupport::TimeZone[current_hotel.tz_info]
                          .parse("#{business_date[:changing_hour]}:" + (business_date[:changing_minute] || '00') +
                           business_date[:business_date_prime_time])
        settings.merge!(
          is_auto_change_bussiness_date: business_date[:is_auto_change_bussiness_date],
          business_date_change_time: auto_change_time
        )
      else
        settings.merge!(error_message: I18n.t(:invalid_time_setting))
        return settings
      end
    end

    if params.key?(:ar_number_settings)
      ar_number_settings = params[:ar_number_settings]
      if ar_number_settings
        settings.merge!(
          is_auto_assign_ar_numbers: ar_number_settings[:is_auto_assign_ar_numbers]
        )
      end
    end

    if params.key?(:no_show_charge_code_id)
      no_show_charge_code_id = params[:no_show_charge_code_id]
      if no_show_charge_code_id
        settings.merge!(no_show_charge_code_id: no_show_charge_code_id)
      else
        settings.merge!(no_show_charge_code_id: nil)
      end
    end

    settings
  end

  def icare_params
    icare_data = {}
    icare_data[:icare_enabled] = current_hotel.settings.icare_enabled
    icare_data[:save_customer_info] = current_hotel.settings.icare_save_customer_info
    icare_data[:combined_key_room_charge_create] = current_hotel.settings.icare_combined_key_room_charge_create
    icare_data[:save_customer_info] = current_hotel.settings.icare_save_customer_info.nil? ? Setting.defaults[:icare_save_customer_info] :
                                      current_hotel.settings.icare_save_customer_info
    icare_data[:icare_debit_charge_code_id] = current_hotel.settings.icare_debit_charge_code_id
    icare_data[:icare_credit_charge_code_id] = current_hotel.settings.icare_credit_charge_code_id
    icare_data[:icare_username] = current_hotel.settings.icare_username
    icare_data[:icare_password] = current_hotel.settings.icare_password
    icare_data[:icare_url] = current_hotel.settings.icare_url
    icare_data[:icare_account_preamble] = current_hotel.settings.icare_account_preamble
    icare_data[:icare_account_length] = current_hotel.settings.icare_account_length
    icare_data[:charge_codes] = current_hotel.charge_codes
    icare_data[:pms_alert_code] = current_hotel.settings.pms_alert_code
    icare_data
  end

end
