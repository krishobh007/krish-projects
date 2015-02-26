class Admin::HotelsController < ApplicationController
  before_filter :check_session, :check_role

  layout 'admin'
  # GET /hotels
  # GET /hotels.json
  def index
    if current_user.admin?
      hotels = Hotel.filter(params[:hotel_chain], params[:hotel_brand])
    else
      hotels = current_user.hotels.filter(params[:hotel_chain], params[:hotel_brand])
    end

    data = {
      'hotels' => hotels.map do |hotel|
        {
          'id' => hotel.id,
          'hotel_name' => hotel.name,
          'domain_name' => hotel.domain_name,
          'brand_name' => hotel.hotel_brand.andand.name,
          'state' => hotel.andand.state,
          'city' => hotel.andand.city,
          'chain_name' => hotel.hotel_chain.name,
          'number_of_rooms' => hotel.number_of_rooms,
          'is_res_import_on' => hotel.is_res_import_on.to_s,
          'is_external_pms_available' => hotel.pms_type.present?.to_s
        }
      end,
      'chains' => HotelChain.order('name').map { |chain| { 'id' => chain.id, 'name' => chain.name } },
      'brands' => HotelBrand.order('name').map { |brand| { 'id' => brand.id, 'name' => brand.name } }
    }
    response = { status: SUCCESS, data: data, errors: [] }
    render json: response
  end

  # GET /hotels/new
  # GET /hotels/new.json
  def new
    self.current_hotel = nil

    data = {
     'chains' => HotelChain.order('name').map { |chain| { 'id' => chain.id, 'name' => chain.name, brands: chain.hotel_brands.map {|brand| { id: brand.id, name:brand.name}}} },
      'time_zones' => timezones,
      'countries' => Country.order('name').map { |country| { 'id' => country.id, 'name' => country.name } },
      'currency_list' => Ref::CurrencyCode.all.map { |currency| { 'id' => currency.id, 'code' => currency.value } },
      'date_formats' => Ref::DateFormat.all.map { |date_format| { 'id' => date_format.id, 'value' => date_format.value } },
      'pms_types' => Ref::PmsType.all.map { |pms_type| { 'value' => pms_type.value, 'description' => pms_type.description } },
      'signature_display' => Setting.signature_display.map { |key, value| value },
      'is_pms_tokenized' => 'true',
      'use_kiosk_entity_id_for_fetch_booking' => 'false',
      'use_snt_entity_id_for_checkin_checkout' => 'false',
      'mli_access_url' => Setting.mli_access_url,
      'mli_payment_gateway_url' => Setting.mli_payment_gateway_url,
      'mli_api_version' => Setting.mli_api_version
    }
    response = { status: SUCCESS, data: data, errors: [] }
    render json: response
  end

  # GET /hotels/1/edit
  def edit
    if current_user.admin?
      hotel = Hotel.find(params[:id])
      self.current_hotel = hotel
    else
      hotel = current_hotel
    end
    data = {
      'id' => hotel.id,
      'chains' => HotelChain.order('name').map { |chain| { 'id' => chain.id, 'name' => chain.name, brands: chain.hotel_brands.map {|brand| { id: brand.id, name:brand.name}}} },
      'countries' => Country.order('name').map { |country| { 'id' => country.id, 'name' => country.name } },
      'time_zones' => timezones,
      'hotel_time_zone' => hotel.tz_info ? hotel.tz_info : '' ,
      'currency_list' => Ref::CurrencyCode.all.map { |currency| { 'id' => currency.id, 'code' => currency.value } },
      'date_formats' => Ref::DateFormat.all.map { |date_format| { 'id' => date_format.id, 'value' => date_format.value } },
      'hotel_date_format' => hotel.default_date_format_id,
      'pms_types' => Ref::PmsType.all.map { |pms_type| { 'value' => pms_type.value, 'description' => pms_type.description } },
      'hotel_pms_type' => hotel.pms_type.andand.value.to_s,
      'is_pms_tokenized' => hotel.settings.is_pms_tokenized ? 'true' : 'false',
      'do_not_update_video_checkout' => hotel.settings.do_not_update_video_checkout,
      'use_kiosk_entity_id_for_fetch_booking' => hotel.settings.use_kiosk_entity_id_for_fetch_booking ? 'true' : 'false',
      'use_snt_entity_id_for_checkin_checkout' => hotel.settings.use_snt_entity_id_for_checkin_checkout ? 'true' : 'false',
      'hotel_name' => hotel.name,
      'domain_name' => hotel.domain_name,
      'hotel_code' => hotel.code,
      'hotel_brand' => hotel.hotel_brand_id,
      'selected_language' => hotel.language_id,
      'hotel_chain' => hotel.hotel_chain_id,
      'street' => hotel.street,
      'city' => hotel.city,
      'state' => hotel.state,
      'zipcode' => hotel.zipcode,
      'country' => hotel.country_id,
      'phone' => hotel.hotel_phone,
      'number_of_rooms' => hotel.number_of_rooms,
      'default_currency' => hotel.default_currency_id,
      'contact_first_name' => hotel.main_contact_first_name,
      'contact_last_name' => hotel.main_contact_last_name,
      'contact_email' => hotel.main_contact_email,
      'contact_phone' => hotel.main_contact_phone,
      'required_signature_at' => hotel.settings.require_signature_at ? hotel.settings.require_signature_at : '',
      'check_in_time' => {
        'hour' => hotel.checkin_time ? hotel.checkin_time.strftime('%I') : '',
        'minute' => hotel.checkin_time ? hotel.checkin_time.strftime('%M') : '',
        'primetime' => hotel.checkin_time ? hotel.checkin_time.strftime('%p') : ''
      },
      'check_out_time' => {
        'hour' => hotel.checkout_time ? hotel.checkout_time.strftime('%I') : '',
        'minute' => hotel.checkout_time ? hotel.checkout_time.strftime('%M') : '',
        'primetime' => hotel.checkout_time ? hotel.checkout_time.strftime('%p') : ''
      },
      'latitude' => hotel.latitude,
      'longitude' => hotel.longitude,
      'is_res_import_on' => hotel.is_res_import_on || false,
      'is_external_references_import_on' => hotel.is_external_references_import_on || false,
      'auto_logout_delay' => hotel.auto_logout_delay,
      'mli_hotel_code' => hotel.settings.mli_hotel_code,
      'terms_and_conditions' => hotel.settings.terms_and_conditions,
      'mli_chain_code' => hotel.settings.mli_chain_code,
      'hotel_from_address' => hotel.hotel_from_address,
      'mli_pem_certificate_loaded' => hotel.settings.mli_pem_certificate.present?,
      'hotel_logo' => hotel.icon.url,
      'is_default_rover_logo' => !hotel.icon_file_size?,
      'is_default_template_logo' => !hotel.template_logo_file_size?,
      'hotel_template_logo' => hotel.template_logo.url(:medium),
      'mli_access_url' => Setting.mli_access_url,
      'mli_payment_gateway_url' => Setting.mli_payment_gateway_url,
      'mli_merchant_id' => hotel.settings.mli_merchant_id,
      'mli_api_version' => Setting.mli_api_version,
      'mli_api_key' => hotel.hotel_chain.decrypt_pswd(hotel.settings.mli_api_key),
      'mli_site_code' => hotel.settings.mli_site_code,
      'day_import_freq' => hotel.day_import_freq,
      'night_import_freq' => hotel.night_import_freq,
      'external_references_import_freq' => hotel.external_references_import_freq,
      'payment_gateway' => payment_gateway(hotel),
      'six_merchant_id' => hotel.settings.six_merchant_id,
      'six_validation_code' => hotel.settings.six_validation_code,
      'is_single_digit_search' => hotel.settings.is_single_digit_search,
      'pms_start_date' => hotel.pms_start_date.andand.strftime('%m-%d-%Y').to_s,
      'six_ipage_url' => Setting.six_ipage_url,
      'six_server_location_id' => hotel.settings.six_server_location_id,
      'six_server_ipaddress' => hotel.settings.six_server_ipaddress,
      'six_server_port' => hotel.settings.six_server_port,
      'password_expiry' => hotel.settings.password_expiry.present? ? hotel.settings.password_expiry : Setting.defaults[:max_password_expiry]
    }
    response = { status: SUCCESS, data: data, errors: [] }
    render json: response
  end

  # POST /hotels
  # POST /hotels.json
  def create
    errors = []
    checkin_time =  "#{params[:check_in_hour]}:" + (params[:check_in_min] || '00') + params[:check_in_primetime] if params[:check_in_hour]

    if params[:hotel_time_zone].present? && params[:check_out_hour].present?
      checkout_time = ActiveSupport::TimeZone[params[:hotel_time_zone]].parse("#{params[:check_out_hour]}:" + (params[:check_out_min] || '00') +
                                                                              params[:check_out_primetime]).utc
    end

    hotel_attributes = {
      name: params[:hotel_name],
      domain_name: params[:domain_name],
      code: params[:hotel_code],
      hotel_brand_id: params[:hotel_brand],
      hotel_chain_id: params[:hotel_chain],
      street: params[:street],
      tz_info: params[:hotel_time_zone],
      city: params[:city],
      state: params[:state],
      zipcode: params[:zipcode],
      country_id: params[:country],
      hotel_phone: params[:phone],
      number_of_rooms: params[:number_of_rooms],
      default_currency_id: params[:default_currency],
      default_date_format_id: params[:hotel_date_format],
      main_contact_first_name: params[:contact_first_name],
      main_contact_last_name: params[:contact_last_name],
      main_contact_email: params[:contact_email],
      main_contact_phone: params[:contact_phone],
      language_id: params[:selected_language],
      checkin_time: checkin_time,
      checkout_time: checkout_time,
      is_res_import_on: params[:is_res_import_on] || false,
      is_external_references_import_on: params[:is_external_references_import_on] || false,
      pms_type: params[:hotel_pms_type],
      auto_logout_delay: params[:auto_logout_delay],
      hotel_from_address: params[:hotel_from_address],
      day_import_freq: params[:day_import_freq] || Setting.defaults[:day_import_freq],
      night_import_freq: params[:night_import_freq] || Setting.defaults[:night_import_freq],
      external_references_import_freq: params[:external_references_import_freq] || Setting.defaults[:external_references_import_freq],
      pms_start_date: params[:pms_start_date].blank? ? nil : Date.strptime(params[:pms_start_date], '%m-%d-%Y')
    }

    hotel = Hotel.new(hotel_attributes)
    if params[:hotel_logo].present?
      hotel.set_logo(params[:hotel_logo])
    end

    # Commenting this line of code - Once 6413 conversion complete will remove this comment.
    # if params[:hotel_template_logo].present?
    #   hotel.set_template_logo(params[:hotel_template_logo])
    # end

    # Generate Major ID for beacon
    random = Random.new
    hotel.beacon_uuid_major = random.rand(1...65535)

    if params[:hotel_template_logo].present?
      hotel.set_template_logo(params[:hotel_template_logo])
    end
    if params.key?(:password_expiry) && params[:password_expiry].to_i > Setting.defaults[:max_password_expiry]
      errors = [I18n.t(:password_expiry_crossed_limit)]
    end
    password_expiry = Setting.defaults[:max_password_expiry]
    password_expiry = params[:password_expiry] if params.key?(:password_expiry) && params[:password_expiry].present? && params[:password_expiry].to_i <= Setting.defaults[:max_password_expiry]
    
    if hotel.save && errors.empty?
      if params[:required_signature_at].present?
        hotel.settings.require_signature_at = params[:required_signature_at]
      end

      # Set the business date for this hotel
      hotel.business_dates.create!(business_date: hotel.current_date, status: 'OPEN')

      # Create the remote SFTP folder for the hotel
      SftpUtility.new(hotel.hotel_chain).create_hotel_dir(hotel.code)

      hotel.settings.is_pms_tokenized = params[:is_pms_tokenized]
      hotel.settings.do_not_update_video_checkout = params[:do_not_update_video_checkout]
      hotel.settings.use_kiosk_entity_id_for_fetch_booking = params[:use_kiosk_entity_id_for_fetch_booking]
      hotel.settings.use_snt_entity_id_for_checkin_checkout = params[:use_snt_entity_id_for_checkin_checkout]
      hotel.settings.terms_and_conditions = params[:terms_and_conditions] if current_user.hotel_admin?
      # Save the MLI settings
      hotel.settings.mli_pem_certificate = decode_mli_certificate_file(params[:mli_certificate]) if params[:mli_certificate].present?
      hotel.settings.mli_hotel_code = params[:mli_hotel_code] if params.key?(:mli_hotel_code)
      hotel.settings.password_expiry = password_expiry
      hotel.settings.mli_chain_code = params[:mli_chain_code] if params.key?(:mli_chain_code)
      hotel.settings.mli_merchant_id = params[:mli_merchant_id] if params.key?(:mli_merchant_id)
      hotel.settings.mli_api_key = hotel.hotel_chain.encrypt_pswd(params[:mli_api_key]) if params.key?(:mli_api_key)
      hotel.settings.mli_site_code = params[:mli_site_code] if params.key?(:mli_site_code)
      hotel.settings.is_single_digit_search = params[:is_single_digit_search] if params.key?(:is_single_digit_search)
      response = { 'status' => SUCCESS, 'data' => nil, 'errors' => nil }
    else
      errors += hotel.errors.full_messages
      response = { 'status' => FAILURE, 'data' => nil, 'errors' => errors }
    end

    respond_to do |format|
      format.html { render locals: response }
      format.json { render json: response }
    end
  end

  # PUT /hotels/1
  # PUT /hotels/1.json
  def update
    errors = []
    hotel = current_hotel


    checkin_time = (params.key?(:check_in_hour) ? "#{params[:check_in_hour]}:" : "#{current_hotel.checkin_time.andand.strftime("%H")}:") +
                       (params.key?(:check_in_min) ? "#{params[:check_in_min]}" :  "#{current_hotel.checkin_time.andand.strftime("%M")}") +
                       (params.key?(:check_in_primetime) ? "#{params[:check_in_primetime]}" : "#{current_hotel.checkin_time.andand.strftime("%p")}")

    checkout_time = (params.key?(:check_out_hour) ? "#{params[:check_out_hour]}:" : "#{current_hotel.checkout_time.andand.strftime("%H")}:") +
                       (params.key?(:check_out_min) ? "#{params[:check_out_min]}" :  "#{current_hotel.checkout_time.andand.strftime("%M")}") +
                       (params.key?(:check_out_primetime) ? "#{params[:check_out_primetime]}" : "#{current_hotel.checkout_time.andand.strftime("%p")}")

    hotel_attributes = {
      name: params[:hotel_name],
      domain_name: params[:domain_name],
      street: params[:street],
      city: params[:city],
      tz_info: params[:hotel_time_zone],
      state: params[:state],
      zipcode: params[:zipcode],
      country_id: params[:country],
      hotel_phone: params[:phone],
      number_of_rooms: params[:number_of_rooms],
      default_currency_id: params[:default_currency],
      default_date_format_id: params[:hotel_date_format],
      main_contact_first_name: params[:contact_first_name],
      main_contact_last_name: params[:contact_last_name],
      main_contact_email: params[:contact_email],
      main_contact_phone: params[:contact_phone],
      language_id: params[:selected_language],
      checkin_time: checkin_time,
      checkout_time: checkout_time,
      hotel_chain_id: params[:hotel_chain],
      hotel_brand_id: params[:hotel_brand],
      auto_logout_delay: params[:auto_logout_delay],
      hotel_from_address: params[:hotel_from_address]
    }

    if current_user.admin?
      hotel_attributes[:code] = params[:hotel_code]
      hotel_attributes[:pms_type] = params[:hotel_pms_type]
      hotel_attributes[:day_import_freq] = params[:day_import_freq]
      hotel_attributes[:night_import_freq] = params[:night_import_freq]
      hotel_attributes[:external_references_import_freq] = params[:external_references_import_freq]
      hotel_attributes[:is_external_references_import_on] = params[:is_external_references_import_on]
      hotel_attributes[:pms_start_date] = Date.strptime(params[:pms_start_date], '%m-%d-%Y') unless params[:pms_start_date].blank?
    end

    if params[:hotel_logo].present?
      if params[:hotel_logo] != "false"
        hotel.set_logo(params[:hotel_logo])
      else
         hotel.icon = nil
      end
    end

    if params[:hotel_template_logo].present?
      if params[:hotel_template_logo] != "false" # If value is false , delete existing logo
        hotel.set_template_logo(params[:hotel_template_logo])
      else
       hotel.template_logo = nil
      end
    end

    hotel.attributes = hotel_attributes

    old_code = hotel.code_was if hotel.code_changed? || hotel.hotel_chain_id_changed?
    if params.key?(:password_expiry) && params[:password_expiry].present? && params[:password_expiry].to_i > Setting.defaults[:max_password_expiry]
      errors = [I18n.t(:password_expiry_crossed_limit)]
    end
    password_expiry = Setting.defaults[:max_password_expiry]
    password_expiry = params[:password_expiry] if params.key?(:password_expiry) && params[:password_expiry].present? && params[:password_expiry].to_i <= Setting.defaults[:max_password_expiry]
    
    if hotel.save && errors.empty?
      if params[:required_signature_at].present?
        hotel.settings.require_signature_at = params[:required_signature_at]
      end

      # Rename the hotel code SFTP directory (if the code changed)
      SftpUtility.new(hotel.hotel_chain).rename_hotel_dir(old_code, hotel.code) if old_code

      hotel.settings.is_pms_tokenized = params[:is_pms_tokenized] == 'true'
      hotel.settings.do_not_update_video_checkout = params[:do_not_update_video_checkout]
      hotel.settings.use_kiosk_entity_id_for_fetch_booking = params[:use_kiosk_entity_id_for_fetch_booking] == 'true'
      hotel.settings.use_snt_entity_id_for_checkin_checkout = params[:use_snt_entity_id_for_checkin_checkout] == 'true'
      hotel.settings.terms_and_conditions = params[:terms_and_conditions] if current_user.hotel_admin?

      # Save Payment Gateway
      hotel.settings.payment_gateway = payment_gateway_param(hotel)

      # Save the MLI certificate
      hotel.settings.mli_pem_certificate = decode_mli_certificate_file(params[:mli_certificate]) if params[:mli_certificate].present?
      hotel.settings.mli_hotel_code = params[:mli_hotel_code] if params.key?(:mli_hotel_code)
      hotel.settings.mli_chain_code = params[:mli_chain_code] if params.key?(:mli_chain_code)
      hotel.settings.mli_merchant_id = params[:mli_merchant_id] if params.key?(:mli_merchant_id)
      hotel.settings.mli_api_key = hotel.hotel_chain.encrypt_pswd(params[:mli_api_key]) if params.key?(:mli_api_key)
      hotel.settings.mli_site_code = params[:mli_site_code] if params.key?(:mli_site_code)
      hotel.settings.password_expiry = password_expiry
      # Save Six Payment Configuration
      hotel.settings.six_merchant_id = params[:six_merchant_id] if params.key?(:six_merchant_id)
      hotel.settings.six_validation_code = params[:six_validation_code] if params.key?(:six_validation_code)

      hotel.settings.is_single_digit_search = params[:is_single_digit_search] if params.key?(:is_single_digit_search)

      hotel.settings.six_server_location_id = params[:six_server_location_id] if params.key?(:six_server_location_id)
      hotel.settings.six_server_ipaddress = params[:six_server_ipaddress] if params.key?(:six_server_ipaddress)
      hotel.settings.six_server_port = params[:six_server_port] if params.key?(:six_server_port)


      response = { 'status' => SUCCESS, 'data' => { 'current_hotel' => current_hotel.name.to_s }, 'errors' => nil }
    else
      errors += hotel.errors.full_messages
      response = { 'status' => FAILURE, 'data' => nil, 'errors' => errors }
    end

    respond_to do |format|
      format.html { render locals: response }
      format.json { render json: response }
    end
  end

  # DELETE /hotels/1
  # DELETE /hotels/1.json
  # Hotels details not deleted from database, just keeping a flag to manage this same.
  def destroy
    @hotel = Hotel.find(params[:id])
    @hotel.update_attributes(is_inactive: 'true')

    respond_to do |format|
      format.html { redirect_to admin_hotels_url }
      format.json { render json: { status: SUCCESS } }
    end
  end

  def review_score
    if current_user.guest?
      fail 'Guest not allowed to access this method'
    end
    @hotel = Hotel.find_by_code(params[:hotel_code])
    unless @hotel
      fail 'Hotel Code is not found in the database'
    end
    req_date = Date.parse(params[:req_date])
    unless req_date
      fail 'Invalid output for date'
    end
    @hotel_review_score = @hotel.average_review_score(req_date)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { score: @hotel_review_score } }
    end
  end

  def vip_checkin_count
    # Guest Not allowed to access this method
    if current_user.guest?
      fail 'Guest not allowed to access this method'
    end
    @hotel = Hotel.find_by_code(params[:hotel_code])
    unless @hotel
      fail 'Hotel Code is not found in the database'
    end
    req_date = Date.parse(params[:req_date])
    unless req_date
      fail 'Invalid output for date'
    end
    @hotel_vip_checkin_count = @hotel.vip_checkin_count(req_date)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { vip_count: @hotel_vip_checkin_count } }
    end
  end

  # Return the upsell statistics for a hotel and request date
  def upsell_statistics
    hotel = Hotel.find_by_code(params[:hotel_code])
    req_date = Date.parse(params[:req_date])

    unless hotel
      fail 'Hotel Code is not found in the database'
    end

    unless req_date
      fail 'Invalid output for date'
    end

    @upsell_target_amount = hotel.upsell_target_amount
    @upsell_target_rooms = hotel.upsell_target_rooms
    @total_upsell_revenue = hotel.total_upsell_revenue(req_date)
    @total_upsell_rooms_sold = hotel.total_upsell_rooms_sold(req_date)

    respond_to do |format|
      format.html # show.html.erb
      format.json do
        render json: {
          upsell_target_amount: @upsell_target_amount,
          upsell_target_rooms: @upsell_target_rooms,
          total_upsell_revenue: @total_upsell_revenue,
          total_upsell_rooms_sold: @total_upsell_rooms_sold
        }
      end
    end
  end

  def toggle_res_import_on
    status, data, errors = FAILURE, {}, []
    hotel = Hotel.find(params[:hotel_id])
    if hotel.update_attribute(:is_res_import_on, params[:is_res_import_on])
      status = SUCCESS
    end
    render json: { status: status, data: data, errors: errors }
  end

  # Accepts MLI connection settings and tests the connection
  def test_mli_settings
    settings = { mli_chain_code: params[:mli_chain_code], mli_hotel_code: params[:mli_hotel_code] }

    if params[:mli_pem_certificate].present?
      settings[:mli_pem_certificate] = decode_mli_certificate_file(params[:mli_pem_certificate])
    elsif current_hotel.present?
      settings[:mli_pem_certificate] = current_hotel.settings.mli_pem_certificate
    end
    result = Mli.new(settings, current_hotel.hotel_chain).test_connection
    render json: { status: result[:status] ? SUCCESS : FAILURE, data: nil, errors: result[:errors] }
  end

  private

  def check_role
    if current_user
      if !current_user.admin? && !current_user.hotel_admin?
        redirect_to staff_root_path
      end
    end
  end

  def decode_mli_certificate_file(file)
    file_contents = file.split('base64,')[1]
    Base64.decode64(file_contents)
  end

  def timezones
    ActiveSupport::TimeZone::MAPPING.map { |value, code| { 'value' => value, 'code' => code } }.sort { |a, b| a['value'] <=> b['value'] }
  end

  def payment_gateway_param(hotel)
    ["MLI", "sixpayments"].include?(params[:payment_gateway]) ? params[:payment_gateway] : hotel.settings.payment_gateway
  end

end
