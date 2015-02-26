class StaffHouseKeeping::DashboardController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  
  layout false
  def index
    # Redirecting always to staff root for common dahsboard - 6612, 6613, 5250
    redirect_to staff_root_path

    status, data, errors = FAILURE, {}, []
    if !current_hotel || current_user.admin?
      errors <<  'Access denied. No hotel selected'
      render json: { status: status, error: errors, data: data }
    else

      business_date = current_hotel.active_business_date

      due_in_count =  Reservation.due_in_list(current_hotel.id).count
      due_out_count = Reservation.due_out_list(current_hotel.id).count
      inhouse_count = Reservation.inhouse_list(current_hotel.id).count

      # List In house Rooms
      in_house_rooms_count = current_hotel.rooms.exclude_pseudo_and_suite.in_house(business_date).uniq.count

      # List of Dueout Rooms
      due_out_rooms_count = current_hotel.rooms.exclude_pseudo_and_suite.due_out(business_date).uniq.count

      # List of Vacant-Clean& Inspected(Empty) Rooms
      vacant_clean_rooms_count =  current_hotel.rooms.exclude_pseudo_and_suite.with_hk_status(:CLEAN, :INSPECTED).where(is_occupied: false).count

      # List of Vacant-Dirty& PICKUP( Empty but still Dirty)
      vacant_dirty_rooms_count = current_hotel.rooms.exclude_pseudo_and_suite.with_hk_status(:DIRTY, :PICKUP).where(is_occupied: false).count

      # List of Out of Order/Out Of Service Rooms
      out_of_order_rooms_count = current_hotel.rooms.exclude_pseudo_and_suite.with_hk_status(:OO, :OS).count

      resultant_count = {}

      resultant_count[:due_in_count] =  due_in_count
      resultant_count[:due_out_count] =  due_out_count
      resultant_count[:inhouse_count] =  inhouse_count
      resultant_count[:currency_code] =  current_hotel.default_currency.value

      resultant_count[:occupied] =  in_house_rooms_count.to_i + due_out_rooms_count.to_i
      resultant_count[:vacant_clean_room_count] =  vacant_clean_rooms_count
      resultant_count[:vacant_dirty_room_count] =  vacant_dirty_rooms_count
      resultant_count[:out_of_order_rooms_count] =  out_of_order_rooms_count
      # status = SUCCESS

      # Commenting the followin lines of code 
      # for common dashboard for HK APP - 6612, 6613, 5250
      # respond_to do |format|
      #   format.html # index.html.erb
      #   format.json { render json: { status: status, error: errors, data: resultant_count } }
      # end

    end
  end

  def settings
    render layout: false
  end
end
