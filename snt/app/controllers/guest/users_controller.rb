class Guest::UsersController < ApplicationController
  before_filter :check_session, :except=>[:update_password, :send_password_reset_email]

  def update_user_details
    user = current_user
    current_hotel = user.guest_detail.reservations.present? ?  user.guest_detail.reservations.first.hotel : nil
    # user_data = params.reject{|key,value| value.empty? }
    data = user.guest_detail.update_guest_profile(params, current_hotel)
    data[:data][:is_profile_completed] = user.guest_detail.get_profile_completed_status
    respond_to do |format|
      format.html
      format.json { render json: data }
    end
  end

  def get_user_details
    user = User.find(params[:id])

    unless params[:id]
      errors = 'Please provide user id'
    end

    if !errors
      results =  {
        job_title: user.guest_detail.job_title ? user.guest_detail.job_title.to_s : '',
        company: user.guest_detail.works_at ? user.guest_detail.works_at.to_s : '',
        city: user.guest_detail.addresses.first ? user.guest_detail.addresses.first.city.to_s : '',
        birthday: user.guest_detail.birthday ? user.guest_detail.birthday.strftime('%m-%d-%Y').to_s : '',
        profile_image_url: user.guest_detail.avatar.url(:thumb),
        is_email_verified: user.is_email_verified.to_s
      }

      render json: { data: results, status: SUCCESS, errors: [] }
    else
      logger.debug 'Get User Details API request invalid: ' + errors
      render json: { data: [], status: FAILURE, errors: [errors] }
    end
  end

  def activate
    status, errors = FAILURE, []
    user = User.find_by_perishable_token(params[:token])
    if user && user.activate
      status = SUCCESS
    else
      errors = ["Unable to activate user"]
    end
    render json: { data: {}, status: status, errors: errors }
  end

  def my_profile
    status, data, errors = FAILURE, {}, []
    if params[:id].present?
      user = User.find(params[:id])
      unless user.present?
        errors <<  I18n.t(:invalid_user)
      end
    else
      errors << I18n.t(:missing_attribute, attribute: 'User ID')
    end
    unless errors.present?
      guest_detail = user.guest_detail
      address = guest_detail.addresses.first if guest_detail

      data =  {
        'job_title' => guest_detail.job_title ? user.guest_detail.job_title.to_s : '',
        'avatar' => guest_detail.avatar ? user.guest_detail.avatar.url(:thumb).to_s : '',
        'company' => guest_detail.works_at ? user.guest_detail.works_at.to_s : '',
        'city' => address ? address.city.to_s : '',
        'birthday' => guest_detail.birthday ? guest_detail.birthday.strftime('%m-%d-%Y').to_s : '',
        'title' => guest_detail.title ? guest_detail.title : '',
        'first_name' => guest_detail.first_name ? guest_detail.first_name : '',
        'last_name' => guest_detail.last_name ? guest_detail.last_name : '',
        'email_address' => guest_detail.email ? guest_detail.email : '',
        'country' => address.present? ? address.country_id.to_s : '',
        'state' => (address.present? && address.state.present?) ? address.state : '',
        'phone' => guest_detail.phones && user.guest_detail.phones.home.pluck(:value).first ? user.guest_detail.phones.home.pluck(:value).first : '',
        'mobile' => guest_detail.phones.mobile && guest_detail.phones.mobile.pluck(:value).first ? guest_detail.phones.mobile.pluck(:value).first : '',
        'street' => address.present? ? address.street1.to_s : '',
        'works_at' => guest_detail.works_at ? guest_detail.works_at : '',
        'postal_code' => (address.present? && address.postal_code.present?) ? address.postal_code : ''
      }
      status = SUCCESS
    end
    render json: { data: data, status: status, errors: errors }
 end

  def link_reservation
    data, status, errors, result = {}, FAILURE, [], {}
    user = User.find(params[:user_id])
    reservation = Reservation.find(params[:reservation_id])
    unless errors.present?
      if reservation.guest_details.where('user_id IS NOT NULL').count > 0
        errors << I18n.t(:already_linked_reservation)
      else
        user.guest_detail.reservations << reservation
        status = SUCCESS
        data['message'] = I18n.t(:reservation_linked_to_user)
      end
    end
    render json: { data: data, status: status, errors: errors }
  end


  # *********** Method to send the email-id vefication email ***********#
  def send_verification_email
    data, status, errors = {}, FAILURE, []
    user = User.find(params[:id])
    email = user.guest_detail.andand.email
    email_status = UserNotifier.send_guest_email_verification(user).deliver
    status = SUCCESS if email_status
    errors = ["Unable to send email verification"] unless email_status
    logger.error "Guest verfication email was not sent to  #{email}" unless email_status
    render json: { data: data, status: status, errors: errors }
  end

  # *********** Method to send the password reset email ***********#
  def send_password_reset_email
    data, status, errors = {}, FAILURE, []
    user = User.find_by_login(params[:login])
    if user.present?
      email_status = UserNotifier.send_guest_password_reset_email(user).deliver
      errors = ["Unable to send password reset email"] unless email_status
    else
       errors = [I18n.t(:invalid_user)]
    end
    status = SUCCESS if errors.empty?
    render json: { data: data, status: status, errors: errors }
  end

 def update_password
    data, status, errors = {}, FAILURE, []
    if  params[:access_token].present?
      pms_session = PmsSession.find_by_session_id(params[:access_token])
      user = pms_session.user
    elsif params[:perishable_token].present?
      user = User.find_by_perishable_token(params[:perishable_token])
    end
    if user.present?
      errors = [I18n.t(:invalid_current_password)] if params[:current_password] && !user.valid_password?(params[:current_password])
      errors = [I18n.t(:invalid_password_length)] if params[:password].length < 8 && errors.empty?
      user.password = params[:password]
      user.password_confirmation = params[:confirm_password]
      if errors.empty? && user.save
        status = SUCCESS
        data[:message] = I18n.t(:completed_password_change)
      elsif errors.empty?
        errors = user.errors.full_messages
      end
    else
       errors = [I18n.t(:invalid_user)]
    end
    render json: { data: data, status: status, errors: errors }
  end

end
