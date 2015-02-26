class Admin::HotelRoomsController < ApplicationController
  before_filter :check_session

  # GET /hotel_rooms
  # GET /hotel_rooms.json
  def index
    page_number = params[:page] || 1
    per_page    = params[:per_page] || 100
    query       = params[:query]
    sort_by     = ["room_no", "room_type_name"].include?(params[:sort_field]) ? params[:sort_field] : "room_no"
    direction   = params[:sort_dir].nil? ? 'ASC': (params[:sort_dir] == 'true' ? 'ASC' : 'DESC')
    
    rooms = current_hotel.rooms.includes(:room_type)
                .where('room_no LIKE ? OR room_types.room_type_name LIKE ?', "%#{query}%", "%#{query}%")
                .order("#{sort_by} #{direction}")
    data = {}
    rooms_configured = current_hotel.rooms.includes(:room_type).where('room_types.is_pseudo=0 and room_types.is_suite=0').count
    number_of_rooms = current_hotel.number_of_rooms
    data[:number_of_rooms_configured] = rooms_configured.to_s
    data[:total_number_of_rooms] = number_of_rooms.to_s
    data[:is_add_available] = (rooms_configured < number_of_rooms) && !current_hotel.is_third_party_pms_configured? ? 'yes' : 'no'
    data[:total_count] = rooms.count
    rooms = rooms.page(page_number).per(per_page)
    
    data[:rooms] = rooms.map do |room|
                                   { room_id: room.id.to_s,
                                     room_number: room.room_no,
                                     room_type: room.andand.room_type.andand.room_type_name,
                                     max_occupancy: room.max_occupancy
                                   }
                                 end if rooms
    respond_to do |format|
      format.html { render partial: 'rooms_list', locals: { data: data,  errors: [] } }
      format.json { render json: { status: SUCCESS, data: data, errors: [] } }
    end
  end

  # GET /hotel_rooms/new
  # GET /hotel_rooms/new.json
  def new
    data = {}
    room_types = current_hotel.room_types
    hotel = current_hotel
    data[:room_types] = room_types.map { |room_type| { value: room_type.id.to_s, name: room_type.room_type_name } }
    data[:room_features] = hotel.features.room_feature.map { |room_feature| { value: room_feature.id.to_s, name: room_feature.value } }
    data[:room_likes] = map_room_likes(hotel)
    data[:floors] = map_hotel_floors(hotel)
    respond_to do |format|
      format.html { render partial: 'add_new_rooms', locals: { data: data,  errors: [] } }
      format.json { render json:  { 'status' => SUCCESS, 'data' => data, 'errors' => [] } }
    end
  end

  # POST /hotel_rooms
  # POST /hotel_rooms.json
  def create
    room = Room.new(room_no: params[:room_number], room_type_id: params[:room_type_id], floor_id: params[:selected_floor], max_occupancy: params[:max_occupancy])
    room.hotel = current_hotel
    features = params[:active_room_features]
    room.features << (Feature.find features) if features
    likes =  params[:active_room_likes]
    room.features << (Feature.find likes) if likes
    if params[:room_image].present?
      base64_data = get_base64_from_post_image(params[:room_image])
      room.set_room_image_from_base64(base64_data)
    end
    room.hk_status = :CLEAN unless current_hotel.is_third_party_pms_configured?
    if room.save
      response =  { 'status' => SUCCESS, 'data' => {'room_id' => room.id}, 'errors' => [] }
    else
      response =  { 'status' => FAILURE, 'data' => {}, 'errors' => room.errors.full_messages }
    end
    render json: response
  end

  # GET /hotel_rooms/:id/edit
  def edit
    status, errors, data = SUCCESS, [], {}
    begin
      room = Room.find(params[:id])
      data = {}
      data = { room_id: room.id.to_s, room_number: room.room_no, room_type_id: room.room_type.id.to_s, room_image: room.image.url, max_occupancy: room.max_occupancy }
      data[:room_types] = current_hotel.room_types.map { |room_type| { value: room_type.id.to_s, name: room_type.room_type_name } }
      data[:room_features] = current_hotel.features.room_feature.map { |room_feature| { value: room_feature.id.to_s, name: room_feature.value } }
      data[:room_likes] = map_room_likes(current_hotel)
      data[:floors] = map_hotel_floors(current_hotel)
      data[:selected_floor] = room.floor.present? ? room.floor.id : ''
      data[:active_room_features] = room.features.room_feature.map { |feature| feature.id.to_s }
      room_likes = room.features.map { |feature| feature.id } + room.features.elevator.map { |feature| feature.id } + room.features.smoking.map { |feature| feature.id }
      data[:active_room_likes] = room_likes.map(&:to_s)
    rescue ActiveRecord::RecordNotFound =>  e
      status, errors = FAILURE, [e.message]
    end
    respond_to do |format|
      format.html { render partial: 'edit_rooms', locals: { data: data,  errors: errors } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  # PUT /hotel_rooms/1
  # PUT /hotel_rooms/1.json
  def update
    errors, status = [], SUCCESS
    begin
      room = Room.find(params[:id])
      room_attributes = {
        floor_id: params[:selected_floor],
        room_no: params[:room_number],
        room_type_id: params[:room_type_id],
        max_occupancy: params[:max_occupancy]
      }
      if params[:room_image].present?
        base64_data = get_base64_from_post_image(params[:room_image])
        room.set_room_image_from_base64(base64_data)
      end
      room.features.delete_all
      features = []
      features << params[:active_room_features] if params[:active_room_features]
      features << params[:active_room_likes] if params[:active_room_likes]
      room.features << (Feature.find features)
      room.attributes = room_attributes

      errors, status = room.errors.full_messages, FAILURE unless room.save
    rescue ActiveRecord::RecordNotFound => e
        errors, status = [e.message], FAILURE
    end
    render json: { 'status' => status, 'data' => {}, 'errors' => errors }
  end

  def destroy
    errors, status = [], SUCCESS
    begin
      room = Room.find(params[:id])
      # check whether rooms is associated with any reservations
      if !ReservationDailyInstance.where(:room_id => room.id).empty?
        errors, status = ['Room is already mapped to some reservations'], FAILURE
      else
        room.destroy
      end   
      rescue ActiveRecord::RecordNotFound => e
        errors, status = [e.message], FAILURE
    end
    render json: { 'status' => status, 'errors' => errors }
  end
  
  private

  def map_room_likes(hotel)
    room_likes = []
    room_floor = {}
    room_floor[:group_name] = 'FLOOR'
    room_floor[:options] = hotel.features.floor.map { |floor| { value: floor.id.to_s, name: floor.value } }
    room_likes << room_floor

    room_elevator = {}
    room_elevator[:group_name] = 'ELEVATOR'
    room_elevator[:options] = hotel.features.elevator.map { |elevator| { value: elevator.id.to_s, name: elevator.value } }
    room_likes << room_elevator

    room_smoking = {}
    room_smoking[:group_name] = 'SMOKING'
    room_smoking[:options] = hotel.features.smoking.map { |smoking| { value: smoking.id.to_s, name: smoking.value } }
    room_likes << room_smoking

    # Fetch hotel-specific custom features
    hotel_feature_group_names  = hotel.features.joins(:feature_type).where('feature_types.hotel_id IS NOT NULL').pluck('feature_types.value').uniq
    hotel_feature_group_names.each do |feature_type|
      hotel_feature = {}
      hotel_feature[:group_name] = feature_type
      hotel_feature[:options] = hotel.features.joins(:feature_type).where('feature_types.value=?', feature_type).map { |smoking| { value: smoking.id.to_s, name: smoking.value } }
      room_likes << hotel_feature
    end

    room_likes
  end

  def get_base64_from_post_image(raw_post_image)
    data = raw_post_image.split('base64,')
    data[1]
  end

  def map_hotel_floors(hotel)
    hotel.floors.map do |floor|
      {
        value: floor.id,
        name: floor.floor_number
      }
    end
  end


end
