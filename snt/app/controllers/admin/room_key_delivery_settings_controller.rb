class Admin::RoomKeyDeliverySettingsController < ApplicationController
  before_filter :check_session

  def index
    status, data, errors = FAILURE, {}, []

    status = SUCCESS
    data = ViewMappings::RoomKeyDeliverySettingsMapping.map_room_key_delivery_settings(current_hotel)

    respond_to do |format|
      format.html { render partial: 'admin/rooms/room_key_delivery', locals: { data: data,  errors: [] } }
      format.json { render json: { status: status,  data: data, errors: errors } }
    end
  end

  def update
    status, data, errors = FAILURE, {}, []
    params[:key_system_id] = params[:selected_key_system] 
    params[:id] = params[:value]
    params[:value] = params[:name]
    key_delivery = KeyDelivery.new(params.except(:selected_key_system, :value, :name))

    key_delivery.hotel = current_hotel
  
    if key_delivery.save
      data = ViewMappings::RoomKeyDeliverySettingsMapping.map_room_key_delivery_settings(current_hotel)
      status = SUCCESS
    else
      errors = key_delivery.errors.full_messages
    end

    render json: { status: status,  data: data, errors: errors }
  end
end
