class Admin::ChargeGroupsController < ApplicationController
  before_filter :check_session

  # List all charge groups for current hotel
  def index
    status, data, errors = SUCCESS, {}, []
    data[:charge_groups] = current_hotel.charge_groups.map { |charge_group| { value: charge_group.id.to_s, name: charge_group.description } } if current_hotel.charge_groups
    respond_to do |format|
      format.html { render partial: 'charge_groups_list', locals: { data: data,  errors: errors } }
      format.json { render json: { 'status' => status, 'data' => data, 'errors' => errors } }
    end
  end

  def new
    render partial: 'add_new_charge_group'
  end

  def create
    errors = []
    charge_group = ChargeGroup.new(charge_group: params[:name], description: params[:name], hotel_id: current_hotel.id)
    charge_group.save
    if charge_group.errors.empty?
      status, data, errors = SUCCESS, {value: charge_group.id,name: charge_group.description}, []
    else
      status, data, errors = FAILURE, {}, charge_group.errors.full_messages
    end
    respond_to do |format|
      format.json { render json: { 'status' => status, 'data' => data, 'errors' => errors } }
    end
  end

  def edit
    charge_group = current_hotel.charge_groups.find(params[:id])
    respond_to do |format|
      format.html { render partial: 'edit_charge_groups', locals: { data: { value: charge_group.id, name: charge_group.description },  errors: [] } }
      format.json { render json: { 'status' => status, 'data' => { value: charge_group.id, name: charge_group.description }, 'errors' => [] } }
    end
  end

  def update
    charge_group = current_hotel.charge_groups.find(params[:id])
    charge_group_params = { id: params[:value], charge_group: params[:name], description: params[:name] }
    if charge_group.update_attributes(charge_group_params)
      status, data, errors = SUCCESS, {}, []
    else
      status, data, errors = FAILURE, {}, charge_group.errors.full_messages
    end
    respond_to do |format|
      format.json { render json: { 'status' => status, 'data' => { value: charge_group.id, name: charge_group.description }, 'errors' => errors } }
    end
  end

  def destroy
    charge_group = current_hotel.charge_groups.find(params[:id])
    status, data, errors = SUCCESS, {}, []
    if charge_group.charge_codes.count > 0
      status, data, errors = FAILURE, {}, [I18n.t(:cannot_delete_charge_code_associated)]
    else
      current_hotel.charge_groups.destroy(charge_group)
      status, data, errors = SUCCESS, { value: charge_group.id, name: charge_group.description }, []
    end
    respond_to do |format|
      format.json { render json: { 'status' => status, 'data' => data, 'errors' => errors } }
    end
  end
end
