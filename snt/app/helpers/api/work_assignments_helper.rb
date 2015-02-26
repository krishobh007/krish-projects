module Api
  module WorkAssignmentsHelper
    def get_time_allocated(date, room, work_type)
      hotel = room.hotel
      
      system_defined_work_types = hotel.work_types.where(is_system: true)
      tasks = system_defined_work_types.first.andand.tasks
      system_defined_tasks = tasks.where(is_system: true) if tasks
      # Set the departure room completion for the hotel as the default completion time - CICO-10457.
      default_completion_time = system_defined_tasks.first.andand.completion_time.andand.
                                strftime("%H:%M") if system_defined_tasks
      
      # In case if default time is nil, handle the case
      completion_time = default_completion_time ? default_completion_time : "00:00"

      return completion_time if work_type.nil?

      task = get_task_for_room_on(date, room, work_type)
      
      # Set associated task as the departure task by default, if there is no associated task found for a room
      task = hotel.work_type_tasks.joins(:ref_reservation_hk_statuses)
                  .where("ref_reservation_hk_status_id = ?", 
                  Ref::ReservationHkStatus[:DEPARTED].id).first unless task.present?
                  
      # Get the completion time for the room type, if specified - CICO-10172 Point #11 
      room_type_completion_time = task.room_type_tasks.
                                  where(room_type_id: room.room_type_id).first.andand.
                                  completion_time.andand.strftime("%H:%M") if task.present?
      
      if room_type_completion_time.present?
        time = room_type_completion_time
      else
        time = task.nil? ? completion_time : (task.completion_time.blank? ? completion_time : task.completion_time.strftime("%H:%M"))
      end
      
      time
    end

    def get_reservation(room, date, is_business_date)
      reservations = room.room_reservations

      reservation = reservations.first
      due_in_reservation = reservations.count == 2 ? reservations.last : nil

      data = {}
      data[:id] = room.id
      data[:room_no] = room.room_no
      data[:current_status] = room.hk_status.to_s
      data[:checkin_time] = due_in_reservation.andand.arrival_time.andand.strftime('%I:%M %P')
      data[:checkout_time] = reservation.andand.departure_time.andand.strftime('%I:%M %P')
      data[:room_type] = room.room_type_id
      data[:is_vip] = reservation.andand.primary_guest.andand.is_vip?
      data[:floor_number] = room.andand.floor.andand.floor_number
      data[:is_queued] = reservation.andand.is_queued? || due_in_reservation.andand.is_queued?
      data[:reservation_status] = is_business_date ? room.andand.front_office_status.to_s : room.andand.front_office_status_on(date).to_s
      data[:fo_status] = room.andand.is_occupied ? Ref::FrontOfficeStatus[:OCCUPIED].value : Ref::FrontOfficeStatus[:VACANT].value
      data
    end

    def assignment_completed?(assignment)
      !(assignment.begin_time.blank? || assignment.end_time.blank?)
    end

    #This is a helper function for get_task_for_room_on
    # This is not written in Room model, as it uses a work_around
    def deduce_reservation_hk_status(room, date)
      #ToDO: Handle multile reservation situation properly
      # Currently using first, as task assignment considers only on reservation's hk status
      reservation = room.room_reservations_on(date).first

      if !reservation.present?
        return Ref::ReservationHkStatus[:NOT_RESERVED].id
      end

      business_date = current_hotel.active_business_date
      arrival_date = reservation.arrival_date
      departure_date = reservation.dep_date
      current_reservation_status = reservation.status

      if arrival_date == business_date && current_reservation_status === :RESERVED
        return Ref::ReservationHkStatus[:ARRIVALS].id
      end

      if arrival_date == business_date && current_reservation_status === :CHECKEDIN
        return Ref::ReservationHkStatus[:ARRIVED].id
      end

      if departure_date == business_date && current_reservation_status === :CHECKEDIN
        return Ref::ReservationHkStatus[:DUEOUT].id
      end

      if current_reservation_status === :CHECKEDIN
        return Ref::ReservationHkStatus[:STAYOVER].id
      end

      if current_reservation_status === :CHECKEDOUT
        return Ref::ReservationHkStatus[:DEPARTED].id
      end

      return Ref::ReservationHkStatus[:NOT_RESERVED].id

      #ToDo : Handle Hourly reservation status cases.

    end

    def get_task_for_room_on(date, room, work_type)
      # Produces one HK status id, or blank if no reservation

      reservation_hk_status_id = deduce_reservation_hk_status(room, date)

      tasks = work_type.tasks.joins(:room_type_tasks).where("room_type_tasks.room_type_id = ?", room.room_type_id)

      applicable_tasks = []

      tasks.each do |task|
         task_hk_status_ids = task.ref_reservation_hk_statuses.pluck(:id).uniq
         if reservation_hk_status_id and task_hk_status_ids.include?(reservation_hk_status_id)
           applicable_tasks.append(task)
         end
      end
      #TODO : Need a better logic
      return applicable_tasks.first
    end

  end
end
