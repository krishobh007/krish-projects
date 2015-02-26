class Api::WorkAssignmentsController < ApplicationController
  before_filter :check_session
  before_filter :check_business_date
  after_filter :load_business_date_info
  before_filter :set_time_zone
  after_filter :revert_time_zone
  before_filter :check_business_date

  include Api::WorkAssignmentsHelper

  def index
    business_date = current_hotel.active_business_date
    employee_ids = params[:employee_ids] || []
    work_type_id = params[:work_type_id]
    rooms = current_hotel.rooms
    
    @date = params.key?(:date) ? params[:date].to_date : business_date
    
    # Check whether requested date is the current business date of the hotel
    @is_business_date = @date == business_date

    @work_type = WorkType.find(work_type_id)

    # Get all the selected room reservation/front office status for the tasks for a specific work type
    reservation_hk_statuses = @work_type.tasks.joins('LEFT OUTER JOIN task_reservation_statuses ON task_reservation_statuses.task_id = tasks.id')
      .select('distinct ref_reservation_hk_status_id').map { |task| Ref::ReservationHkStatus[task.ref_reservation_hk_status_id].andand.value }

    @unassigned_rooms = []

    @unassigned_rooms = rooms.with_hk_status(:DIRTY)
      .where('room_type_id IN (select room_type_tasks.room_type_id from room_type_tasks JOIN tasks ON tasks.id = room_type_tasks.task_id ' \
             'where tasks.work_type_id = ? and ((tasks.is_vacant = true and rooms.is_occupied = false) ' \
             'or (tasks.is_occupied = true and rooms.is_occupied = true) or (tasks.is_vacant = false AND tasks.is_occupied = false)))',
             work_type_id)
      .with_reservation_hk_statuses(reservation_hk_statuses, @date)
    
    # Get all the vacant and dirty rooms for the business date. These needed to be included in unassigned list.
    vacant_and_dirty_rooms = @is_business_date ? rooms.vacant_and_dirty_rooms_on(@date) : []
    @unassigned_rooms = (@unassigned_rooms + vacant_and_dirty_rooms).uniq
    
    # Get all assigned rooms
    assigned_rooms = rooms.where('rooms.id IN (select room_id from work_assignments ' \
               'LEFT OUTER JOIN work_sheets ON work_sheets.id = work_assignments.work_sheet_id ' \
               'where work_sheets.work_type_id = ? and work_sheets.date = ?)', work_type_id, @date)
    
    # Remove already assigned rooms from the unassigned list
    @unassigned_rooms = @unassigned_rooms - assigned_rooms
    
    @employees = User.where(id: employee_ids)
  end

  def assign
    date = params[:date].to_date if params[:date]
    order = params[:order]
    task_id = params[:task_id] # It is work type id

    assignments = params[:assignments] || []

    @touched_work_sheets = []
    assignments.each do |assign|
      assignee_id = assign[:assignee_id] || nil
      room_ids = assign[:room_ids] || []
      work_sheet_id = assign[:work_sheet_id] || nil
      shift_id = assign[:shift_id] || nil
      from_search = assign[:from_search] || false

      if work_sheet_id.blank?
        work_sheet = WorkSheet.find_or_initialize_by_user_id_and_work_type_id_and_date(assignee_id, task_id, date)
      else
        work_sheet = WorkSheet.find(work_sheet_id)
      end

      work_sheet.user_id = assignee_id
      work_sheet.work_type_id = task_id #Comm by Mub: Confused with this param name
      work_sheet.shift_id = shift_id if shift_id
      is_work_type_changed = work_sheet.work_type_id_changed? ^ work_sheet.new_record?
      work_sheet.save!

      work_sheet.work_assignments.destroy_all unless from_search

      @touched_work_sheets.push({
        :work_sheet_id  => work_sheet.id,
        :assignee_id    => assignee_id,
        :task_id        => work_sheet.id
      })

      # Execute this only if there is a change in work type for the work sheet
      unless is_work_type_changed
        # Iterate through each rooms
        room_ids.each do |room_id|
          # Find the existing work assigned for the room
          existing_work = WorkAssignment.find_by_room_id_and_work_sheet_id(room_id, work_sheet.id)
          # Destroy the existing assigned work
          existing_work.destroy if existing_work
          # Create a new work assignment for the room
          # Yet to get clarification on work status id
          work_status = Ref::WorkStatus.where(:value => 'OPEN').first

          task = get_task_for_room_on(date, Room.find(room_id), work_sheet.work_type)

          WorkAssignment.create!(work_sheet_id: work_sheet.id, room_id: room_id, task: task, work_status_id: 1, work_status: work_status)
        end
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render(json: e.record.errors.full_messages, status: 422)
  end

  def update_work_time
    work_sheet_id = params[:work_sheet_id]
    room_id = params[:room_id]
    task_completion_hk_status = params[:task_completion_status]
    @work_assignment = WorkAssignment.find_by_work_sheet_id_and_room_id!(work_sheet_id, room_id)

    if @work_assignment.begin_time.blank?
      @work_assignment.begin_time = Time.now
      work_status = Ref::WorkStatus.where(:value => 'IN_PROGRESS').first
      @work_assignment.work_status = work_status
    else
      if @work_assignment.end_time.blank?
        @work_assignment.end_time = Time.now
        work_status = Ref::WorkStatus.where(:value => 'COMPLETED').first
        @work_assignment.work_status = work_status
      end
    end
    # Handle room status updation when an assigned task is done
    if task_completion_hk_status.present?
      room = current_hotel.rooms.find(room_id)
      room.hk_status_id = task_completion_hk_status
      room.save!
    end
    @work_assignment.save!
  rescue ActiveRecord::RecordInvalid => e
    render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

  # Get all unassigned rooms for all the work types - CICO-10457
  def unassigned_rooms
    rooms = current_hotel.rooms
    business_date = current_hotel.active_business_date
    @work_types = current_hotel.work_types
    @date = params[:date].to_date if params[:date]
    @is_business_date = (@date == business_date) ? true : false
    @work_types.each do |work_type|
      applicable_rooms = work_type.tasks.joins([room_types: :rooms])
      assigned_rooms = applicable_rooms
                           .joins('LEFT OUTER JOIN work_assignments ON work_assignments.room_id = rooms.id')
                           .joins('LEFT OUTER JOIN work_sheets ON work_sheets.id = work_assignments.work_sheet_id')
                           .where('work_sheets.work_type_id = ?', work_type.id)
                           .where('work_sheets.date = ?', @date)
      @unassigned_rooms = rooms.
                         where('id NOT IN (?)',
                         assigned_rooms.select('rooms.id').count > 0 ? assigned_rooms.select('rooms.id') : "")
    end
  end
end
