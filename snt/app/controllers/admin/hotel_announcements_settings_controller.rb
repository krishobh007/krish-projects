class Admin::HotelAnnouncementsSettingsController < ApplicationController
  before_filter :check_session

  def index
    status, data, errors = SUCCESS, {}, []
    data = ViewMappings::HotelAnnouncementsSettingsMapping.hotel_announcement_settings(current_hotel.settings)
    respond_to do |format|
      format.html { render partial: 'hotel_announcement', locals: { data: data,  errors: [] } }
      format.json { render json: { status: status,  data: data, errors: errors } }
    end
  end

  def save
    status, data, errors = FAILURE, {}, []
    # UI has blocked the maximum limit of guest_zest_checkout_complete_message as 200, ensuring it in backend too.
    if params[:guest_zest_checkout_complete_message].present? && params[:guest_zest_checkout_complete_message].length > 200
      errors << I18n.t(:message_exceeded_limit)
    else
      current_hotel.settings.guest_zest_welcome_message = params[:guest_zest_welcome_message]
      current_hotel.settings.guest_zest_checkout_complete_message = params[:guest_zest_checkout_complete_message]
      current_hotel.settings.key_delivery_email_message = params[:key_delivery_email_message]
      status = SUCCESS
    end
    render json: { status: status,  data: data, errors: errors }
  end
end
