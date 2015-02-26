class Admin::RolesController < ApplicationController
  before_filter :check_session

  # GET /roles
  # GET /roles.json
  def index
    roles = current_hotel ? current_hotel.roles : Roles.all
    data = {}
    data[:user_roles] = roles.map { |role| { value: role.id.to_s, name: role.name } } if roles
    respond_to do |format|
      format.html { render partial: 'user_roles_list', locals: { data: data,  errors: [] } }
      format.json { render json: data }
    end
  end

  # POST /roles
  # POST /roles.json
  def create
    status, errors, data = SUCCESS, [], {}
    role = Role.new(name: params[:name])
    role.hotel = current_hotel if current_hotel

    unless role.save
      errors = role.errors.full_messages
    end
    render json: { status: status, data: data, errors: errors }
  end

  # GET /roles/1/edit
  def edit
    status, errors, data = SUCCESS, [], {}
    begin
      role = Role.find(params[:id])
      data = { value: role.id.to_s, name: role.name }
    rescue ActiveRecord::RecordNotFound =>  e
      status, errors = FAILURE, [e.message]
    end
    respond_to do |format|
      format.html { render partial: 'edit_user_roles', locals: { data: data,  errors: errors } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  # GET /roles/new
  # GET /roles/new.json
  def new
    @role = Role.new
    respond_to do |format|
      format.html { render partial: 'add_user_roles' }
      format.json { render json: @role }
    end
  end

  # PUT /roles/1
  # PUT /roles/1.json
  def update
    errors, status = [], SUCCESS
    begin
      role = Role.find(params[:id])
      unless role.update_attributes(name: params[:name])
        errors, status = [role.errors.full_messages], FAILURE
      end
    rescue ActiveRecord::RecordNotFound => e
        errors, status = [e.message], FAILURE
    end
    render json: { 'status' => status, 'data' => {}, 'errors' => errors }
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    errors, status = [], SUCCESS
    begin
      role = Role.find(params[:id])
      # check whether role is associated with any users
      if role.users.present?
        errors, status = ['Role already mapped to some users'], FAILURE
      else
        role.destroy
      end
    rescue ActiveRecord::RecordNotFound => e
        errors, status = [e.message], FAILURE
    end
    render json: { 'status' => status, 'data' => {}, 'errors' => errors }
  end
end
