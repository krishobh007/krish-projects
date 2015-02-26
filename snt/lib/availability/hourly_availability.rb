class HourlyAvailability
  attr_accessor :data
  def initialize(hotel, options = {})
    @current_hotel = hotel
    physical_count = @current_hotel.rooms.exclude_pseudo_and_suite.count
    out_of_order = @current_hotel.rooms.exclude_pseudo.out_of_order_between(@begin_date, @end_date).group(:date).count
    room_type_out_of_order = @current_hotel.rooms.exclude_pseudo.out_of_order_between(@begin_date, @end_date).group(:room_type_id).count
    @begin_date = options[:begin_date]
    @end_date = options[:end_date]
    @begin_hour = options[:begin_time]
    @end_hour = options[:end_time]
    rate_ids = options[:rates].map(&:id) if options[:rates]
    room_type_ids = options[:room_types].map(&:id) if options[:room_types]

    @options = options.merge(physical_count: physical_count, out_of_order: out_of_order, 
                             room_type_out_of_order: room_type_out_of_order,
                             business_date: @current_hotel.active_business_date,
                             begin_date: @begin_date, end_date: @end_date)
    # if options[:rates] && options[:room_types]
    rate_room_types = RatesRoomType.where(rate_id: rate_ids)
    rate_date_range_counts = RateDateRange.where('begin_date <= ? and end_date >= ?', @begin_date, @end_date)
        .where(rate_id: rate_ids).group(:rate_id).count

    room_rates = RoomRate.between_dates(@begin_date, @end_date).where('room_rates.room_type_id' => room_type_ids)
        .where('rate_date_ranges.rate_id' => rate_ids)


    @options = @options.merge(rate_room_types: rate_room_types, rate_date_range_counts: rate_date_range_counts,
                              room_rates: room_rates)
    # end
    @rates = options[:rates] || []
    @room_types = options[:room_types] || []
    @room_type_room_count = options[:room_type_room_count] || 0
    @rate_date_range_counts = options[:rate_date_range_counts]
    hourly_availability
  end

  def hourly_availability
    @dates = (@begin_date..@end_date)
    self.data = @dates.map { |date| hourly_data(date) }
  end

  def hourly_data(date)
    @physical_count = @options[:physical_count] || 0
    @inventory_details = @options[:inventory_details].where(date: date) #@options[:inventory_details].select { |detail| detail.date == date }
    @sell_limits = @options[:sell_limits].select { |limit| limit.from_date <= date && limit.to_date >= date }
    weekday = date.strftime('%A').downcase
    @rate_room_types = @options[:rate_room_types]
    @rate_date_range_counts = @options[:rate_date_range_counts]
    @room_rates = @options[:room_rates].andand.select do |room_rate|
      rate_set = room_rate.rate_set
      date_range = rate_set.rate_date_range
      date_range.begin_date <= date && date_range.end_date >= date && rate_set[weekday]
    end
    @date = date
    process(date)
  end

  def process(date)
    detail = { date: date }
    house_detail = process_house
    room_type_details = @room_types.map { |room_type| process_room_type(room_type) }
    rate_details = @rates.map { |rate| process_rate(rate, house_detail, room_type_details) }.compact
    detail.merge!(room_types: room_type_details, rates: rate_details)
    self.data = detail
    #puts data
  end

  def process_house
    sell_limit = @sell_limits.find { |limit| !limit.rate_id && !limit.room_type_id }.andand.to_sell
    sold = @inventory_details.sum('hourly_inventory_details.sold')
    availability = sell_limit ? sell_limit - sold : @physical_count - sold
    { sell_limit: sell_limit, sold: sold, availability: availability }
  end


  # Get the availability details for the room type
  def process_room_type(room_type)
    room_count = @room_type_room_count[room_type.id] || 0

    sell_limit = @sell_limits.find { |limit| limit.room_type_id == room_type.id && !limit.rate_id }.andand.to_sell
    inv_details = @inventory_details.where(room_type_id: room_type.id)
    sold = inv_details.sum('hourly_inventory_details.sold')
    availability = sell_limit ? sell_limit - sold : room_count - sold
    { id: room_type.id, sell_limit: sell_limit, sold: sold, availability: availability }
  end

  # Get the availability details for the rate
  def process_rate(rate, house_detail, room_type_details)
    rate_sell_limit = @sell_limits.find { |limit| limit.rate_id == rate.id && !limit.room_type_id }.andand.to_sell
    rate_inventory_details = @inventory_details.where(rate_id: rate.id)
    rate_sold = rate_inventory_details.sum('hourly_inventory_details.sold')
    rate_availability = rate_sell_limit ? rate_sell_limit - rate_sold : house_detail[:availability]


    room_types = @rate_room_types.select { |rate_room_type| rate_room_type.rate_id == rate.id }.map do |rate_room_type|
      @room_types.find { |room_type| room_type.id == rate_room_type.room_type_id }
    end.compact

    room_rates = []
    amounts = {}
    room_types.each do |room_type|
      room_type_availability = room_type_details.find { |room_type_detail| room_type_detail[:id] == room_type.id }.andand[:availability] || 0
      sell_limit = @sell_limits.find { |limit| limit.rate_id == rate.id && limit.room_type_id == room_type.id }.andand.to_sell
      room_type_inv_details = rate_inventory_details.where(room_type_id: room_type.id)
      sold = room_type_inv_details.sum('hourly_inventory_details.sold')
      hourly_sold = room_type_inv_details.select('hourly_inventory_details.sold, hourly_inventory_details.hour').as_json
      availability = sell_limit ? sell_limit - sold : [rate_availability, room_type_availability].min
      
      amounts = {
        room_type_id: room_type.id,
        sell_limit: sell_limit,
        sold: sold,
        availability: availability,
        amount: 100, # TODO hardcoded for now testing purpose.
        # amount: rate.calculate_hourly_rate_amount(@date, room_type, @begin_hour, @end_hour)
        sold_hours: hourly_sold
      }
      
      room_rates << amounts
    end
    
    is_rate_present_for_this_date_range = @rate_date_range_counts[rate.id] && @rate_date_range_counts[rate.id] > 0
    room_rates.present? && is_rate_present_for_this_date_range ? { id: rate.id, room_rates: room_rates } : nil
  end

  def self.availability_count_for_rate(options)
    hotel = Hotel.find(options[:hotel_id])
    begin_date_time = options[:begin_date_time]
    end_date_time = options[:end_date_time]
    availability = []
    inventory_details = HourlyInventoryDetail.inventory_details_for_a_period(options)
    rate = hotel.rates.find(options[:rate_id]) if options[:rate_id]
    room_types = rate.room_types
    room_types.each do |room_type|
      rooms = room_type.rooms.exclude_pseudo_and_suite
      room_ids = rooms.pluck(:id)
      out_of_order_room_ids = rooms.out_of_order_between(begin_date_time, end_date_time).pluck(:id)
      rooms_count = (room_ids - out_of_order_room_ids).count
      inventory = (inventory_details.select {|i| i[:room_type_id] == room_type.id})
      total_sold_count = inventory.map {|i| i[:sold]}.reduce(0, :+)
      availability << {
        room_type_id: room_type.id,
        count: rooms_count - total_sold_count 
      } if rooms_count > total_sold_count
    end
    availability
  end

  
end
