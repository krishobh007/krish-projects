class Availability::DateAvailability
  attr_accessor :data

  def initialize(hotel, date, day_index, options = {})
    @hotel = hotel
    @date = date
    @day_index = day_index

    @stay_length = options[:stay_length]
    @advanced_booking = (date - options[:business_date]).to_i

    @rates = options[:rates] || []
    @room_types = options[:room_types] || []
    @override_restrictions = options[:override_restrictions] || false
    @physical_count = options[:physical_count] || 0
    @room_type_room_count = options[:room_type_room_count] || 0
    @out_of_order = options[:out_of_order][date] || 0
    @room_type_out_of_order = options[:room_type_out_of_order] || {}
    @house_only = options[:house_only] || false
    
    @is_rate_for_dashboard = options[:is_rate_for_dashboard] || false

    # Get the adults, children and infants count for the given date
    @inhouse_adults_count = options[:inhouse_adults_count][date] || 0
    @inhouse_children_count = options[:inhouse_children_count][date] || 0
    @inhouse_infants_count = options[:inhouse_infants_count][date] || 0

    # Total Guests Count
    @inhouse_guest_count = @inhouse_adults_count + @inhouse_children_count + @inhouse_infants_count

    # Get the actual departure room count on requested date
    @departed = options[:departed][date] || 0

    # Get the expected departure room count on requested date
    @departing = options[:departing][date] || 0

    # Get the actual arrival room count on requested date
    @arrived = options[:arrived][date] || 0

    # Get the expected arrival room count on requested date
    @arriving = options[:arriving][date] || 0

    # Get the total room revenue for this date
    @total_room_revenue = options[:total_room_revenue][date].to_f

    # Get the average daily rate for this date
    @average_daily_rate = options[:average_daily_rate][date].to_f

    # Get the inventory details and sell limits for this date
    @inventory_details = options[:inventory_details].select { |detail| detail.date == date }
    @sell_limits = options[:sell_limits].select { |limit| limit.from_date <= date && limit.to_date >= date }

    @room_rate_restrictions = options[:room_rate_restrictions].andand.select { |restriction| restriction.date == date }
    @rate_restrictions = options[:rate_restrictions]

    @rate_room_types = options[:rate_room_types]
    @rate_date_range_counts = options[:rate_date_range_counts]

    weekday = date.strftime('%A').downcase

    @room_rates = options[:room_rates].andand.select do |room_rate|
      rate_set = room_rate.rate_set
      date_range = rate_set.rate_date_range
      date_range.begin_date <= date && date_range.end_date >= date && rate_set[weekday]
    end

    @room_custom_rates = options[:room_custom_rates].andand.select { |room_custom_rate| room_custom_rate.date == date }

    # Capture User Submited BeginDate and EndDate
    # If this date range mataches, return the exact rate
    @begin_date = options[:begin_date]
    @end_date = options[:end_date]

    process
  end

  # Get the availability details for the date
  def process
    # debugger
    house_detail = process_house

    detail = { date: @date, house: house_detail }

    unless @house_only
      room_type_details = @room_types.map { |room_type| process_room_type(room_type) }
      rate_details = @rates.map { |rate| process_rate(rate, house_detail, room_type_details) }.compact

      detail.merge!(room_types: room_type_details, rates: rate_details)
    end

    self.data = detail
  end

  private

  # Get the availability details for the house
  def process_house
    sell_limit = @sell_limits.find { |limit| !limit.rate_id && !limit.room_type_id }.andand.to_sell
    sold = @inventory_details.sum(&:sold)
    availability = sell_limit ? sell_limit - sold : @physical_count - sold

    out_of_order = @out_of_order
    in_house = @inhouse_guest_count
    departed = @departed
    departing = @departing
    arrived = @arrived
    arriving = @arriving
    total_room_revenue = @total_room_revenue
    average_daily_rate = @average_daily_rate

    { sell_limit: sell_limit, sold: sold, availability: availability, out_of_order: out_of_order,
      in_house: in_house, departed: departed, departing: departing, arrived: arrived,
      arriving: arriving, total_room_revenue: total_room_revenue, average_daily_rate: average_daily_rate }
  end

  # Get the availability details for the room type
  def process_room_type(room_type)
    room_count = @room_type_room_count[room_type.id] || 0

    sell_limit = @sell_limits.find { |limit| limit.room_type_id == room_type.id && !limit.rate_id }.andand.to_sell
    sold = @inventory_details.select { |inv| inv.room_type_id == room_type.id }.sum(&:sold)
    availability = sell_limit ? sell_limit - sold : room_count - sold
    out_of_order = @room_type_out_of_order[room_type.id] || 0
    { id: room_type.id, sell_limit: sell_limit, sold: sold, availability: availability, out_of_order: out_of_order  }
  end

  # Get the availability details for the rate
  def process_rate(rate, house_detail, room_type_details)
    rate_sell_limit = @sell_limits.find { |limit| limit.rate_id == rate.id && !limit.room_type_id }.andand.to_sell
    rate_sold = @inventory_details.select { |inv| inv.rate_id == rate.id }.sum(&:sold)
    rate_availability = rate_sell_limit ? rate_sell_limit - rate_sold : house_detail[:availability]

    # Get all the restrictions for this rate and date
    room_rate_restrictions = @room_rate_restrictions.select { |restriction| restriction.rate_id == rate.id }
    rate_restrictions = @rate_restrictions.select { |restriction| restriction.rate_id == rate.id }
    room_types = @rate_room_types.select { |rate_room_type| rate_room_type.rate_id == rate.id }.map do |rate_room_type|
      @room_types.find { |room_type| room_type.id == rate_room_type.room_type_id }
    end.compact

    room_rates = []

    room_types.each do |room_type|
      # Get the rate restrictions that apply to this room type, including those defined at the rate level
      restrictions = room_rate_restrictions.select { |restriction| restriction.room_type_id == room_type.id } + rate_restrictions

      if @override_restrictions || !restricted?(restrictions)
        # Get the room rate details for the rate and room type
        room_rate = @room_rates.find do |room_rate_instance|
          rate_date_range = room_rate_instance.rate_set.rate_date_range
          room_rate_instance.room_type_id == room_type.id && rate_date_range.rate_id == rate.id
        end

        amounts = room_rate_amounts(room_rate)

        # Get the restriction details for the rate and room type
        restriction_details = restrictions.map { |restriction| { restriction_type_id: restriction.type_id, days: restriction.days } }

        room_type_availability = room_type_details.find { |room_type_detail| room_type_detail[:id] == room_type.id }.andand[:availability] || 0

        sell_limit = @sell_limits.find { |limit| limit.rate_id == rate.id && limit.room_type_id == room_type.id }.andand.to_sell
        sold = @inventory_details.select { |inv| inv.rate_id == rate.id && inv.room_type_id == room_type.id }.sum(&:sold)

        availability = sell_limit ? sell_limit - sold : [rate_availability, room_type_availability].min

        amounts.merge!(room_type_id: room_type.id, sell_limit: sell_limit, sold: sold, availability: availability,
                       restrictions: restriction_details)

        room_rates << amounts
      end
    end

    is_rate_present_for_this_date_range = @rate_date_range_counts[rate.id] && @rate_date_range_counts[rate.id] > 0

    room_rates.present? && is_rate_present_for_this_date_range ? { id: rate.id, room_rates: room_rates, charge_code_id: rate.charge_code_id } : nil
  end

  # Checks the restrictions against this date to determine if the availability is restricted
  def restricted?(restrictions)
    # Based on CICO-9301 - Best available rate for the day should remove closed restriction types only
    unless @is_rate_for_dashboard
      restrictions.find { |restriction| restriction.restricted?(@day_index, @stay_length, @advanced_booking) }.present?
    else
      restrictions.find { |restriction| restriction.closed? }.present?
    end
  end

  def room_rate_amounts(room_rate)
    values = {}

    if room_rate
      room_custom_rate = @room_custom_rates.find { |custom| custom.room_rate_id == room_rate.id }

      [:single_amount, :double_amount, :extra_adult_amount, :child_amount].each do |occupancy_type|
        values[occupancy_type] = room_custom_rate.andand[occupancy_type] || room_rate[occupancy_type]
      end
    end

    values
  end
end
