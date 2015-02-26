class Admin::DepartmentsController < ApplicationController
  before_filter :check_session
  # GET /departments
  # GET /departments.json
  def index
    hotel = current_hotel
    departments = hotel.departments
    data = {}
    data[:departments] = departments.map { |department| { value: department.id.to_s, name: department.name } } if departments
    respond_to do |format|
      format.html { render partial: 'departments_list', locals: { data: data,  errors: [] } }
      format.json { render json: { data: data, status: SUCCESS, errors: []} }
    end
  end

  # GET /departments/new
  # GET /departments/new.json
  def new
    @department = Department.new

    respond_to do |format|
      format.html { render partial: 'add_department' }
      format.json { render json: {data: @department, status: SUCCESS, errors: [] } }
    end
  end

  # GET /departments/1/edit
  def edit
    status, errors, data = SUCCESS, [], {}
    begin
      department = Department.find(params[:id])
      data = { value: department.id.to_s, name: department.name }
    rescue ActiveRecord::RecordNotFound =>  e
      status, errors = FAILURE, [e.message]
    end
    respond_to do |format|
      format.html { render partial: 'edit_department', locals: { data: data,  errors: errors } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  # POST /departments
  # POST /departments.json
  def create
    department = Department.new(name: params[:name])
    department.hotel = current_hotel
    if department.save
      response =  { 'status' => SUCCESS, 'data' => {value: department.id.to_s, name: department.name.to_s}, 'errors' => [] }
    else
      response =  { 'status' => FAILURE, 'data' => {}, 'errors' => department.errors.full_messages }
    end
    render json: response
  end

  # PUT /departments/1
  # PUT /departments/1.json
  def update
    errors, status = [], SUCCESS
    department = Department.find(params[:id])


    unless department.update_attributes(name: params[:name])
      errors, status = [department.errors.full_messages], FAILURE

    end

    render json: { 'status' => status, 'data' => {}, 'errors' => errors }
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    errors, status = [], SUCCESS

    department = Department.find(params[:id])
    # check whether department is associated with any users
    if department.users.present?
      errors, status = [I18n.t(:cannot_delete_dep_mapped_users)], FAILURE
    else
      department.destroy
    end

    render json: { 'status' => status, 'data' => {}, 'errors' => errors }
  end
end
