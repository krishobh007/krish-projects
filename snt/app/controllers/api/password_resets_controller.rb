class Api::PasswordResetsController < ApplicationController
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, only: [:update, :validate_token]

  def update
    data, errors,redirect_url   =  {}, [], ""
    if !@user
       errors = [ :activation_period_expired.l ]
    else
      @user.password_presence_validation = true
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
      @user.current_password = params[:current_password] || ""
      @user.last_password_update_at = Time.now.utc
      if @user.save
        
        if @user.first_login? && !@user.active?
          @user.activate(@user.default_hotel)
        end
        @user_session =  UserSession.create(@user) if(@user.present?)
        # errors = [:invalid_login.l] unless @user_session.save
        if @user_session
          current_user = @user_session.record 
          current_user.class.logged_in_timeout = current_user.get_auto_logout_delay
          @user.update_attribute(:last_login_at, Time.now)
          UserSession.logout_on_timeout = true
          redirect_url = @user.admin? ? admin_root_path : staff_root_path
        else
          errors += @user_session.errors.full_messages
        end
      else
      errors += @user.errors.full_messages
      end

    end
    resultant_response =  {status: errors.empty? ? SUCCESS : FAILURE, data: {redirect_url: redirect_url}, errors: [errors.first]}

    render json: resultant_response
  end

  def validate_token
    data, errors,redirect_url   =  {}, [], ""
    @user = User.find_using_perishable_token(params[:token]) if params[:token]
    unless @user
      errors = [ :activation_period_expired.l ]
    end
    render json: {status: errors.empty? ? SUCCESS : FAILURE, errors: errors}
  end

  def activate_user
    @user = User.find_using_perishable_token(params[:token]) if params[:token]
    unless @user
      session[:activation_period_expired] = t(:activation_period_expired)
      redirect_to :controller => '/login', :action => 'new'
    else
      # setting last_password_update_at in far past to expire password
      @user.last_password_update_at = DateTime.new(1975,12,12)
      @user.activated_at = Time.now.utc
      @user.activation_code = nil
      @user.save
      redirect_to "/#/reset/#{params[:token]}"
    end
  end

  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id]) if params[:id]
    unless @user
      session[:activation_period_expired] = :activation_period_expired.l
      #redirect_to admin_root_path
    end

  end
end
