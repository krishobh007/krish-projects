class Api::WorkStatisticsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  before_filter :set_time_zone, only: [:index, :employee]
  after_filter :revert_time_zone, only: [:index, :employee]
  
  def index
    req_date = (params[:date].to_date if params[:date]) || current_hotel.active_business_date
    work_type = WorkType.find(params[:work_type_id]) if params[:work_type_id] 
    business_date = current_hotel.active_business_date
    is_stay_over = false
    
    work_assignments = WorkAssignment.joins(:work_sheet)
                                      .joins(:room)
                                      .where('work_sheets.date = ?', req_date)                                
    rooms = current_hotel.rooms
    hotel_reservations = current_hotel.reservations
    
    vacant_and_dirty_rooms = (req_date == business_date) ? rooms.vacant_and_dirty_rooms_on(req_date) : []
                             
    departed_assignments = work_assignments.where('rooms.id IN (?)', rooms.total_departure_on(req_date).uniq.pluck(:id))
    stay_over_assignments = work_assignments.where('rooms.id IN (?)', rooms.total_stay_over_on(req_date).uniq.pluck(:id))
    
    # Find all departed and stay over rooms
    departed_rooms = rooms.total_departure_on(req_date).uniq + vacant_and_dirty_rooms
    stay_over_rooms = rooms.total_stay_over_on(req_date).uniq
    
    # Get the departed and stay over hours
    total_departed_hours = get_task_time_array(departed_rooms, is_stay_over)
    total_stay_over_hours = get_task_time_array(stay_over_rooms, is_stay_over = true)
    
    # Find departed and stay over assignments
    departed_assignments = work_assignments.where('rooms.id IN (?)', departed_rooms.map(&:id))
    stay_over_assignments = work_assignments.where('rooms.id IN (?)', stay_over_rooms.map(&:id))
    
    # Calculate number of maids required
    departed_maids_required = (total_departed_hours/480.0).ceil
    stay_over_maids_required = (total_stay_over_hours/480.0).ceil
    
    # Calculate completed works assigned
    departed_rooms_completed = departed_assignments.where('work_assignments.end_time IS NOT NULL').count
    stay_over_rooms_completed = stay_over_assignments.where('work_assignments.end_time IS NOT NULL').count
    
    @departures = {}
    @stayovers = {}
    # Get HK Details for departure rooms - CICO-8605
    @departures[:clean] = hotel_reservations.departure_on(req_date).uniq.count + vacant_and_dirty_rooms.count
    @departures[:total_hours] = "#{sprintf '%02d', total_departed_hours/60}:#{sprintf '%02d', total_departed_hours%60}"
    @departures[:total_maids_required] = departed_maids_required
    @departures[:total_rooms_assigned] = departed_assignments.count
    @departures[:total_rooms_completed] = departed_rooms_completed
    # Get HK Details for departure rooms - CICO-8605
    @stayovers[:clean] = hotel_reservations.stay_over_on(req_date).uniq.count
    @stayovers[:total_hours] = "#{sprintf '%02d', total_stay_over_hours/60}:#{sprintf '%02d', total_stay_over_hours%60}"
    @stayovers[:total_maids_required] = stay_over_maids_required
    @stayovers[:total_rooms_assigned] = stay_over_assignments.count
    @stayovers[:total_rooms_completed] = stay_over_rooms_completed
    
  end
  
  def employee
    query = params[:query]
    date = params[:date]
    work_type_id = params[:work_type_id]
    results = find_employee_statistics(query, date, work_type_id)
  end
  
  # API to fetch all house keeping staff
  def employees_list
    @maids = current_hotel.users.with_maintenance_role.page(params[:page]).per(params[:per_page])
  end
  
  def find_employee_statistics(query, date, work_type_id)
   
    
    @result_array = []
    search = "%#{query}%"
    rooms = current_hotel.rooms
    if work_type_id
      # Get the employees when work type is mentioned in query
      employees = current_hotel.users.maid_list_with_work_type_on(date, work_type_id)
                 .where("first_name like ? or last_name like ?", search, search)
    else
      # Get the employees when no work type is mentioned in query
      employees = current_hotel.users.maid_list_on(date)
                 .where("first_name like ? or last_name like ?", search, search)
    end
    employees.each do |employee|
      data = {}
      departures = {}
      stayovers = {}
      data[:full_name] = [employee.first_name, employee.last_name].compact.join(" ")
      data[:work_type_id] = employee.work_type
      data[:work_sheet_id] = employee.work_sheet_id
      work_assignments = WorkAssignment.joins(:work_sheet)
                                      .joins(:room)
                                      .where('work_sheets.date = ?', date)
                                      .where('work_sheets.user_id = ?', employee.employee_id)
                                      
      departed_assignment = work_assignments.where('rooms.id IN (?)', rooms.total_departure_on(date).uniq.pluck(:id))
      
      departed_tasks_hours = departed_assignment.joins('INNER JOIN tasks ON tasks.work_type_id = work_sheets.work_type_id')
                                          .group('work_sheets.work_type_id').select('SUM(UNIX_TIMESTAMP(tasks.completion_time))')
      
      stay_over_assignment = work_assignments.where('rooms.id IN (?)', rooms.total_stay_over_on(date).uniq.pluck(:id))
      
      stay_over_tasks_hours = stay_over_assignment.joins('INNER JOIN tasks ON tasks.work_type_id = work_sheets.work_type_id')
                                          .group('work_sheets.work_type_id').select('SUM(UNIX_TIMESTAMP(tasks.completion_time))')
                                
      departures[:clean] = rooms.total_departure_on(date).uniq.count
      departures[:total_hours] = departed_tasks_hours
      departures[:total_rooms_assigned] = departed_assignment.count
      departures[:total_rooms_completed] = departed_assignment.where('end_time IS NOT NULL').count
      data[:departures] = departures
      stayovers[:clean] = rooms.total_stay_over_on(date).uniq.count
      stayovers[:total_hours] = stay_over_tasks_hours
      stayovers[:total_rooms_assigned] = stay_over_assignment.count
      stayovers[:total_rooms_completed] = stay_over_assignment.where('end_time IS NOT NULL').count
      data[:stayovers] = stayovers
      @result_array << data
    end
  end
  
  def get_task_time_array(rooms, is_stay_over)
    total_minutes = 0
    rooms.each do |room|
      # If room is a stay over get associated task
      if is_stay_over
        associated_task = room.tasks.joins(:ref_reservation_hk_statuses)
                          .where("ref_reservation_hk_status_id = ?", Ref::ReservationHkStatus[:STAYOVER].id).first
        
      else
        associated_task = room.tasks.joins(:ref_reservation_hk_statuses)
                          .where("ref_reservation_hk_status_id = ?", Ref::ReservationHkStatus[:DEPARTED].id).first
      end
      # Set associated task as the departure task by default, if there is no associated task found for a room
      associated_task = current_hotel.work_type_tasks.joins(:ref_reservation_hk_statuses)
                        .where("ref_reservation_hk_status_id = ?", Ref::ReservationHkStatus[:DEPARTED].id).first unless associated_task.present?
      # Get the completion time for the room type, if specified - CICO-10172 Point #11
      room_type_completion_time = associated_task.room_type_tasks.
                                  where(room_type_id: room.room_type_id).first.andand.
                                  completion_time if associated_task.present?
      task_completion_time = room_type_completion_time ? room_type_completion_time : (associated_task ? associated_task.completion_time : "00:00:00")
      # Calculate the task completion time
      if task_completion_time && associated_task
        total_minutes += task_completion_time.hour * 60 
        total_minutes += task_completion_time.min
      end
    end
    total_minutes
  end
  
end