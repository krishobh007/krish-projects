class Admin::RoomTypesController < ApplicationController
  before_filter :check_session

  def index
    status, data, errors = FAILURE, {}, []
    status = SUCCESS
    data = ViewMappings::RoomTypesMapping.map_room_types(current_hotel)
    respond_to do |format|
      format.html { render partial: 'rooms_list', locals: { data: data,  errors: [] } }
      format.json { render json: { status: status,  data: data, errors: errors } }
    end
  end

  def new
    @room_type = RoomType.new
    respond_to do |format|
      format.html { render partial: 'add_room' }
      format.json { render json: @room_type }
    end
  end

  def create
    @room_type = RoomType.new(ViewMappings::RoomTypesMapping.map_new_room_type_params(params, current_hotel))
    @room_type.hotel = current_hotel

    if params[:image_of_room_type].present?
      @room_type.image_from_base64 = get_base64_from_post_image(params[:image_of_room_type])
    end

    if @room_type.save
      upsell_room_level = UpsellRoomLevel.create!(level: 1, room_type_id: @room_type.id)
      data = { id: @room_type.id.to_s }
      response =  { 'status' => SUCCESS, 'data' => data, 'errors' => [] }
    else
      response =  { 'status' => FAILURE, 'data' => {}, 'errors' => @room_type.errors.full_messages }
    end
    render json: response
  end

  def edit
    status, errors, data = SUCCESS, [], {}
    begin
      @room_type = RoomType.find(params[:id])
      data = ViewMappings::RoomTypesMapping.map_edit_room_type_params(@room_type)
    rescue ActiveRecord::RecordNotFound =>  e
      status, errors = FAILURE, [e.message]
    end
    respond_to do |format|
      format.html { render partial: 'edit_room', locals: { data: data,  errors: errors } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  def update
    errors, status = [], SUCCESS
    begin
      @room_type = RoomType.find(params[:id])

      if params[:image_of_room_type].present?
        @room_type.image_from_base64 = get_base64_from_post_image(params[:image_of_room_type])
      end

      unless @room_type.update_attributes(ViewMappings::RoomTypesMapping.map_new_room_type_params(params, current_hotel))
        errors, status = @room_type.errors.full_messages, FAILURE
      end
    rescue ActiveRecord::RecordNotFound => e
        errors, status = [e.message], FAILURE
    end
    render json: { 'status' => status, 'data' => {}, 'errors' => errors }
  end

  def destroy
    errors, status = [], SUCCESS
    begin
      @room_type = RoomType.find(params[:id])
      # check whether any rate is configured for this room_type
      if !RatesRoomType.where(:room_type_id => @room_type.id).empty?
        errors, status = ['Rate is configured for this Room Type'], FAILURE
      # check whether room_type is associated with any room
      elsif @room_type.rooms.any?
      # check whether rooms under this room_type is associated with any reservations            
        if !ReservationDailyInstance.where(:room_id => @room_type.rooms.pluck(:id)).empty?
          errors, status = ['Room Type already mapped to some reservations'], FAILURE
        else
          @room_type.destroy
        end
      else
        @room_type.destroy
      end
      rescue ActiveRecord::RecordNotFound => e
        errors, status = [e.message], FAILURE
    end
    render json: { 'status' => status, 'errors' => errors }
  end

  def import_rooms
    if current_hotel

      import_status = current_hotel.sync_external_room_number

      if import_status == true
        render json: { status: SUCCESS, data: import_status.to_s, errors: [] }
      else
        render json: { status: FAILURE, data: import_status.to_s, errors: [] }
      end

    end
  end

  def get_base64_from_post_image(raw_post_image)
    data = raw_post_image.split('base64,')[1]
  end
end
