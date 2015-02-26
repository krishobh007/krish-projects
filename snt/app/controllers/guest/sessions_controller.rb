class Guest::SessionsController < ApplicationController
  # Guest Normal Login Process
  def login
    @user_session = UserSession.new(login: params[:email], password: params[:password], remember_me: params[:remember_me])
    data = {}
    if params[:chain_code]
      hotel_chain = HotelChain.find_by_code(params[:chain_code])
      user = User.find_by_login_and_hotel_chain_id(params[:email], hotel_chain.id) if hotel_chain
    else
      user = User.find_by_login(params[:email])
    end

    if !user
      status, data, errors = FAILURE, {}, [I18n.t(:invalid_user)]
      message = I18n.t(:invalid_user)
      activity_status = Setting.user_activity[:failure]
      action_type = Setting.user_activity[:invalid_login]
    else
    # If user is guest and request has no chain code then clear the found user since the guest should always have chain associated
      if user.guest? && !params[:chain_code]
        status, data, errors = FAILURE, {}, [I18n.t(:invalid_hotel_chain)]
        message = I18n.t(:invalid_hotel_chain)
        activity_status = Setting.user_activity[:failure]
        action_type = Setting.user_activity[:invalid_login]
        user = nil
      end
    end

    if user
      if  user.guest?
        if @user_session.save
          pms_session = PmsSession.find_by_user_id(user.id)
          pms_session = PmsSession.create(session_id: SecureRandom.hex, user_id: user.id) unless pms_session
          current_user = pms_session.user # if current_user has been called before this, it will ne nil, so we have to make to reset it
          message = prepare_response_message(pms_session, user, hotel_chain)
          activity_status = Setting.user_activity[:success]
          action_type = Setting.user_activity[:login]
          status, data, errors = SUCCESS, message, []
        else
          status, data, errors = FAILURE, {}, [I18n.t(:invalid_user)]
          message = @user_session.errors.full_messages.to_sentence
          action_type = Setting.user_activity[:invalid_login]
          activity_status = Setting.user_activity[:failure]
        end
      else
        status, data, errors = FAILURE, {}, [I18n.t(:invalid_user)]
        activity_status = Setting.user_activity[:failure]
        action_type = Setting.user_activity[:invalid_login]
        message = I18n.t(:invalid_guest)
      end
    end
    if user && !user.admin?
      user.hotel_chain.hotels.each do | hotel |
        user.record_user_activity(:ZEST, hotel.id, action_type, activity_status, message, request.remote_ip)
      end
      user.reload
      UserNotifier.send_guest_email_verification(user).deliver unless user.is_email_verified
    end
    render json: { status: status, data: data, errors: errors }
  end

  # Guest User Sign Up
  # Find user with matching email and chain, update details. If user not present create.
  # TODO : Check in guest user to hotel
  def sign_up
    if params[:chain_code]
      hotel_chain = HotelChain.find_by_code(params[:chain_code])
      if hotel_chain
        user = hotel_chain.users.find_by_login(params[:email])
        if user.present?
          status, data, errors = SUCCESS, { user_already_exist: 'true' }, []
        else
          user_params = params.except(:chain_code, :consumer_key, :controller, :action, :format, :session)
          user = find_or_create_user(user, hotel_chain, user_params)
          if user.present?
            current_login_session = sign_in_user(user)
            UserNotifier.send_guest_email_verification(user).deliver unless user.is_email_verified
            message = prepare_response_message(current_login_session, user, hotel_chain)
            status, data, errors = SUCCESS, message, []
          else
            status, data, errors = FAILURE, {}, [I18n.t(:unable_to_save_user)]
          end
        end
      else
        status, data, errors = FAILURE, {}, [I18n.t(:invalid_hotel_chain)]
      end
    else
      # Only guest app has sign up. So Chain code should always be passed along with the request
      status, data, errors = FAILURE, {}, [I18n.t(:missing_hotel_chain)]
    end
    render json: { status: status, data: data, errors: errors }
  end

  # Guest Facebook Login
  # curl -X POST -H 'User-Agent: StayNTouchPMSApp/1.0' -H 'Content-Type: application/json; charset=utf-8' -H 'x-client-identifier: iOS' 'http://localhost:3000/facebook_login.json?consumer_key=dc1403aafd46ef67ab405144d5e8b423' -d '{"access_token":"CAAT8FB4DXPMBALVL35687hACREwaZAsRHbbnhbAx65hnLVvkMnZC6jNOcZAPvWfKUJ030Pulu3pBzXsDkg2AjcSYaZANpZAs6Tstl8nmQSCEbPOaALnmcLOAsOF2kI3M4DtJNJyrMXghZC5soT8DIZBbjMp8m7sLJlJp9ShFg6RjyQiH2XYWDDRLdMBDDttOeYzOo1hpa8ZADgZDZD1
  # Get access token from mobile client and authenticate
  def facebook_login
    if params[:chain_code]
      @hotel_chain = HotelChain.find_by_code(params[:chain_code])
      unless @hotel_chain
        status, data, errors = FAILURE, {}, I18n.t(:invalid_hotel_chain)
        fail errors
      end
    else
      status, data, errors = FAILURE, {}, I18n.t(:missing_hotel_chain)
      fail errors
    end
    # Use mobile client access token to authenticate
    # params[:access_token] = "CAADN8p111PEBAOzjWhke13HaD5fEMh92HTCofZB9GP4TkLAf1QjR2fZAwHyWucrGmWZBW8MVZAqPszfyUZCbWnTlH2soCV29bpWVrR6w9FwFZAOsIOwlyZCteVY0zoE5T5juQdsrrFMr2Oi88TTIguulZB7vNcoP5ZCm5VyrwPqK2lVGhsPTgVfi2woeydTmITY8ZD"
    begin
      if params[:access_token]
        # Get user information from facebook
        user_info = RestClient.get "https://graph.facebook.com/me?access_token=#{params[:access_token]}"
        user_info = JSON.parse(user_info)
        logger.info "********  Information from FaceBook : #{user_info.inspect}  *************"
        # Find user with email and chain code
        @pms_user = User.find_by_email_and_hotel_chain_id(user_info['email'], @hotel_chain.id)
        user = build_user_from_facebook_response(user_info)

        # If user present - update attributes else - insert
        @pms_user = find_or_create_user(@pms_user, @hotel_chain, user)
        unless @pms_user.errors.empty?
          status, data, errors = FAILURE, {}, @pms_user.errors.full_messages.to_sentence
          fail errors
        end
        @pms_user['image_url'] = @pms_user.guest_detail && @pms_user.guest_detail.avatar ? @pms_user.guest_detail.avatar.url : ''
        current_login_session = sign_in_user(@pms_user)
        message = prepare_response_message(current_login_session, @pms_user, @hotel_chain)
        status, data, errors = SUCCESS, message, ''
      else
        status, data, errors = FAILURE, {},  I18n.t(:missing_access_tocken)
        fail errors
      end
    rescue ActiveRecord::RecordInvalid => ex
      errors =  ex.message
      status = FAILURE
    end

    render json: { status: status, data: data, errors: [errors] }
  end

  # Linkedin Login for Mobile device
  def linkedin_login
    errors = []
    data = {}
    if params[:chain_code]
      hotel_chain = HotelChain.find_by_code(params[:chain_code])
      unless hotel_chain
        errors << I18n.t(:invalid_hotel_chain)
      end
    else
     errors << I18n.t(:missing_hotel_chain)
    end
    if params[:access_token]
      response = RestClient.get "https://api.linkedin.com/v1/people/~:(first-name,last-name,headline,email-address,date-of-birth,phone-numbers,location,picture-url,positions)?oauth2_access_token=#{params[:access_token]}&format=json"
      user_info =  JSON.parse(response)
      logger.info "************      Information from LinkedIn : #{user_info.inspect}     **************"
      pms_user = User.find_by_email_and_hotel_chain_id(user_info['emailAddress'], hotel_chain.id)
      user = build_user_from_linkedIn_response(user_info)
      pms_user = find_or_create_user(pms_user, hotel_chain, user)
      unless pms_user.errors.empty?
        errors <<  pms_user.errors.full_messages.to_sentence
      end
      current_login_session = sign_in_user(pms_user)
      message = prepare_response_message(current_login_session, pms_user, hotel_chain)
      status, data, errors = SUCCESS, message, []
    else
      errors << I18n.t(:invalid_access_token)
    end

    render json: { status: errors.empty? ?  SUCCESS : FAILURE, data: data, errors: errors }
  end

  # Normal Logout for Mobile Device
  def logout
    respond_to do |format|
      if current_user_session
        current_user.hotel_chain.hotels.each do | hotel |
          current_user.record_user_activity(:ZEST, hotel.id, Setting.user_activity[:logout], :SUCCESS, I18n.t(:logout_success), request.remote_ip)
        end
        current_user_session.destroy
      end
      reset_session
      pms_session = PmsSession.find_by_session_id(params[:access_token])
      pms_session.destroy if pms_session
      format.json { render json: { status: SUCCESS, data: {}, errors: [''] } }
    end
  end

  # Get the current hotel id for this user
  def get_current_hotel
    current_hotel_id = current_hotel ? current_hotel.id : nil

    respond_to do |format|
      format.json { render json: { current_hotel_id: current_hotel_id } }
    end
  end

  # Set the current hotel id for this user
  def set_current_hotel
    status = true
    messages = []

    hotel_code = params[:hotel_code]
    hotel = Hotel.find_by_code(hotel_code)

    if hotel
      self.current_hotel = hotel
    else
      messages <<  I18n.t(:invalid_hotel_code, hotel_code: params[:hotel_code])
      status = false
    end

    respond_to do |format|
      format.json { render json: { status: status, messages: messages } }
    end
  end

  private
  
  def build_user_from_facebook_response(user_info)
    user_hash = {}
    User.new.attributes.keys.each do |attribute|
      if user_info.key?(attribute) && attribute != 'id'
        user_hash[attribute.to_sym] = user_info[attribute]
      end
    end
    GuestDetail.new.attributes.keys.each do |attribute|
      if user_info.key?(attribute) && attribute != 'id'
        user_hash[attribute.to_sym] = user_info[attribute]
      end
    end
    user_hash[:login] = user_hash['email']
    user_hash[:password] = user_hash[:password_confirmation] = 'testpswd123'
    user_hash[:works_at] = user_info['work'][0]['employer']['name'] if user_info.key?('work')
    avatar = RestClient.get "http://graph.facebook.com/#{user_info['id']}/?fields=picture&type=large"
    avatar_json = JSON.parse(avatar)
    user_hash[:avatar_url] = avatar_json['picture']['data']['url']
    user_hash[:company] = user_info['work'][0]['employer']['name'] if user_info.key?('work')
    user_hash
  end

  def build_user_from_linkedIn_response(user_info)
    user_hash = {}
    user_hash[:first_name] = user_info['firstName']
    user_hash[:last_name] = user_info['lastName']
    user_hash[:password] = user_hash[:password_confirmation] = 'testpswd123'
    user_hash[:email] = user_hash[:login] = user_info['emailAddress']
    user_hash[:avatar_url] = user_info['pictureUrl']
    user_hash[:nationality] = Country.find_by_code(user_info['location']['country']['code']).name
    user_hash[:birthday] = "#{user_info['dateOfBirth']['month']}/#{user_info['dateOfBirth']['day']}/#{user_info['dateOfBirth']['year']}" if user_info['dateOfBirth']
    user_hash[:job_title] = user_info['headline']
    user_hash[:phone] = user_info['phoneNumbers']['values'][0]['phoneNumber'] if  user_info['phoneNumbers'] && user_info['phoneNumbers']['values'] && user_info['phoneNumbers']['values'][0]
    if !user_info['positions'].empty? && user_info['positions']['values'].present? && !user_info['positions']['values'].empty?
      user_hash[:company] = user_hash[:works_at] = user_info['positions']['values'].first['company']['name']
    end
    user_hash
  end

  def sign_in_user(user)
    pms_session = PmsSession.create(session_id: SecureRandom.hex, user_id: user.id)
    @user_session = UserSession.new(login: params[:email], password: params[:password], remember_me: params[:remember_me])
    current_user = @user_session.record
    pms_session
  end

  def find_or_create_user(user, hotel_chain, params)
    logger.debug "***     Creating user details     ***"
    user_params = params.slice(:email, :password, :password_confirmation, :login)
    unless user
      user = hotel_chain.users.new(user_params)
      user.login = user.email
      user.roles << Role.guest
      unless user.save
        logger.error '***************  Failed to save new user details   ****************'
        logger.error "************    #{user.errors.full_messages}    ************"
      end
    else
      user.update_attributes(user_params)
    end
    guest_detail = find_or_create_guest_detail(user, hotel_chain, params) if user.present? && user.valid? && user.guest_detail.nil?
    if guest_detail.present?
      user.guest_detail = guest_detail
      user.activate
    elsif user.present?
      logger.error '***************  Unable to attach guest detail to user   ****************'
      #Dont save user if the guest detail was not able to attach
      user.delete
      user = nil
    end
    user
  end

  # Find a matching guest detail record by the primary email. If not found, create one.
  def find_or_create_guest_detail(user, hotel_chain, params)
    guest_detail = GuestDetail.includes(:emails).where('additional_contacts.value = ? AND additional_contacts.is_primary = true AND hotel_chain_id = ? AND user_id IS NULL', user.email, hotel_chain.id).first
    params[:user_id] = user.id
    params[:hotel_chain_id] = hotel_chain.id
    guest_params = params.except(:password_confirmation, :password, :login, :email, :avatar_url, :phone)
    guest_params[:birthday] = Date.strptime(guest_params[:birthday], '%m/%d/%Y') if guest_params[:birthday].present?

    if guest_detail
      guest_detail.attributes = guest_params
    else
      guest_detail = GuestDetail.new(guest_params)
    end
    if params[:avatar_url]
      guest_detail.avatar_from_url = params[:avatar_url]
    end
    if guest_detail.save
      contacts = guest_detail.contacts.where(contact_type_id: Ref::ContactType[:PHONE].id).where(value: params[:phone]) unless guest_detail.contacts.empty?
      if contacts.nil? && params[:phone]
        guest_detail.contacts.create(contact_type_id: Ref::ContactType[:PHONE].id, value: params[:phone], label: :HOME, is_primary: true)
      end
      contacts = guest_detail.contacts.where(contact_type_id: Ref::ContactType[:EMAIL].id).where(value: params[:email]) unless guest_detail.contacts.empty?
      if contacts.nil? && params[:email]
        guest_detail.contacts.create(contact_type_id: Ref::ContactType[:EMAIL].id, value: params[:email], label: :HOME, is_primary: true)
      end
    else
      logger.error "************   failed to create guest detail with following reason   ************"
      logger.error "************    #{guest_detail.errors.full_messages}     ************"
      guest_detail = nil
    end
    guest_detail
  end

  def prepare_response_message(session, user, chain)
    user_data = {}
   # user['is_profile_completed'] = user.guest_detail ? user.guest_detail.get_profile_completed_status : 'false'
    user_data['first_name'] = user.guest_detail && user.guest_detail.first_name ? user.guest_detail.first_name : ''
    user_data['last_name'] = user.guest_detail && user.guest_detail.last_name ? user.guest_detail.last_name : ''
    user_data['is_profile_completed'] = user.guest_detail ? user.guest_detail.get_profile_completed_status : 'false'
    user_data['image_url'] = user.guest_detail && user.guest_detail.avatar ? user.guest_detail.avatar.url : ''
    user_data['is_email_verified'] = user.is_email_verified.to_s
    #user['works_at'] =  user.andand.guest_detail.andand.works_at.to_s
    #user['birthday'] =  user.andand.guest_detail.andand.birthday.to_s
    user_data['gender'] =  user.andand.guest_detail.andand.gender.to_s
    user_data['user_id'] = user.id.to_s
    user_data['email'] = user.email.to_s
    #user['home_phone'] =  user.andand.guest_detail.andand.phones && !user.andand.guest_detail.andand.phones.empty? ? user.andand.guest_detail.andand.phones.home.pluck(:value).first.to_s : ''
    #user['mobile_phone'] =  user.andand.guest_detail.andand.phones && !user.andand.guest_detail.andand.phones.empty? ? user.andand.guest_detail.andand.phones.mobile.first.to_s : ''
    #user['postal_code'] =  user.andand.guest_detail.andand.addresses && !user.andand.guest_detail.andand.addresses.empty? ? user.andand.guest_detail.andand.addresses.primary.first.andand.postal_code.to_s : ''
    #user['street'] = user.andand.guest_detail.andand.addresses && !user.andand.guest_detail.andand.addresses.empty? ? user.andand.guest_detail.andand.addresses.primary.first.andand.street1.to_s : ''
    #user['image_url'] = user.guest_detail && user.guest_detail.avatar ? user.guest_detail.avatar.url : ''
    #user['country'] = user.guest_detail ? user.guest_detail.nationality : ''
    message = { access_token: session.session_id, user: user_data}
    message = message.merge(hotel_chain_name: chain.name) if chain
    message
  end
end
