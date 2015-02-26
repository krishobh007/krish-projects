# Return the arrival guests
class ArrivalReport < GuestsReport
  def process
    # Default sort to NAME if no sort is provided
    @filter[:sort_field] = 'NAME' unless @filter[:sort_field]

    # Construct the initial query for reservations
    reservations = reservations_query(true, false, false)

    # Make sure that hourly reservations have an arrival and departure time
    reservations = reservations.where('arrival_time is not null and departure_time is not null') if @hotel.settings.is_hourly_rate_on

    # Filter arrival time
    if @filter[:from_time].present? || @filter[:to_time].present?
      conditions = []

      # For each date range between daylight savings time changes, offset the arrival_time by the UTC offset
      dst_date_ranges.each do |dst_date_range|
        conditions << dst_sql_condition(dst_date_range)
      end

      if conditions.present?
        query = conditions.map { |condition| "(#{condition})" }.join(' OR ')
        reservations = reservations.where(query, from_time: @filter[:from_time], to_time: @filter[:to_time])
      end
    else
      # Filter by the full date range if no times are entered
      reservations = reservations.where('? <= arrival_date and arrival_date <= ?', @filter[:from_date], @filter[:to_date])
        .where('reservation_daily_instances.reservation_date = arrival_date')
    end
    # Determine whether to include the canceled reservations or not
    # As per CICO-12468, list all reservations(except NOSHOW and CANCELED)
    # thats are arrving on the requested date range.
    # If we choose include_cancel filter, we should list both NOSHOW and CANCELED reservations.
    # Changing this requirement with story CICO-12518
    if @filter[:include_canceled] && @filter[:include_no_show]
      reservations = reservations
    elsif @filter[:include_no_show]
      reservations = reservations.exclude_status(:CANCELED)
    elsif @filter[:include_canceled]
      reservations = reservations.exclude_status(:NOSHOW)
    else
      reservations = reservations.exclude_status(:CANCELED, :NOSHOW)
    end

    # CICO-12639 filter based on company name travalagent and group
    if @filter[:include_companycard_ta_group].present?
      id = @filter[:include_companycard_ta_group]
      splited_id = id.split('_')
      key_id = splited_id[1].to_i
      key_term = splited_id[0].to_s
      if key_term == 'group'
        reservations = reservations.where('group_id = ?',key_id) if key_term.present?
      elsif key_term == 'account'
        reservations = reservations.where('company_id = ? or travel_agent_id = ?', key_id, key_id) if key_term.present?
      end
    end
    # Filter based on guarantee type

    # TODO: As a quick fix. Will remove later
    if @hotel.is_third_party_pms_configured?
      reservations = reservations.where('guarantee_type IN (?)', @filter[:include_guarantee_type]) if @filter[:include_guarantee_type].present?
      adr_amount  = 0
      reservations.each do |reservation|
        adr_amount += reservation.average_rate_amount.to_f
      end
    else
      reservations = reservations.joins(:reservation_type).where('description IN (?)', @filter[:include_guarantee_type]) if @filter[:include_guarantee_type].present?
      adr_amount  = 0
      reservations.each do |reservation|
        adr_amount += reservation.average_rate_amount.to_f
      end
    end
    total_room_count = reservations.where('room_id is not null').count
    reservations = reservations.page(@filter[:page]).per(@filter[:per_page])

     # Sort by arrival date if sort field is DATE
    reservations = reservations.order("arrival_date #{@sort_order}, arrival_time #{@sort_order}") if @filter[:sort_field] == 'DATE'
    output_report(reservations, adr_amount, total_room_count)
  end

  private

  # Get all sub date ranges for each daylight savings time switch
  def dst_date_ranges
    ranges = []

    from_date = nil
    to_date = nil
    previous_is_dst = nil
    utc_offset = nil

    (@filter[:from_date]..@filter[:to_date]).each do |date|
      Time.zone = @hotel.tz_info

      # Get the time object for the date at noon (as dst doesn't change until 2am)
      time = Time.zone.parse(date.to_s + ' 12:00:00')

      is_dst = time.dst?

      # Initialize the values if the date is the first in the list
      if date == @filter[:from_date]
        previous_is_dst = is_dst
        from_date = date
        to_date = date
        utc_offset = time.utc_offset
      end

      # If the previous date's dst indicator is not the same as this date's, then there is a time change and we want to create a new range
      if previous_is_dst != is_dst
        ranges << { from_date: from_date, to_date: to_date, utc_offset: utc_offset / 3600 }

        from_date = date
        to_date = date
        utc_offset = time.utc_offset
      else
        to_date = date
      end

      # If this date is the last in the list, then we want to add the last set of dates to the ranges
      ranges << { from_date: from_date, to_date: date, utc_offset: utc_offset / 3600 } if date == @filter[:to_date]

      previous_is_dst = is_dst
    end

    ranges
  end

  # Construct a SQL condition for the date range
  def dst_sql_condition(dst_date_range)
    dst_conditions = []

    if @filter[:from_time].present?
      dst_conditions << "time(arrival_time + INTERVAL #{dst_date_range[:utc_offset]} HOUR) >= time(:from_time)"
    end

    if @filter[:to_time].present?
      dst_conditions << "time(arrival_time + INTERVAL #{dst_date_range[:utc_offset]} HOUR) <= time(:to_time)"
    end

    dst_conditions << "'#{dst_date_range[:from_date]}' <= arrival_date and arrival_date <= '#{dst_date_range[:to_date]}' " \
                      "AND reservation_daily_instances.reservation_date = arrival_date"

    dst_conditions.join(' AND ')
  end
end
