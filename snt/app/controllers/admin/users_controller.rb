class Admin::UsersController < ApplicationController
  layout 'admin'

  before_filter :check_session

  def index
    if current_user.admin?
      users = current_hotel.users.includes(:roles).where("roles.name = 'hotel_admin'")
    else
      users = current_hotel.users.includes(:roles).where("roles.name not in ('guest', 'admin') OR users_roles.user_id is NULL")
    end

    data = {
      'users' => users.map { |user| map_user_details(user) },
      'departments' => Department.order('name').map { |department| { 'value' => department.id.to_s, 'name' => department.name } }
    }

    respond_to do |format|
      format.html { render partial: 'users_list', locals: { data: data, errors: [] } }
      format.json { render json: data }
    end
  end

  def map_user_details(user)
    staff = user.staff_detail
    full_name = staff.first_name if staff.first_name
    full_name += ' ' + staff.last_name if staff.last_name
    user_details = {
      'id' => user.id.to_s,
      'full_name' => full_name,
      'email' => user.email,
      'department' => user.department ? user.department.name : '',
      'last_login_date' =>  user.last_login_at ?  user.last_login_at.in_time_zone(current_hotel.tz_info).strftime('%Y-%m-%d') : '',
      'last_login_time' =>  user.last_login_at ?  user.last_login_at.in_time_zone(current_hotel.tz_info).strftime('%I:%M %p') : '',
      'is_active' => user.active? ? 'true' : 'false',
      'is_locked' => user.failed_login_count >= Setting.defaults[:consecutive_failed_logins_limit] ? 'true' : 'false',
      'can_delete' => (user != current_user).to_s,
      'default_dashboard_id' => user.default_dashboard_id
    }
    user_details
  end

  def new
    data = {
      'departments' => current_hotel.departments.map { |department| { 'value' => department.id.to_s, 'name' => department.name } },
      'roles' => Role.where("name IN ('hotel_admin','hotel_staff')").order('name').map { |role| { 'value' => role.id.to_s, 'name' => role.name.titleize } }
    }
    respond_to do |format|
      format.html { render partial: 'add_user', locals: { data: data,  errors: [] } }
      format.json { render json: data }
    end
  end

  def create
    errors = []

    # If current user is SNT admin, only add hotel admin role. Otherwise use roles from request params.
    if current_user.admin?
      roles = [Role.hotel_admin]
    elsif params[:user_roles].present?
      roles = Role.find params[:user_roles]
    end

    if !roles
      errors << I18n.t(:no_roles_assigned)
    else
      user_attributes = {
        department_id: params[:user_department],
        phone: params[:phone],
        email: params[:email],
        email_confirmation: params[:confirm_email],
        password: params[:password],
        password_confirmation: params[:confirm_password],
        last_password_update_at: Time.now.utc,
        staff_detail_attributes: {
          first_name: params[:first_name],
          last_name: params[:last_name],
          job_title: params[:job_title]
        }
      }

      user = User.new(user_attributes)

      user.roles = roles
      user.hotel = current_hotel
      user.hotel_chain_id = current_hotel.hotel_chain_id
      user.default_hotel_id = current_hotel.id
      if current_user.admin?
        user.default_dashboard_id = Ref::Dashboard[:MANAGER].id
      else
        if params[:default_dashboard_id]
          user.default_dashboard_id = params[:default_dashboard_id]
        elsif user.roles.first.hotels_roles.present?
          user.default_dashboard_id = user.roles.first.andand.default_dashboard(current_hotel).andand.id
        end
      end

      current_hotel.users << user

      if params[:user_photo].present?
        base64_data = get_base64_from_post_image(params[:user_photo])
        user.staff_detail.set_avatar_from_base64(base64_data)
      end

      if user.save
        UserNotifier.invitation(user, current_hotel).deliver
      else
        errors += user.errors.full_messages
      end
    end
    data = errors.empty? ? {user_id: user.id} : {}
    render json: { status: errors.empty? ? SUCCESS : FAILURE, data: data, errors: errors }
  end

  def find_existing
    respond_to do |format|
      format.html { render partial: 'find_existing' }
      format.json { render json: {} }
    end
  end

  def link_existing
    errors = []

    email = params[:email]

    if !email.present?
      errors << I18n.t(:missing_email)
    else
      # Find user by the email address in the same chain
      user = User.where(email: email, hotel_chain_id: current_hotel.hotel_chain_id).first

      if !user
        errors << I18n.t(:user_not_found)
      elsif current_user.admin? && !user.hotel_admin? # If current user is SNT admin, only allow them to link hotel admins
        errors << I18n.t(:user_not_hotel_admin)
      elsif current_hotel.users.include?(user)
        errors << I18n.t(:user_already_linked)
      else
        # Link user to current hotel
        current_hotel.users << user
        current_hotel.save
      end
    end

    render json: { status: errors.empty? ? SUCCESS : FAILURE, data: {}, errors: errors }
  end

  def edit
    errors = []

    user = User.find(params[:id])
    data = {
      'user_id' => params[:id].to_s,
      'first_name' => user.staff_detail.first_name,
      'last_name' => user.staff_detail.last_name,
      'phone' => user.phone,
      'email' => user.email,
      'default_dashboard_id' => user.default_dashboard_id,
      'is_activated' => user.andand.activated_at && !user.andand.activation_code ? 'true' : 'false',
      'user_department' => user.department_id.to_s,
      'user_roles' => user.roles.pluck(:id).map(&:to_s),
      'user_photo' => user.staff_detail ? user.staff_detail.avatar.url : '',
      'departments' => current_hotel.departments.map { |department| { 'value' => department.id.to_s, 'name' => department.name } },
      'roles' =>  Role.where("name IN ('hotel_admin','hotel_staff')").order('name').map { |role| { 'value' => role.id.to_s, 'name' => role.name.titleize } },
      'job_title' => user.staff_detail ? user.staff_detail.job_title : ''
      
    }

    respond_to do |format|
      format.html { render partial: 'edit_user', locals: { data: data,  errors: errors } }
      format.json { render json: data }
    end
  end

  def update
    errors = []

    user = User.find(params[:id])
    
    # If current user is SNT admin, only add hotel admin role. Otherwise use roles from request params.
    if current_user.admin?
      roles = [Role.hotel_admin]
    elsif params[:user_roles].present?
      roles = Role.find params[:user_roles]
    end

    user.roles.destroy if user.roles.present?
    user.roles = roles if roles

    user_attributes = {
      phone: params[:phone],
      department_id: params[:user_department],
      staff_detail_attributes: {
        id: user.staff_detail.id,
        first_name: params[:first_name],
        last_name: params[:last_name],
        job_title: params[:job_title]
      }
    }

    user_attributes[:email] = params[:email] if params[:email].present?
    user_attributes[:email_confirmation] = params[:confirm_email]  if params[:confirm_email].present?
    user_attributes[:password] = params[:password] if params[:password].present?
    user_attributes[:password_confirmation] = params[:confirm_password] if params[:confirm_password].present?
    user_attributes[:default_dashboard_id] = params[:default_dashboard_id] if params[:default_dashboard_id]
    user_attributes[:staff_detail_attributes][:avatar]  = params[:user_photo] if params[:user_photo].present?
    
    if params[:user_photo].present?
      base64_data = get_base64_from_post_image(params[:user_photo])
      user.staff_detail.set_avatar_from_base64(base64_data)
    end

    user.attributes = user_attributes

    # Removed the user roles assignment since snt-admins are no longer able to assign roles.
    if user.save
      # If email or password was changed, deactivate the user and send notification
      if (user.email_changed? || params[:password].present?) && current_user != user
        user.deactivate
        UserNotifier.invitation(user, current_hotel).deliver
      end
    else
      errors += user.errors.full_messages
    end

    render json: { status: errors.empty? ? SUCCESS : FAILURE, data: {}, errors: errors }
  end

  def destroy
    user = User.find(params[:id])
    user.destroy

    render json: { status: SUCCESS, data: {}, errors: [] }
  end

  def toggle_activation
    errors = []

    action = params[:activity]
    user = User.find(params[:id])
    if user.roles.present?
      if action == 'activate'
        user.activate(current_hotel)
      else
        user.deactivate
      end
    else
      errors << I18n.t(:no_roles_assigned)
    end


    if errors.empty?
      response = { 'status' => SUCCESS, 'data' => {}, 'errors' => [] }
    else
      response = { 'status' => FAILURE, 'data' => {}, 'errors' => errors }
    end
    render json: response
  end

  def resend_activation
    if params[:email]
      @user = User.find_by_email(params[:email])
    else
      @user = User.find(params[:id])
    end
    respond_to do |format|
      if @user && @user.roles.present?
        flash[:notice] = :activation_email_resent_message.l
        UserNotifier.invitation(@user, current_hotel).deliver
        format.json { render json: { status: 200, message: :activation_email_resent_message.l } }
      else
        flash[:notice] = :activation_email_not_sent_message.l
        message = I18n.t(:no_roles_assigned) if @user && !@user.roles.present?
        format.json { render json: { status: 400, message: :activation_email_not_sent_message.l, errors: [message] || ['User not found'] } }
      end
    end
  end

  def send_invitation
    if params[:email]
      @user = User.find_by_email_and_hotel_chain_id(params[:email], Hotel.find(params[:hotel_id]).hotel_chain_id)
    else
      @user = User.find(params[:id])
    end
    respond_to do |format|
      if @user && @user.roles.present?
        flash[:notice] = :invitation_email_resent_message.l
        # Re-invitation for unlocking an user
        if params[:password] && params[:is_trying_to_unlock]
          @user.password = params[:password]
          @user.password_confirmation = params[:password]
          @user.last_password_update_at = DateTime.new(1975,12,12)
          @user.failed_login_count = 0
          @user.save!
          UserNotifier.invitation(@user, current_hotel, params[:password]).deliver
          format.json { render json: { status: SUCCESS, data: {} , errors: [] } }
          # invitation for activating an user
        else
          UserNotifier.invitation(@user, current_hotel).deliver
          format.json { render json: { status: SUCCESS, data: {} , errors: [] } }
        end
      else
        flash[:notice] = :invitation_email_not_sent_message.l
        message = I18n.t(:no_roles_assigned) if @user && !@user.roles.present?
        format.json { render json: { status: FAILURE, data: {}, errors: [message] || ['User not found'] } }
      end
    end
  rescue ActiveRecord::RecordInvalid => ex
    render(json: [ex.message], status: :unprocessable_entity)
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
      messages << "Could not find hotel for code: #{hotel_code}"
      status = false
    end

    respond_to do |format|
      format.json { render json: { status: status, messages: messages } }
    end
  end

  # get user name and email
  def get_curent_user_name_and_email
    user = current_user
    name = current_user.staff_detail.first_name + ' ' + current_user.staff_detail.last_name
    user_name_and_email_hash = {}
    if user
      user_name_and_email_hash[:name] = name
      user_name_and_email_hash[:email] = current_user.email
      respond_to do |format|
      format.html { render partial: 'modals/updateAccountSettings', locals: { staff_settings_hash: user_name_and_email_hash } }
      format.json { render json: { status: SUCCESS, data: user_name_and_email_hash } }
      end
    end
  end

  # Change User Password
  def change_password
    user = current_user
    # Setting both password and password_confirmation for validation purpose only(there is no database field)
    if !params[:new_password].blank?
      user.password = user.password_confirmation = params[:new_password]
      if user.save
        render json: { status: SUCCESS, errors: [] }
      else
        render json: { status: FAILURE, errors: user.errors.full_messages }
      end
    else
      render json: { status: FAILURE, errors: ['Empty password'] }
    end
  end

  private

  def load_data(user)
    @roles = []
    @roles = @roles.append(Role.front_desk_staff).append(Role.front_desk_management)
    if admin?
      @roles = @roles.append(Role.hotel_admin)
    end
    # @avatar     = (user.avatar || user.build_avatar)
    # TODO : avatar
    # @avatar.user  = user if @avatar
    @hotels = Hotel.order('name')
  end

  def get_base64_from_post_image(raw_post_image)
    data = raw_post_image.split('base64,')
    data[1]
  end
end
