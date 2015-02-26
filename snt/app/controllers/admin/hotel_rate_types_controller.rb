class Admin::HotelRateTypesController < ApplicationController
  before_filter :check_session

  # GET /hotel_rate_types
  # GET /hotel_rate_types.json
  def index
    rate_types = current_hotel.available_rate_types
    hotel_rate_types_id = current_hotel.rate_types.pluck(:rate_type_id) if current_hotel
    data = {}
    if rate_types
      data[:rate_types] = rate_types.map do |rate_type|
            {
              id: rate_type.id.to_s, description: rate_type.name,
              is_active: (hotel_rate_types_id.include? rate_type.id).to_s,
              is_system_defined: rate_type.hotel_id ? 'false' : 'true',
              is_status_changeable: (!rate_type.rates.present?).to_s
            }
          end
    end

    respond_to do |format|
      format.html { render partial: 'rate_type_list', locals: { data: data,  errors: [] } }
      format.json { render json: data }
    end
  end

  # GET /hotel_rate_types/new
  # GET /hotel_rate_types/new.json
  def new
    @rate_type = RateType.new
    respond_to do |format|
      format.html { render partial: 'add_rate_type' }
      format.json { render json: @rate_type }
    end
  end

  # POST /hotel_rate_types
  # POST /hotel_rate_types.json
  def create
    rate_type = RateType.new(name: params[:name])
    rate_type.hotel_id = current_hotel.id
    if rate_type.save
      response =  { 'status' => SUCCESS, 'data' => {}, 'errors' => [] }
    else
      response =  { 'status' => FAILURE, 'data' => {}, 'errors' => rate_type.errors.full_messages }
    end
    render json: response
  end

  # GET /hotel_rate_types/1/edit
  def edit
    status, errors, data = SUCCESS, [], {}
    begin
      rate_type = RateType.find(params[:id])
      data = { value: rate_type.id.to_s, name: rate_type.name }
    rescue ActiveRecord::RecordNotFound =>  e
      status, errors = FAILURE, [e.message]
    end
    respond_to do |format|
      format.html { render partial: 'edit_rate_type', locals: { data: data,  errors: errors } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  # POST /hotel_rate_types
  # POST /hotel_rate_types.json
  def toggle_activation
    errors, status = [], SUCCESS
    toggle_activation = params[:status]
    rate_type_id = params[:value]
    if toggle_activation && rate_type_id
      begin
        rate_type = RateType.find(rate_type_id)
        errors, status = ['Rate Type already mapped to some rates'], FAILURE if rate_type.rates.present?
        if errors.empty?
          if toggle_activation == 'activate'
            current_hotel.rate_types << rate_type unless current_hotel.rate_types.include?(rate_type)
            current_hotel.save
          else
            current_hotel.rate_types.destroy(rate_type)
          end
        end
      rescue ActiveRecord::RecordNotFound => e
        errors, status = [e.message], FAILURE
      end
    else
      errors, status = ['Parameter missing'], FAILURE
    end
    render json: { 'status' => status, 'data' => {}, 'errors' => errors }
  end

  # PUT /hotel_rate_types/1
  # PUT /hotel_rate_types/1.json
  def update
    errors, status = [], SUCCESS
    begin
      rate_type = RateType.find(params[:id])
      errors, status = ['Edit Permission Denied'], FAILURE unless rate_type.hotel == current_hotel
      if !rate_type.update_attributes(name: params[:name]) && errors.empty?
        errors, status = [rate_type.errors.full_messages], FAILURE
      end
    rescue ActiveRecord::RecordNotFound => e
        errors, status = [e.message], FAILURE
    end
    render json: { 'status' => status, 'data' => {}, 'errors' => errors }
  end
end
