class ViewMappings::CalendarMapping
  def self.map_availability_information(reservation, current_daily_instance, room_type, rate_code, calendar_data)
    {
      arrival_date: reservation.arrival_date,
      dep_date: reservation.dep_date,
      currency_code: reservation.hotel.default_currency.to_s,
      rate_desc: current_daily_instance.rate.andand.rate_desc,
      available_dates: get_available_dates(reservation, calendar_data, room_type, rate_code),
      current_business_date: reservation.hotel.active_business_date,
      reservation_status: ViewMappings::StayCardMapping.map_view_status(reservation,  reservation.hotel.active_business_date),
      reservation_id: reservation.id,
      has_multiple_rates: (reservation.daily_instances.exclude_dep_date.count(:rate_id, distinct: true) > 1).to_s
    }
  end

  def self.map_standalone_availability(reservation, data)
    current_daily_instance = reservation.current_daily_instance

    data.map do |date_availability|
      date = date_availability[:date]
      rate_list = []

      occupancy_list = date_availability[:room_types].map do |room_type_availability|
        room_type = RoomType.find(room_type_availability[:id])

        {
          room_type_code: room_type.room_type,
          total_available_rooms: room_type_availability[:availability]
        }
      end

      date_availability[:rates].each do |rate_availability|
        rate = Rate.find(rate_availability[:id])

        rate_availability[:room_rates].each do |room_rate|
          room_type = RoomType.find(room_rate[:room_type_id])

          rate_amount = rate.calculate_rate_amount(date, room_type, current_daily_instance.adults, current_daily_instance.children)

          rate_list << {
            room_type_code: room_type.room_type,
            rate_plan_code: rate.rate_code,
            rate_amount: rate_amount.andand.round(2).to_s,
            is_sr: rate.contracted? ? rate.is_rate_shown_on_guest_bill : rate.is_suppress_rate_on?
          }
        end
      end

      {
        calendar_date: date,
        rate_list: rate_list,
        occupancy_list: occupancy_list,
        restriction_list: []
      }
    end
  end

  # Gets the available dates to display on the calendar, including the rate amounts. If during the stay, always return date as available with current
  # rate.
  def self.get_available_dates(reservation, calendar_data, room_type, rate_code)
    # Format availability info for dates not during stay
    available_dates = availability_outside_of_stay(reservation, calendar_data, room_type, rate_code)

    # Add current stay dates as available with currently assigned rate amounts
    available_dates += availability_during_stay(reservation, calendar_data, room_type, rate_code)

    # Sort the dates
    available_dates.sort { |a, b| a[:date] <=> b[:date] }
  end

  # Get availability not during stay
  def self.availability_outside_of_stay(reservation, calendar_data, room_type, rate_code)
    available_after_stay_so_far = true
    available_last_night = false
    # Format availability info for dates not during stay
    outside_of_stay = calendar_data.select do |day|
      available = false

      available_tonight = available?(day, room_type, rate_code)

      if day[:calendar_date] < reservation.arrival_date
        # Before Stay - check tonight
        available = available_tonight
      elsif reservation.dep_date < day[:calendar_date]
        # After Stay - check last night - after first unavailable day after stay, all unavailable
        available = available_last_night && available_after_stay_so_far
        available_after_stay_so_far &&= available
      end

      # Set last night to tonight
      available_last_night = available_tonight

      available
    end

    outside_of_stay.map do |day|
      rate = day[:rate_list].select do |rate_info|
               rate_info[:room_type_code] == room_type.room_type && rate_info[:rate_plan_code] == rate_code
             end
      rate_amount = rate.first.andand[:rate_amount]
      is_sr = reservation.hotel.is_third_party_pms_configured? ? reservation.is_rate_suppressed : rate.first.andand[:is_sr]
      {
        date: day[:calendar_date],
        rate: rate_amount,
        is_sr: is_sr.to_s,
        restriction_list: minimum_length_of_stay(day, room_type, rate_code)
      }
    end
  end

  # Get availability during stay
  def self.availability_during_stay(reservation, calendar_data, room_type, rate_code)
    sr_rate_flag = reservation.is_rate_suppressed  if reservation.hotel.is_third_party_pms_configured?
    (reservation.arrival_date..reservation.dep_date).map do |stay_date|
      day = calendar_data.select { |calendar_day| calendar_day[:calendar_date] == stay_date }.first
      stay_daily_instance = reservation.daily_instances.find_by_reservation_date(stay_date)
      {
        date: stay_date,
        rate: stay_daily_instance.rate_amount.round(2).to_s,
        is_sr: sr_rate_flag ? sr_rate_flag.to_s : stay_daily_instance.sr_rate?.to_s,
        restriction_list: minimum_length_of_stay(day, room_type, rate_code)
      }
    end
  end

  # Check for availability
  def self.available?(day, room_type, rate_code)
    occupancy?(day, room_type) && !restrictions?(day, room_type, rate_code)
  end

  # Check for occupancy
  def self.occupancy?(day, room_type)
    day[:occupancy_list].select do |occupancy_info|
      occupancy_info[:room_type_code] == room_type.room_type
    end.first.andand[:total_available_rooms].to_i > 0
  end

  # Check for restrictions
  def self.restrictions?(day, room_type, rate_code)
    day[:restriction_list].select do |restriction_info|
      restriction_info[:room_type_code] == room_type.room_type && restriction_info[:rate_plan_code] == rate_code &&
        restriction_info[:restriction_type] == 'CLOSED'
    end.count > 0
  end

  # Get the minimum length of stay restriction
  def self.minimum_length_of_stay(day, room_type, rate_code)
    if day
      day[:restriction_list].select do |restriction_info|
        restriction_info[:room_type_code] == room_type.room_type && restriction_info[:rate_plan_code] == rate_code &&
          restriction_info[:restriction_type] == 'MINIMUM_LENGTH_OF_STAY'
      end
    end
  end
end
