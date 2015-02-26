class StaffHouseKeeping::SessionsController < ApplicationController
  layout 'staff_house_keeping'
  def new
    if current_user
      redirect_to staff_house_keeping_dashboard_url
    end
  end

  def create
    if current_user
      redirect_to staff_house_keeping_root_path

    elsif !params[:email].present?

      flash[:error] = I18n.t(:missing_email)
      render action: :new

    elsif !params[:password].present?

      flash[:error] = I18n.t(:missing_password)
      render action: :new

    else
      user = User.find_by_login(params[:email])
      @user_session = UserSession.new(login: params[:email], password: params[:password])

      if !user || !@user_session.save
        flash[:error]  = I18n.t(:invalid_login)
        render action: :new
      else
      # if current_user has been called before this, it will ne nil, so we have to make to reset it
        current_user = @user_session.record

        # sets auto logout delay for Rover - START
        UserSession.logout_on_timeout = true
        current_user.class.logged_in_timeout = current_hotel.get_auto_logout_delay
        # sets auto logout delay for Rover - END
        user.update_attribute(:last_login_at, Time.now)
        # update_tokens (gcm, apns)
        flash[:notice] = :thanks_youre_now_logged_in.l
        if user.hotel_staff? ||  user.hotel_admin?
          redirect_to staff_house_keeping_root_path
        else
        # if the user is not staff or admin, stay in the current login screen.
          flash[:notice] = :no_role_assigned
          render action: :new
        end

      end
    end
  end

  def destroy
    current_user_session.destroy
    reset_session
    redirect_to new_session_path
  end

  def logout
    if current_user_session
      current_user_session.destroy
    end
    reset_session

    respond_to do |format|
      format.html { redirect_to staff_house_keeping_root_path }
    end
  end

  def timeout
    # if Rails.env.development?
    #   logout = false
    # else
    #   logout = current_user_session.stale?
    # end
    logout = false
    logout = current_user_session.stale? if current_user_session
    respond_to do |format|
      format.json { render json: logout }
    end
  end
end
