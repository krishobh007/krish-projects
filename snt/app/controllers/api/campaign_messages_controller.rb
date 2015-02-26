class Api::CampaignMessagesController < ApplicationController

  before_filter :check_session

  def index
  	# current_user = User.find(336)
  	@users_notification_details = current_user.users_notification_details.messages.includes(:notification_detail)
  end

  def show
  	# current_user = User.find(336)
  	@message_id = params[:id]
  	@users_notification = current_user.users_notification_details.find(@message_id)
    @campaign_message = @users_notification.notification_detail
    @campaign = @campaign_message.notification
  end

  def destroy
  	# current_user = User.find(336)
  	notification = current_user.users_notification_details.find(params[:id]).delete
  end

  
end