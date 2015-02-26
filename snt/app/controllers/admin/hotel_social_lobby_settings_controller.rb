class Admin::HotelSocialLobbySettingsController < ApplicationController
  before_filter :check_session

  def index
    status, data, errors = SUCCESS, {}, []
    data = ViewMappings::HotelSocialLobbySettingsMapping.hotel_social_lobby_settings(current_hotel.settings)
    respond_to do |format|
      format.html { render partial: 'social_lobby', locals: { data: data,  errors: [] } }
      format.json { render json: { status: status,  data: data, errors: errors } }
    end
  end

  def save
    status, data, errors = SUCCESS, {}, []
    current_hotel.settings.is_social_lobby_on = params[:is_social_lobby_on]
    current_hotel.settings.is_my_group_on = params[:is_my_group_on]
    current_hotel.settings.arrival_grace_days = params[:arrival_grace_days]
    current_hotel.settings.departure_grace_days = params[:departure_grace_days]
    render json: { status: status,  data: data, errors: errors }
  end
end
