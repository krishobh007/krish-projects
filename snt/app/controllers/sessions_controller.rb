class SessionsController < ApplicationController
  require 'uri'
  layout false
  def new
    received_base_url = root_url
    uri = URI.parse(received_base_url)
    received_mapping_url = "#{uri.scheme}://#{uri.host}/"
    mapping_url = UrlMapping.where('url = ?', received_mapping_url).first
    if session[:activation_period_expired]
      flash[:error] = session[:activation_period_expired]
      session.delete(:activation_period_expired)
    end
    if current_user
      if current_user.admin?
        redirect_to admin_root_path
      elsif current_user.hotel_staff? || current_user.hotel_admin?
        staff_redirect_path = current_user.is_housekeeping_only ? staff_house_keeping_dashboard_url : staff_root_path
        redirect_to staff_redirect_path
      end
      else
        if mapping_url.present?
          if mapping_url.hotel_chain.present?
            session[:hotel_chain_id] = mapping_url.hotel_chain.id
          end
        end
    end
  end

 # #TODO : Check in guest user to hotel
  def create
  # Defect fix - 5873
  if current_user
    if current_user.admin?
      redirect_to admin_root_path
    elsif current_user.hotel_staff? || current_user.hotel_admin?
      staff_redirect_path = current_user.is_housekeeping_only ? staff_house_keeping_dashboard_url : staff_root_path
      redirect_to staff_redirect_path
    end
   # Defect fix - 5873
   elsif !params[:email].present?
      flash[:error] = I18n.t(:missing_email)
      render action: :new
   elsif !params[:password].present?
      flash[:error] = I18n.t(:missing_password)
      render action: :new
   else
     is_subdomain = true
     is_subdomain = Pms::Application.config.should_enforce_domain_restriction
     if is_subdomain
       received_base_url = root_url
       uri = URI.parse(received_base_url)
       received_mapping_url = "#{uri.scheme}://#{uri.host}/"
       mapping_url = UrlMapping.where('url = ?', received_mapping_url).first
       if mapping_url
         user = User.find_by_login(params[:email])
         if mapping_url.hotel_chain_id
                 # chain based login
           user = User.find_by_email_and_hotel_chain_id(params[:email], mapping_url.hotel_chain_id)
         else
           user = user.admin? ? user :  nil
         end
       end# mapping_url end
     else
       user = User.find_by_login(params[:email])
     end
     @user_session = UserSession.new(login: params[:email], password: params[:password])
# Show change password page if first login, user is an admin, and password is default
     if user && user.admin? && user.first_login?  && params[:password] == Setting.default_admin_password
      # resetting perishable token to hack authlogic perishable token expire after 10 minutes
      # so that SNT Admin password can be reset even after 10 minutes of database reset migration
      user.reset_perishable_token!
      redirect_to admin_password_reset_path(user.perishable_token) # password_reset_path(user.id)
     else
       if !user || !@user_session.save
         flash[:error] = I18n.t(:invalid_login)
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
         if current_user.admin?
           redirect_to admin_root_path
         elsif user.hotel_staff? ||  user.hotel_admin?
           redirect_to staff_root_path
         else
         # if the user is not staff or admin, stay in the current login screen.
           flash[:notice] = :no_role_assigned
           render action: :new
         end
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
      current_user.record_user_activity(:ROVER, current_user.hotel.id, Setting.user_activity[:logout], :SUCCESS, I18n.t(:logout_success), request.remote_ip) if current_user && !current_user.admin?
      current_user_session.destroy
    end
    reset_session

    respond_to do |format|
      format.html { redirect_to :root }
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
