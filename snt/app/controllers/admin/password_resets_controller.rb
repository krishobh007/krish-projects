class Admin::PasswordResetsController < ApplicationController
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, only: [:admin_edit, :admin_update]

  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      if @user.hotel || @user.roles.include?(Role.admin)
        @user.deliver_password_reset_instructions!
        if @user.role != Role[:member]
          flash[:notice] = :"You will receive an email with instructions about how to reset your password in a few minutes"
          redirect_to login_path
        else
          flash[:notice] = :"You will receive an email with instructions about how to reset your password in a few minutes"
          render action: :new
        end
      else
        flash[:error] = :"You dont have any reservation record or you are not a staff of any hotel, please contact your system administrator"
        render action: :new
      end
      else
        flash[:error] = :"Your email does not exist in our database, please contact your system administrator"
        render action: :new
    end
  end

  def edit
  end

  def update
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    @user.last_password_update_at = Time.now.utc
    if @user.save
      if @user.role != Role[:member]
        flash[:notice] = :your_changes_were_saved.l
        @user_session = UserSession.new(login:@user.email, password: params[:password])
        @user_session.save
        current_user = @user_session.record
        redirect_to(hotels_path)
      else
        flash[:notice] = :your_changes_were_saved.l
        render action: :new
      end
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render action: :edit
    end
  end

  def admin_edit
    @path = admin_password_update_path
  end

  def admin_update
    if @user
      @user.password_presence_validation = true
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
      @user.last_password_update_at = Time.now.utc
    end
    respond_to do |format|
      if @user.save
        if @user.first_login? && !@user.active?
          @user.activate(@user.default_hotel)
        end
        @user_session = UserSession.new(login:@user.email, password: params[:password])
        @user_session.save
        current_user = @user_session.record
        staff_redirect_path = @user.is_housekeeping_only ? staff_house_keeping_dashboard_url : staff_root_path
        redirect_path = @user.admin? ? admin_root_path : staff_redirect_path
        flash[:notice] = :thanks_youre_now_logged_in.l
        format.html { redirect_to redirect_path }
        format.json { render json: { status: 200, data: { access_token: pms_session.session_id, user: @user }, errors: '' } }
      else
        flash[:error] = @user.errors.full_messages.to_sentence
        format.html { render 'admin/password_resets/admin_edit' }
        format.json { render json: { status: 502, data: {}, errors: @user.errors.full_messages.to_sentence } }
      end
    end
  end

  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      session[:activation_period_expired] = :activation_period_expired.l
      redirect_to admin_root_path
    end
  end
end
