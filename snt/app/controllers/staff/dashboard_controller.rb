class Staff::DashboardController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date, except: [:rover]
  
  def header_info
    @hotel = params[:hotel_code].present? ? Hotel.find_by_code(params[:hotel_code]) : current_hotel
    @is_late_checkout_on = @hotel.settings.late_checkout_is_on
    business_date = @hotel.active_business_date
    @late_checkout_count = @hotel.reservations.is_late_checkout(business_date).count if @is_late_checkout_on
    render json: {
      status: SUCCESS,
      data: {
        first_name: current_user.detail.first_name,
        last_name: current_user.detail.last_name,
        business_date: business_date,
        late_checkout_count: @late_checkout_count,
        logo: @hotel.icon.url,
        currency_code: @hotel.default_currency.andand.value
        },
      errors: []
    }
  end

  def index
    status,errors = FAILURE,[]
    if current_user.admin?
      errors << 'Access denied. No hotel selected'
    end
    @currentuser = current_user
    if current_user.hotel_admin?
      @current_user_type = 'hotel_admin'
    elsif current_user.hotel_staff?
      @current_user_type = 'hotel_staff'
    end
    if params[:hotel_code].present?
      @hotel = Hotel.find_by_code(params[:hotel_code])
    else
      @hotel = current_hotel
    end

    unless @hotel
      errors << 'Hotel name of current user not found in the database'
    end


    if errors.empty?
      business_date = @hotel.active_business_date
      @due_in_count =  Reservation.due_in_list(@hotel.id).count
      @due_out_count = Reservation.due_out_list(@hotel.id).count
      @inhouse_count = Reservation.inhouse_list(@hotel.id).count
      @vip_checkin_count = @hotel.vip_checkin_count(business_date)
      @guest_review_score = @hotel.average_review_score(business_date)

      @is_upsell_on = current_hotel.settings.upsell_is_on
      if @is_upsell_on
        @upsell_target = current_hotel.settings.upsell_total_target_amount
        @rooms_for_upsell = current_hotel.settings.upsell_total_target_rooms
        @actual_upsell = @hotel.total_upsell_revenue(business_date)
        @rooms_upsold = @hotel.total_upsell_rooms_sold(business_date)
      end

      @is_late_checkout_on = @hotel.settings.late_checkout_is_on
      @late_checkout_count = @hotel.reservations.is_late_checkout(business_date).count if @is_late_checkout_on
      @is_queue_rooms_on = @hotel.settings.is_queue_rooms_on
      @queued_rooms_count = @hotel.reservations.queued(business_date).count if @is_queue_rooms_on
      status = SUCCESS
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {
          status: SUCCESS,
          data: {
            due_in_count: @due_in_count,
            due_out_count: @due_out_count,
            inhouse_count: @inhouse_count,
            upsell_target: @upsell_target,
            rooms_for_upsell: @rooms_for_upsell,
            actual_upsell: @actual_upsell,
            rooms_upsold: @rooms_upsold,
            vip_checkin_count: @vip_checkin_count,
            guest_review_score: @guest_review_score,
            is_upsell_on: @is_upsell_on
          }
        }
      }
    end
  end

  def rover
    render layout: false
  end

  def dashboard
    @currentuser = current_user
    @hotel = current_hotel

    business_date = @hotel.active_business_date

    @due_in_count =  Reservation.due_in_list(@hotel.id).count
    @due_out_count = Reservation.due_out_list(@hotel.id).count
    @inhouse_count = Reservation.inhouse_list(@hotel.id).count
    @vip_checkin_count = @hotel.vip_checkin_count(business_date)
    @guest_review_score = @hotel.average_review_score(business_date)

    @is_upsell_on = @hotel.settings.upsell_is_on

    if @is_upsell_on
      @upsell_target = @hotel.settings.upsell_total_target_amount
      @actual_upsell = @hotel.total_upsell_revenue(business_date)
      @rooms_upsold = @hotel.total_upsell_rooms_sold(business_date)
      @rooms_for_upsell = @hotel.settings.upsell_total_target_rooms
    end

    @is_late_checkout_on = @hotel.settings.late_checkout_is_on
    @late_checkout_count = @hotel.reservations.is_late_checkout(business_date).count if @is_late_checkout_on
    @is_queue_rooms_on = @hotel.settings.is_queue_rooms_on
    @queued_rooms_count = @hotel.reservations.queued(business_date).count if @is_queue_rooms_on
        
    @currency_code = @hotel.default_currency.andand.value
    render layout: false
  end

  # def search
  # render :layout => false
  # end

  # TODO
  # This method will call to get the details of guest based on the clicking of the status box in the dashboard
  # After merging branch cico-373 into devlopment, this method will placed into reservation controller code.
  def due_in_status_list
    @hotel = Hotel.find_by_code(params[:hotel_code])
    unless @hotel
      fail 'Hotel name not found in the database'
    end
    @due_in_status =  Reservation.due_in_list(@hotel.id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { message: @due_in_status, status: true } }
    end
  end

  def inhouse_status_list
    @hotel = Hotel.find_by_code(params[:hotel_code])
    unless @hotel
      fail 'Hotel name not found in the database'
    end
    @inhouse_status = Reservation.inhouse_list(@hotel.id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { message: @inhouse_status, status: true } }
    end
  end

  def due_out_status_list
    @hotel = Hotel.find_by_code(params[:hotel_code])
    unless @hotel
      fail 'Hotel name not found in the database'
    end
    @due_out_status = Reservation.due_out_list(@hotel.id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { message: @due_out_status, status: true } }
    end
  end

  # Returns whether late checkout is enabled and if so, the late checkout count
  def late_checkout_count
    is_late_checkout_on = current_hotel.settings.late_checkout_is_on
    late_checkout_count = is_late_checkout_on ? current_hotel.reservations.is_late_checkout(current_hotel.active_business_date).count : 0

    render json: {
      status: SUCCESS,
      data: { is_late_checkout_on: is_late_checkout_on, late_checkout_count: late_checkout_count },
      errors: []
    }
  end
end
