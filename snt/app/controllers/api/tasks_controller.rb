class Api::TasksController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :set_time_zone
  after_filter :revert_time_zone
  before_filter :check_business_date

  def index
    @tasks = Task.joins(:work_type).where('work_types.hotel_id = ?', current_hotel.id).page(params[:page]).per(params[:per_page])
  end

  def create
    begin
      @task = Task.create!(task_params)
      create_room_type_tasks if params[:rooms_task_completion].present?
    rescue ActiveRecord::RecordInvalid => ex
      render(json: ex.message, status: :unprocessable_entity)
    end
  end
  
  def show
    @task = Task.find(params[:id])
    room_type_ids = @task.room_type_ids
    @room_types_completion_time = {}
    task_id = @task.id
    room_type_ids.each do |room_type_id|
      room_type_task =  RoomTypeTask.find_by_room_type_id_and_task_id(room_type_id, task_id)
      @room_types_completion_time[room_type_id] = room_type_task.andand.completion_time.andand.strftime("%H:%M")
    end
  end

  def update
    @task = Task.find(params[:id])
    create_room_type_tasks if params[:rooms_task_completion].present?
    @task.update_attributes(task_params) || render(json: @task.errors.full_messages, status: :unprocessable_entity)
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy || render(json: @task.errors.full_messages, status: :unprocessable_entity)
  end
  
  # Get the Applicable statuses --- To be displayed in Task HK Completion Status DropDown 
  def hk_applicable_statuses
    @hk_status_list = Ref::HousekeepingStatus.get_housekeeping_status_list(current_hotel.settings.use_inspected, current_hotel.settings.use_pickup)
  end
  
  # Update Room Type Tasks Completion time - CICO-10172 point #11
  def create_room_type_tasks
    rooms_task_completion_hash = params[:rooms_task_completion]
    room_type_ids = rooms_task_completion_hash.keys
    task_id = @task.id
    room_type_ids.each do |room_type_id|
      existing_room_type_task = RoomTypeTask.find_by_room_type_id_and_task_id(room_type_id, task_id)
      if existing_room_type_task.present?
        existing_room_type_task.completion_time = rooms_task_completion_hash[room_type_id]
        existing_room_type_task.save!
      else
        room_type_task = RoomTypeTask.create(room_type_id: room_type_id, completion_time: rooms_task_completion_hash[room_type_id])
      end
    end
  end

  private

  def task_params
    { 
      name: params[:name],
      work_type_id: params[:work_type_id],
      room_type_ids: params[:room_type_ids],
      ref_reservation_hk_status_ids: params[:reservation_statuses_ids],
      front_office_status_ids: params[:front_office_status_ids],
      is_occupied: params[:is_occupied],
      is_vacant: params[:is_vacant],
      completion_time: params[:completion_time].andand.to_datetime,
      ref_housekeeping_status_id: params[:task_completion_hk_status_id].present? ? params[:task_completion_hk_status_id] : Ref::HousekeepingStatus[:CLEAN].id
    }
  end
end