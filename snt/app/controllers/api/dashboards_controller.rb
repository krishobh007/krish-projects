class Api::DashboardsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info

  def index
    fail 'Access denied. No hotel selected' if current_user.admin?
    @hotel = params[:hotel_code].present? ? Hotel.find_by_code(params[:hotel_code]) : current_hotel
    fail 'Hotel name of current user not found in the database' unless @hotel
    fail 'Default dashboard not set for the Users' unless current_user.default_dashboard

    @business_date = @hotel.active_business_date
    if @hotel.pms_start_date.present?
      total_days_in_month = (@business_date - @hotel.month_start_date_based_on_pms_start_date) > 0 ? (@business_date - @hotel.month_start_date_based_on_pms_start_date).to_i : 0
      total_days_in_year = (@business_date - @hotel.year_start_date_based_on_pms_start_date) > 0 ? (@business_date - @hotel.year_start_date_based_on_pms_start_date).to_i : 0
      total_days_in_month += 1
      total_days_in_year += 1
    end

    # Total days in current month should be the current business date/ pms date day number
    total_days_in_current_month =  @hotel.pms_start_date.present?  ? total_days_in_month : @business_date.day
    total_days_in_current_year = @hotel.pms_start_date.present?  ? total_days_in_year : ((@business_date == @business_date.at_beginning_of_year) ? 1 : (@business_date -  @business_date.at_beginning_of_year).to_i)
    # Guests Count
    @default_dashboard = current_user.default_dashboard

    # Check for is Hourly Reservation Enabled for the Hotel.
    is_hourly_rate_enabled_for_hotel = current_hotel.settings.is_hourly_rate_on
    if is_hourly_rate_enabled_for_hotel
      # All reservations arriving for the 24 hour period of the day,
      # As per the defect CICO- 12464, we will consider todays Current Business date EOD time  next day EOD time
      # If hotel doent enable EOD, we will take current system time.
      is_eod_enabled = current_hotel.settings.is_auto_change_bussiness_date && current_hotel.settings.business_date_change_time.present?

      if is_eod_enabled
        current_eod_time = current_hotel.settings.business_date_change_time.in_time_zone(current_hotel.tz_info)

        # We will list arrivals of curent EOD time to next day EOD time.
        begin_time = getDatetime(@business_date, current_eod_time, current_hotel.tz_info).utc
        end_time = begin_time + 24.hours
      else
        begin_time = getDatetime(@business_date, '00:00', current_hotel.tz_info).utc
        end_time = getDatetime(@business_date, '23:59', current_hotel.tz_info).utc
      end


      checking_in_reservation =  @hotel.reservations.due_in_within_24hours(begin_time, end_time)
      # CHECKEDIN Reservations which are departing within 1 hour
      current_business_date_time = getDatetime(@business_date, Time.now.utc, current_hotel.tz_info) + 1.hour
      checking_out_reservation = @hotel.reservations.due_out_within_one_hour(@business_date, current_business_date_time)

      # CHECKEDIN & and Reservations which are NOT departing within One hour.
      in_house_reservation = @hotel.reservations.in_house_not_departing_one_hour(@business_date, current_business_date_time)
    else
      checking_in_reservation =  @hotel.reservations.due_in(@business_date)
      checking_out_reservation = @hotel.reservations.due_out(@business_date)
      in_house_reservation = @hotel.reservations.in_house(@business_date)
    end
    @checking_in_count = checking_in_reservation.count
    @checking_out_count = checking_out_reservation.count
    @in_house_count = in_house_reservation.count

    @pre_checkin_count = @hotel.reservations.pre_checkin(@business_date).count
    @is_precheckin_only = @hotel.settings.is_pre_checkin_only

    @vip_checkin_count = checking_in_reservation.vip_only.count +  checking_out_reservation.vip_only.count + in_house_reservation.vip_only.count
    # @guest_review_score = @hotel.average_review_score(business_date)

     # Upsell Count
    @is_upsell_on = @hotel.settings.upsell_is_on
    if @is_upsell_on
      @upsell_target = @hotel.settings.upsell_total_target_amount
      @actual_upsell = @hotel.total_upsell_revenue(@business_date)
    end
    @is_late_checkout_on = @hotel.settings.late_checkout_is_on
    @late_checkout_count = @hotel.reservations.is_late_checkout(@business_date).count if @is_late_checkout_on
    # Occupancy - Today, Tomorrow, Day after Tomorrow, current month, current year - Begin

    # Total Rooms for the current hotel - excluding pseudo & suit room type.
    total_physical_rooms = @hotel.rooms.exclude_pseudo_and_suite
    total_physical_rooms_count = total_physical_rooms.count

    hotel_daily_instances = @hotel.daily_instances

    # Occupancy -- End
    if @default_dashboard  === :MANAGER || @default_dashboard  === :FRONT_DESK
      total_daily_instance_count_for_today =  hotel_daily_instances.active_between(@business_date, @business_date)
      total_daily_instance_count_for_tomorrow = hotel_daily_instances.active_between(@business_date + 1.day, @business_date + 1.day)
      total_daily_instance_count_for_day_after_tomorrow = hotel_daily_instances.active_between(@business_date + 2.days, @business_date + 2.days)

      total_daily_instance_count_for_current_month = hotel_daily_instances.active_between(@hotel.month_start_date_based_on_pms_start_date, @business_date)
      total_daily_instance_count_for_current_year = hotel_daily_instances.active_between(@hotel.year_start_date_based_on_pms_start_date, @business_date)
      

      total_occupancy_for_today =  total_daily_instance_count_for_today.count
      total_occupancy_for_tomorrow = total_daily_instance_count_for_tomorrow.count
      total_occupancy_for_day_after_tomorrow = total_daily_instance_count_for_day_after_tomorrow.count
      total_occupancy_for_current_month = total_daily_instance_count_for_current_month.count
      total_occupancy_for_current_year = total_daily_instance_count_for_current_year.count

      if total_physical_rooms_count > 0
        @occupancy_today = (total_occupancy_for_today.fdiv(total_physical_rooms_count) * 100)
        @occupancy_tomorrow = (total_occupancy_for_tomorrow.fdiv(total_physical_rooms_count) * 100)
        @occupancy_day_after_tomorrow = (total_occupancy_for_day_after_tomorrow.fdiv(total_physical_rooms_count) * 100)
        @occupancy_current_month =  (total_occupancy_for_current_month.fdiv(total_physical_rooms_count * total_days_in_current_month) * 100)
        @occupancy_current_year = (total_occupancy_for_current_year.fdiv(total_physical_rooms_count * total_days_in_current_year) * 100) 
      end

      # ADR Calcualtion - BEGIN
      unless is_hourly_rate_enabled_for_hotel
        @adr_for_today =  total_daily_instance_count_for_today.average(:rate_amount).to_f
        @adr_for_tomorrow = total_daily_instance_count_for_tomorrow.average(:rate_amount).to_f
        @adr_for_day_after_tomorrow = total_daily_instance_count_for_day_after_tomorrow.average(:rate_amount).to_f

        @adr_for_current_month = !total_daily_instance_count_for_current_month.empty? ? (total_daily_instance_count_for_current_month.average(:rate_amount).to_f / total_days_in_current_month) : 0.0

        @adr_for_current_year = !total_daily_instance_count_for_current_year.empty? ? (total_daily_instance_count_for_current_year.average(:rate_amount).to_f / total_days_in_current_year) : 0.0
      end  
      # ADR Calcualtion - END
      # Rate of the Today, Tomorrow & Day after Tomorrow Calculation - BEGIN
      unless @hotel.is_third_party_pms_configured?
        if is_hourly_rate_enabled_for_hotel
          min_rate_hash = min_rate_hash_hourly = find_min_amount(is_hourly_rate_enabled_for_hotel)
          @today = mapped_rate(@business_date, min_rate_hash)
          @tomorrow = mapped_rate(@business_date + 1.day, min_rate_hash)
          @day_after_tomorrow = mapped_rate(@business_date + 2.day, min_rate_hash)

        else
          min_rate_hash = find_min_amount
          @today = mapped_rate(@business_date, min_rate_hash)
          @tomorrow = mapped_rate(@business_date + 1.day, min_rate_hash)
          @day_after_tomorrow = mapped_rate(@business_date + 2.day, min_rate_hash)
       end
      end
      # Rate of the Today, Tomorrow & Day after Tomorrow Calculation - END
    end

    # Room Details - For Manager and House keeping dashboard - BEGIN
    if @default_dashboard  === :MANAGER || @default_dashboard  === :HOUSEKEEPING
      # Room Count - BEGIN

      # List of occupied rooms in the current_hotel
      @total_occupied_rooms = total_physical_rooms.where(is_occupied: true).count

      # List of Vacant-CLEAN & INSPECTED
      @total_vacant_ready = total_physical_rooms.with_hk_status(:CLEAN, :INSPECTED).where(is_occupied: false).count

      # List of Vacant-Dirty& PICKUP( Empty but still Dirty)
      @total_vacant_not_ready_rooms_count = total_physical_rooms.with_hk_status(:DIRTY, :PICKUP).where(is_occupied: false).count

      # List of Out of Order/Out Of Service Rooms - Updated as a part of HK story CICO-8620
      # TODO for Pms-Connected hotels
      # if current_hotel.is_third_party_pms_configured?
        # @out_of_order_rooms_count = total_physical_rooms.with_hk_status(:OO, :OS).count
      # else
        @out_of_order_rooms_count = total_physical_rooms.inactive_between(@business_date, @business_date).count
      # end

    end
    # Room Details - For Manager and House keeping dashboard - END

    # Additonal details - Only for Front Desk User - BEGIN
    if @default_dashboard  === :HOUSEKEEPING
      # List In house Rooms - DIRTY
      @stay_over_dirty_rooms_count = total_physical_rooms.with_hk_status(:DIRTY).stay_over_on(@business_date).uniq.count

      # List In house Rooms - CLEAN
      @stay_over_clean_room_count = total_physical_rooms.with_hk_status(:CLEAN).stay_over_on(@business_date).uniq.count

      # List of Dueout Rooms - DIRTY
      @dirty_due_out_rooms_count = total_physical_rooms.with_hk_status(:DIRTY).due_out_checked_out(@business_date).uniq.count

      # List of Dueout Rooms - CLEAN
      @clean_due_out_rooms_count = total_physical_rooms.with_hk_status(:CLEAN).due_out_checked_out(@business_date).uniq.count

      current_hotel_reservations = @hotel.reservations
      # List of all arrivalls room count
      @arrivals = arrivals(current_hotel_reservations, @business_date)

      # List of all stay over room count
      @stay_over = stay_over(current_hotel_reservations, @business_date)

      # List of all departure/Departed room count
      @departures = departure(current_hotel_reservations, @business_date)
    end
    # Additonal details - Only for Front Desk User - END
  end

    # Return Lowest Rate & Rate Name - BEGIN

  private

  def find_min_amount(is_hourly = false)
    if is_hourly
      @rates = @hotel.rates.active.fully_configured.include_public_only.not_expired(@business_date).non_contract.where(is_hourly_rate: true)
    else
      @rates = @hotel.rates.active.fully_configured.include_public_only.not_expired(@business_date).non_contract
    end
    @room_types = @hotel.room_types.is_not_pseudo
    @room_type_room_count = current_hotel.rooms.exclude_pseudo.group(:room_type_id).count
    # Based on CICO-9301 - For dashboard screen, the rate for the day will remove only CLOSED restrictions
    # To let the availability model know the call is from dashboard, we are setting a flag here
    @is_rate_for_dashboard = true

    options = { rates: @rates, room_types: @room_types, business_date: @business_date, room_type_room_count: @room_type_room_count, is_rate_for_dashboard: @is_rate_for_dashboard }


    date_availability = Availability.new(@hotel, (@business_date .. @business_date + 2.days).to_a, options).process

    resultant_hash = {}
    min_single_rate = {}
    date_availability.each do |each_date|
      date = each_date[:date]
      min_single_rate = calculate_min_amount_on_each_rate(each_date)

    # Found the lowest room_rate amount from Rate
    # Sorting this hash array and taking the first rate_id, rate_amount, room_type_id
      resultant_hash[date] =  min_single_rate.sort_by(&:last).first if min_single_rate
    end
    resultant_hash
  end

  def room_type_available?(date_availability, room_type_id)
    date_availability.select do |result|
      result[:room_types].select { |result_room_type| result_room_type[:id] == room_type_id }.andand.first[:availability] > 0
    end.present?
  end

  def calculate_min_amount_on_each_rate(each_date)
    min_rate_hash = {}
    each_date[:rates].each do |rate|
      rate_id = rate[:id]
      single_room_rate_hash = find_availability_non_zero_room_rate(rate[:room_rates]).min { |a, b| a[:single_amount] <=> b[:single_amount] }

      min_rate_hash[rate_id] = single_room_rate_hash.values[0] if single_room_rate_hash
    end
    min_rate_hash
  end

  def mapped_rate(business_date, min_amount_hash)
    if min_amount_hash[business_date]
      rate_id = min_amount_hash[business_date][0]
      rate_amount = min_amount_hash[business_date][1]
      rate = Rate.find(rate_id)
      {
        rate: rate,
        amount: rate_amount
      }
    end
  end

  def find_availability_non_zero_room_rate(room_rates_array)
    availability_non_zero = []
    room_rates_array.each do | room_rate |
      availability_non_zero << room_rate if room_rate[:availability] > 0 && room_rate[:single_amount]
    end
    # Get the min single hash  from room rate array  with availability > 0
    availability_non_zero
  end

  def arrivals(reservations, business_date)
    today = reservations.arrival_on(business_date)
    tomorrow = reservations.arrival_on(business_date + 1.day)
    day_after_tomorrow = reservations.arrival_on(business_date + 2.days)
    {
      today: today.count,
      tomorrow: tomorrow.count,
      day_after_tomorrow: day_after_tomorrow.count
    }
  end

  def stay_over(reservations, business_date)
    today = reservations.stay_over_on(business_date)
    tomorrow = reservations.stay_over_on(business_date + 1.day)
    day_after_tomorrow = reservations.stay_over_on(business_date + 2.days)
    {
      today: today.count,
      tomorrow: tomorrow.count,
      day_after_tomorrow: day_after_tomorrow.count
    }
  end

  def departure(reservations, business_date)
    today = reservations.departure_on(business_date)
    tomorrow = reservations.departure_on(business_date + 1.day)
    day_after_tomorrow = reservations.departure_on(business_date + 2.days)
    {
      today: today.count,
      tomorrow: tomorrow.count,
      day_after_tomorrow: day_after_tomorrow.count
    }
  end

  def getDatetime(date, time, tz_info)
    ActiveSupport::TimeZone[tz_info].parse(date.to_s + ' ' + time.to_s)
  end
end
