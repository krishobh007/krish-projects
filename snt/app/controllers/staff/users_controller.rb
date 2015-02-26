class Staff::UsersController < ApplicationController
  before_filter :check_session

  def activate
    redirect_to signup_path && return if params[:id].blank?
    user = User.find_by_activation_code(params[:id])
    if user && user.activate
      self.current_user = user
      user.track_activity(:joined_the_site)
      flash[:notice] = :thanks_for_activating_your_account.l
      redirect_to root_path(user) && return
    end

    flash[:error] = :account_activation_error.l_with_args(email: Setting.support_email)
    redirect_to signup_path
  end
end
