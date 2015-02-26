class Availability
  attr_accessor :data

  def initialize(hotel, dates, options = {})
    start_time = Time.now

    @hotel = hotel
    @dates = dates
    @begin_date = dates[0]
    @end_date = dates[dates.count - 1]

    rate_ids = options[:rates].map(&:id) if options[:rates]
    room_type_ids = options[:room_types].map(&:id) if options[:room_types]

    total_daily_instances = @hotel.daily_instances

    # Get the inhouse daily instances for the requested date
    inhouse_daily_instances = total_daily_instances.inhouse_between(@begin_date, @end_date).group(:reservation_date)

    # Get the adults, children and infants count for the given date
    inhouse_adults_count = inhouse_daily_instances.sum(:adults)
    inhouse_children_count = inhouse_daily_instances.sum(:children)
    inhouse_infants_count = inhouse_daily_instances.sum(:infants)

    hotel_reservations = hotel.reservations

    # Get the actual departure room count on requested date
    departed = hotel_reservations.due_out_actual_between(@begin_date, @end_date).group(:dep_date).count

    # Get the expected departure room count on requested date
    departing = hotel_reservations.due_out_expected_between(@begin_date, @end_date).group(:dep_date).count

    # Get the actual arrival room count on requested date
    arrived = hotel_reservations.due_in_actual_between(@begin_date, @end_date).group(:arrival_date).count

    # Get the expected arrival room count on requested date
    arriving = hotel_reservations.due_in_between(@begin_date, @end_date).group(:arrival_date).count

    # Get all the daily instances for the requested date
    daily_instances = total_daily_instances.active_between(@begin_date, @end_date)

    # Get the total room revenue for this date
    total_room_revenue = daily_instances.group(:reservation_date).sum(:rate_amount)

    # Get the average daily rate for this date
    average_daily_rate = daily_instances.group(:reservation_date).average(:rate_amount)

    # Get the inventory details and sell limits for this date
    inventory_details = @hotel.inventory_details.between_dates(@begin_date, @end_date)
    sell_limits = @hotel.sell_limits.between_dates(@begin_date, @end_date)

    physical_count = @hotel.rooms.exclude_pseudo_and_suite.count
    out_of_order = @hotel.rooms.exclude_pseudo.out_of_order_between(@begin_date, @end_date).group(:date).count
    room_type_out_of_order = @hotel.rooms.exclude_pseudo.out_of_order_between(@begin_date, @end_date).group(:room_type_id).count
    
    # Since end date is not a stay date, it should not be considered in the count for stay lengthputs unless the reservation is a day use. 
    stay_length = (@begin_date == @end_date) ? dates.count : (dates.count - 1)

    @options = options.merge(physical_count: physical_count, out_of_order: out_of_order, room_type_out_of_order: room_type_out_of_order,
                             stay_length: stay_length, business_date: @hotel.active_business_date, begin_date: @begin_date, end_date: @end_date,
                             inhouse_adults_count: inhouse_adults_count, inhouse_children_count: inhouse_children_count,
                             inhouse_infants_count: inhouse_infants_count, departed: departed, departing: departing, arrived: arrived,
                             arriving: arriving, total_room_revenue: total_room_revenue, average_daily_rate: average_daily_rate,
                             inventory_details: inventory_details, sell_limits: sell_limits)

    if options[:rates] && options[:room_types]
      room_rate_restrictions = RoomRateRestriction.between_dates(@begin_date, @end_date).where(rate_id: rate_ids)
      rate_restrictions = RateRestriction.where(rate_id: rate_ids)

      rate_room_types = RatesRoomType.where(rate_id: rate_ids)

      rate_date_range_counts = RateDateRange.where('begin_date <= ? and end_date >= ?', @begin_date, @end_date)
        .where(rate_id: rate_ids).group(:rate_id).count

      room_rates = RoomRate.between_dates(@begin_date, @end_date).where('room_rates.room_type_id' => room_type_ids)
        .where('rate_date_ranges.rate_id' => rate_ids)

      room_custom_rates = RoomCustomRate.between_dates(@begin_date, @end_date).where(room_rate_id: room_rates.map(&:id))

      @options = @options.merge(room_rate_restrictions: room_rate_restrictions, rate_restrictions: rate_restrictions,
                                rate_room_types: rate_room_types, rate_date_range_counts: rate_date_range_counts, room_rates: room_rates,
                                room_custom_rates: room_custom_rates)
    end

    process

    duration = Time.now - start_time
    logger.debug("Availability duration: #{duration}")
  end

  def process
    self.data = @dates.map.with_index { |date, i| DateAvailability.new(@hotel, date, i, @options).data }
  end

  def house?
    data.select { |result| result[:house][:availability] > 0 }.present?
  end

  def room_type?(room_type)
    data.select do |result|
      result[:room_types].select { |result_room_type| result_room_type[:id] == room_type.id }.andand.first[:availability] > 0
    end.present?
  end

  def restrictions
    restrictions = []

    data.each do |result|
      result[:rates].each do |rate|
        rate[:room_rates].each do |room_rate|
          restrictions += room_rate[:restrictions]
        end
      end
    end

    restrictions.uniq
  end

  def applicable_restrictions(current_arrival_date = nil, current_departure_date = nil)
    restrictions = []
    data.each do |result|
      date = result[:date]
      result[:rates].each do |rate|
        rate[:room_rates].each do |room_rate|
          room_rate[:restrictions].each do |restriction|
            restrictions << restriction if applicable?(restriction, date, current_arrival_date, current_departure_date)
          end
        end
      end
    end
    restrictions
  end

  def applicable?(restriction, date, current_arrival_date = nil, current_departure_date = nil)
    restriction_type = Ref::RestrictionType[restriction[:restriction_type_id]]

    is_existing = !current_departure_date.nil?

    is_extending = is_existing && @begin_date <= current_arrival_date && @end_date >= current_departure_date
    is_shortening = is_existing && @begin_date >= current_arrival_date && @end_date <= current_departure_date

    return true if restriction_type === :CLOSED_ARRIVAL && @begin_date == date && @begin_date != current_arrival_date

    return true if restriction_type === :CLOSED_DEPARTURE && @end_date == date && @end_date != current_departure_date

    return true if restriction_type === :MIN_STAY_LENGTH && !is_extending && @end_date - @begin_date < restriction[:days]

    return true if  restriction_type === :MAX_STAY_LENGTH && !is_shortening && @end_date - @begin_date > restriction[:days]

    return true if  restriction_type === :MIN_STAY_THROUGH && !is_extending && @end_date - date < restriction[:days]

    return true if  restriction_type === :CLOSED  && !is_shortening

    false
  end

  def shorten_stay_restrictions(arrival_date_updated, dep_date_updated)
    restriction_types = [:MIN_STAY_LENGTH, :MIN_STAY_THROUGH]
    restriction_types << :CLOSED_ARRIVAL if arrival_date_updated
    restriction_types << :CLOSED_DEPARTURE if dep_date_updated

    restrictions.select { |restriction| Ref::RestrictionType[restriction[:restriction_type_id]] === restriction_types }
  end

  def lengthen_stay_restrictions(arrival_date_updated, dep_date_updated)
    restriction_types = [:CLOSED, :MAX_STAY_LENGTH]
    restriction_types << :CLOSED_ARRIVAL if arrival_date_updated
    restriction_types << :CLOSED_DEPARTURE if dep_date_updated

    restrictions.select { |restriction| Ref::RestrictionType[restriction[:restriction_type_id]] === restriction_types }
  end

  def house_between?(from_date, to_date)
    data.select { |result| from_date <= result[:date] && result[:date] <= to_date && result[:house][:availability] > 0 }.present?
  end

  def room_type_between?(room_type, from_date, to_date)
    data.select do |result|
      from_date <= result[:date] && result[:date] <= to_date &&
        result[:room_types].select { |result_room_type| result_room_type[:id] == room_type.id }.andand.first[:availability] > 0
    end.present?
  end
end
