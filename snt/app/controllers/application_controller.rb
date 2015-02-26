class ApplicationController < ActionController::Base
  include Userstamp
  include ActionView::Helpers::NumberHelper
  require 'i18n_extensions'
  protect_from_forgery
  respond_to :html, :json
  helper :all
  before_filter :set_current_request, :set_cache_buster, :strip_params, :set_locale
  # CICO-12682: setup_logger should be invoked after the method calls, so that the current_user and current_hotel checks will be done.
  after_filter :setup_logger
  around_filter :global_request_logging

  helper_method :current_hotel, :current_user
  HOTEL_SETTINGS_URI = '/api/hotel_settings.json'
  HOTEL_STATISTICS_URI = '/api/hotel_statistics.json'
  ROVER_HEADER_INFO_URI = '/api/rover_header_info.json'


  def load_business_date_info
    if response.content_type == 'application/json'
      response_body = JSON.parse(response.body) || Hash.new
        # Before logging in, current_hotel will be nil. 
      # In this case, the parameters are not relevant.
      if response_body.is_a?(Hash) && current_hotel
        response.body = response_body.merge!(
          is_eod_in_progress: current_hotel.is_eod_in_progress,
          is_eod_manual_started: current_hotel.is_eod_manual_started).to_json
      end
    end
  end

  def check_business_date
    do_check = (current_user && !current_user.admin?)
    # This check is not relevant for mobile apps, and non-logged in scenario
    # This check is to avoid 430 status from hotel_settings API which is the first API called , CICO-10232
    current_uri = request.env['PATH_INFO']
    if [HOTEL_SETTINGS_URI, HOTEL_STATISTICS_URI, ROVER_HEADER_INFO_URI].include?(current_uri)
      session[:business_date] = current_hotel.active_business_date
      return
    else
      if session[:business_date] && current_hotel && do_check
        if session[:business_date] != current_hotel.active_business_date
          session.delete(:business_date)
          session[:business_date] = current_hotel.active_business_date
          render json: { errors: ["The Business Date has changed"] }, status: 430
        end
      end
    end  
  end

  # If locale parameter passed, set it else if a selected hotel is present set the hotel language , otherwise set default English
  def set_locale
    if current_user && !current_user.admin?
      if params[:locale]
        I18n.locale = params[:locale]
      elsif current_hotel && current_hotel.language
        current_hotel.language.value.downcase
      else
        I18n.locale = :en
      end
    else
      I18n.locale = :en
    end
  end
  
  # Setup the logger attributes to include in all log messages
  def setup_logger
    Logging.mdc['user_info'] = "#{request.remote_ip} "
    Logging.mdc['user_info'] += "#{current_hotel.code} " if @current_hotel
    Logging.mdc['user_info'] += "#{current_user.login} " if @current_user
  end

  def set_cache_buster
    response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end

  def set_current_request
    Thread.current[:current_request] = request
  end

  def global_request_logging
    request_logger = Logger.new('log/request_log.log')

    request_logger.info " Should auto log out : #{UserSession.logout_on_timeout}"
    request_logger.info " Auto logout time : #{User.logged_in_timeout}"
    request_logger.info 'REQUEST INSPECTOR'
    request_logger.info "  [REQUEST_URI] #{request.headers['REQUEST_URI'].inspect}"
    request_logger.info "  [RAW_POST]: #{request.raw_post.inspect}"
    request_logger.info "  [PARAMS]: #{request.params.inspect}"
    request_logger.info "  [HTTP_AUTHORIZATION] #{request.headers['HTTP_AUTHORIZATION'].inspect}"
    request_logger.info "  [CONTENT_TYPE]: #{request.headers['CONTENT_TYPE'].inspect}"
    request_logger.info "  [HTTP_ACCEPT] #{request.headers['HTTP_ACCEPT'].inspect}"
    request_logger.info "  [HTTP_HOST] #{request.headers['HTTP_HOST'].inspect}"
    request_logger.info "  [HTTP_USER_AGENT] #{request.headers['HTTP_USER_AGENT'].inspect}"
    request_logger.info "  [HTTP_REFERER] #{request.headers['HTTP_REFERER'].inspect}"
    request_logger.info "  [HTTP_ACCEPT_ENCODING] #{request.headers['HTTP_ACCEPT_ENCODING'].inspect}"
    request_logger.info "  [HTTP_ACCEPT_LANGUAGE] #{request.headers['HTTP_ACCEPT_LANGUAGE'].inspect}"
    request_logger.info "  [HTTP_COOKIE] #{request.headers['HTTP_COOKIE'].inspect}"
    request_logger.info '----------------------------------------------------------------------------'
    begin
      yield
    ensure
      request_logger.info 'RESPONSE INSPECTOR'
      request_logger.info " Current user : #{current_user}"
      request_logger.info " Current user session: #{current_user_session}"
      request_logger.info "Response Status: #{response.status}"
      request_logger.info "Response Headers: #{response.headers.inspect}"
      request_logger.info "Response Content Type: #{response.content_type}"
      request_logger.info " Should auto log out : #{UserSession.logout_on_timeout}"
      request_logger.info " Auto logout time : #{User.logged_in_timeout}"
      request_logger.info '==========================================================================='
    end
  end

  # Get the current hotel (set from the session or user's default hotel if not set)
  def current_hotel
    if current_user && current_user.default_hotel
      session[:current_hotel_id] ||= current_user.default_hotel.id
    end
    @current_hotel ||= Hotel.find_by_id(session[:current_hotel_id])
  end

  # Set the current hotel. Example: self.current_hotel = hotel
  def current_hotel=(hotel)
    session[:current_hotel_id] = hotel.andand.id
    @current_hotel = hotel
  end

  # Checks if the current user is not established for XML/JSON requests. If not, attempts to validate consumer key and lookup access token to set the
  # current user.
  def check_session
    # If the current user is not defined
    # Here, we had a code to check if the request format is XML or JSON.
    # That is removed, to make sure that we provide 401 while rendering HAMLs, as per : CICO-9067
    if !current_user_session &&   !request.headers['Authorization'].present? && !params[:guest_web_token].present?
      # Check if consumer key and access token is provided
      if params[:consumer_key].present? && params[:access_token].present?

        # Validate that the consumer key is found and not expird
        if validate_consumer_key(params[:consumer_key])
          # Try to authenticate the user from the access token
          authenticate_access_token(params[:access_token])
        else
          render json: { status: 401, data: {}, errors: ['Consumer key is invalid'] }, success: false, status: :unauthorized
        end
      else
        access_denied
      end
    else
      if request.headers['Authorization'].present? || params[:guest_web_token].present?
        validate_guest_web_token
      else
        login_required
      end
    end
  end

  def  check_consumer_key
    if params[:consumer_key].present?
      if validate_consumer_key(params[:consumer_key])
        return
      else
        status, data, errors = [], 'Invalid consumer key/key expired', FAILURE
      end
    else
      status, data, errors = [], 'missing consumer key', FAILURE
    end
    render json: { status: status, data: data, errors: errors }
  end

  def store_location
    session[:return_to] = request.url
  end

  def access_denied
    respond_to do |accepts|
      accepts.html do
        store_location
        if request.xhr?
          render json: { status: 401, data: {}, errors: ['Session expired'] }, success: false, status: :unauthorized
        else
          redirect_to root_path
        end
      end
      accepts.xml do
        headers['Status']           = 'Unauthorized'
        headers['WWW-Authenticate'] = %(Basic realm="Web Password")
        render text: "Couldn't authenticate you", status: '401 Unauthorized'
      end
      accepts.js do
        store_location
        render json: { status: 401, data: {}, errors: ['Session expired'] }, success: false, status: :unauthorized
      end
      accepts.json do
        store_location
        render json: { status: 401, data: {}, errors: ['Session expired'] }, success: false, status: :unauthorized
      end
    end
    false
  end

  def validate_guest_web_token
    
    success = true
    errors = []
    token = request.headers['Authorization'].present? ?  request.headers['Authorization'] : params[:guest_web_token]
    session[:guest_web_token] = token
    if token.present?
      guest_web_token =  GuestWebToken.find_by_access_token(token)
      if !guest_web_token.present?
        success = false
        errors = ['Invalid Access Token']
      end
    else
      success = false
    end
    render json: { status: 401, data: {}, errors: errors } unless success
  end

  def validate_guest_web_reservation
    data, status, errors = {}, FAILURE, []

    if params[:guest_web_token].present? && (params[:reservation_id].present? || params[:confirm_no].present?)
      reservation = Reservation.find_by_id(params[:reservation_id])
      guest_web_token =  GuestWebToken.find_by_access_token(params[:guest_web_token])
      reservation.sync_booking_with_external_pms if reservation.hotel.is_third_party_pms_configured?
      if guest_web_token.reservation != reservation
        errors = [I18n.t(:invalid_reservation)]
      elsif guest_web_token.email_type == Setting.guest_web_email_types[:checkin]
        if reservation.status.to_s != Setting.reservation_input_status[:reserved]
          guest_web_token.update_attributes(is_active: false)
        end
      elsif guest_web_token.email_type ==  Setting.guest_web_email_types[:checkout]
        if reservation.status.to_s != Setting.reservation_input_status[:checked_in]
          guest_web_token.update_attributes(is_active: false)
        end
      end
    end

    render json: { status: status, data: data, errors: errors } if errors.present?
  end

  def  check_consumer_key
    if params[:consumer_key].present?
      if validate_consumer_key(params[:consumer_key])
        return
      else
        status, data, errors = [], 'Invalid consumer key/key expired', FAILURE
      end
    else
      status, data, errors = [], 'missing consumer key', FAILURE
    end
    render json: { status: status, data: data, errors: errors }
  end

  def store_location
    session[:return_to] = request.url
  end

  def strip_params
    StripParams.all!(params)
  end

  # Create URL for Guest Details - HK Search Screen - BEGIN

  def generate_guest_image_url(guest_detail_id, guest_detail_file_name, title)
    current_cdn_path = Paperclip::Attachment.default_options[:fog_host]
    guest_prefix = current_cdn_path+"/"+current_hotel.hotel_chain.code+"/Guests/guest_details/#{guest_detail_id}/avatars/thumb/#{guest_detail_file_name}"
    if guest_detail_file_name
      image_url =  guest_prefix
    else
      image_url = get_default_user_avatar_for_guest(title)
    end
    image_url
  end

  def get_default_user_avatar_for_guest(title)
    request = Thread.current[:current_request]
    avatar_url =  request.protocol + request.host_with_port + '/assets/avatar-trans.png'
    if title.present?
      if (title.downcase.include? ('Mr').downcase) && (!title.downcase.include? ('Mrs').downcase)
        avatar_url =  request.protocol + request.host_with_port + '/assets/avatar-male.png'
      elsif (title.downcase.include? ('Mrs').downcase) || (title.downcase.include? ('Ms').downcase)
        avatar_url =   request.protocol + request.host_with_port + '/assets/avatar-female.png'
      end
      avatar_url
    end
    avatar_url
  end

  # CICO-12682
  def  authenticate_api_user(params)
    @current_user = nil
    @current_hotel = params[:locationId].present? ? Hotel.find(params[:locationId]) : nil
    user = User.find_by_login(params[:apiUser])
    if user.present? && user.valid_password?(params[:apiPass])
      @current_user = user 
    else
      @current_user = nil
    end
    @current_user
  end

  # Create URL for Guest Details - HK Search Screen - END
  protected

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  private

  # Find consumer key and check that it is not expired
  def validate_consumer_key(consumer_key)
    valid = false

    if consumer_key
      expiry_date = ApiKey.find_by_cached_key(consumer_key)
      valid = expiry_date >= Time.now.utc if expiry_date
    end

    valid
  end

  # Lookup the access token in the session table
  def authenticate_access_token(access_token)
    pms_session = PmsSession.find_by_session_id(access_token)

    # If a session is found, set the current user
    if pms_session
      @current_user = pms_session.user
      logger.debug "#{@current_user.login} successfully authenticated via access token"
    else
      render json: { status: 401, data: {}, errors: ['Access token is invalid'] }, success: false, status: :unauthorized
    end
  end

  # To manage the logout to find the active session of the logged in user
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def login_required
    # By Passing AuthLogic auto logout here
    # Handling auto logout since authologic does not handle same user login sessions in 2 different browser
    
    session[:last_accessed] = Time.now unless session[:last_accessed]
    session_last_accessed = (Time.now - session[:last_accessed]).round
    
    if (current_user) && (current_hotel) && (session_last_accessed >= current_hotel.get_auto_logout_delay)
      current_user.record_user_activity(:ROVER, current_user.hotel.id, :LOGOUT, :SUCCESS, I18n.t(:session_auto_logout), request.remote_ip) if current_user && !current_user.admin? 
      current_user_session.destroy
      reset_session
      session.delete(:last_accessed)
      access_denied
    else
      session[:last_accessed] = Time.now
    end
    session[:business_date] = current_hotel.active_business_date if (current_user.present?) && (current_hotel) && !session[:business_date]
    access_denied unless current_user.present?
  end

  def require_no_user
    if current_user
      store_location
      access_denied
      return false
    end
  end

  ## JSON Parsing code, to support UI development team --begin###

  # Parse json file.
  def json2hash(file_name)
    @parsed_data = File.read(Rails.root + 'public/sample_json/' + file_name)
    JSON.parse(@parsed_data)
  end

  # Convert string keys to symbols, recursively.
  def convert_keys_to_symbols(data)
    dn = ''
    if data.class == Array
      dn = []
      data.each do |item|
        dn.push(convert_keys_to_symbols(item))
      end
    elsif data.class == Hash
      dn = {}
      data.keys.each do |key|
        dn[key.to_sym] = convert_keys_to_symbols(data[key])
      end
    else
      dn = data
    end

    dn
  end

  def json2symhash(file_name)
    data_hash = json2hash(file_name)
    convert_keys_to_symbols(data_hash)
  end

  ## JSON Parsing code, to support UI development team --end###

  rescue_from ActiveRecord::RecordNotFound, RuntimeError do |ex|
    logger.error("Application Error: #{ex}")
    logger.error ex.backtrace.join("\n")
    respond_error(ex.message)
  end

  # Globally rescue the external PMS error and return a custom 520 HTTP status code
  rescue_from PmsException::ExternalPmsError do |ex|
    respond_to do |format|
      format.html { render nothing: true, status: 520 }
      format.json { render json: ex.message, status: 520 }
    end
  end

  def respond_error(message = nil)
    render json: [message], status: :internal_server_error
  end

  def assert_hotel_admin
    render text: 'Access Denied' unless current_user.hotel_admin? || current_user.is_housekeeping_only
  end

  helper_method :payment_gateway
  def payment_gateway(hotel)
    hotel.payment_gateway
  end
  
  rescue_from SixPayment::ThreeCIntegra::ThreeCIntegraSettlementError, 
              SixPayment::ThreeCIntegra::ThreeCIntegraConfigurationError, 
              SixPayment::ThreeCIntegra::ThreeCIntegraInvalidParameters,
              SixPayment::Web2Pay::Web2PayClientError,
              MerchantLink::Lodging::InvalidParameterError,
              MerchantLink::Lodging::PaymentGateWayError do |ex|
    respond_to do |format|
      format.html { render nothing: true, status: 422 }
      format.json { render json: [ex.message], status: 422 }
    end
  end

  def set_time_zone
    @old_timezone = Time.zone
    Time.zone = 'UTC'
  end

  def revert_time_zone
    Time.zone = @old_timezone
  end

end
