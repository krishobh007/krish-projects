class HourlyInventoryDetail < ActiveRecord::Base
  attr_accessible :id, :hour, :sold, :inventory_detail_id
  belongs_to :inventory_detail
  
  belongs_to :hotel
  belongs_to :rate
  belongs_to :room_type
  
  
  def self.record!(hour, inventory_detail_id, hotel_id, increment = true)
    hotel = Hotel.find(hotel_id)
    unless hotel.is_third_party_pms_configured?
      hourly_inventory = self.find_by_hour_and_inventory_detail_id(hour, inventory_detail_id) if hour.present? && inventory_detail_id.present?
      if hourly_inventory.present?
        sold = hourly_inventory.sold
        increment ? hourly_inventory.update_attributes(sold: sold+1) : hourly_inventory.update_attributes(sold: sold-1)
      else
        self.create!(hour: hour, sold: 1, inventory_detail_id: inventory_detail_id) if increment
      end
    else
      logger.debug 'Hourly Inventory count updated only for standalone hotels'
    end
  end

  def self.inventory_details_for_a_period(options)
    hotel = Hotel.find(options[:hotel_id])
    begin_date = options[:begin_date]
    end_date = options[:end_date]
    begin_time = options[:begin_time]
    end_time = options[:end_time]
    if options[:begin_date_time].present? && options[:end_date_time].present?
      begin_date_time = options[:begin_date_time]
      end_date_time = options[:end_date_time]
    else
      begin_date_time = getDatetime(begin_date.to_s, begin_time.to_s, hotel.tz_info)
      end_date_time = getDatetime(end_date, end_time.to_s, hotel.tz_info)
    end

    if options[:rate_id]
      rate_ids = options[:rate_id]
    else
      rates = hotel.rates.where(is_hourly_rate: true).pluck(:id)
      rate_ids = rates.join(',') unless rates.empty?
    end
    room_type_id = options[:room_type_id]

    conditions = "date >= '#{begin_date}' and "\
                 "date <= '#{end_date}'"

    conditions += " and room_type_id in (#{room_type_id})" if room_type_id
    conditions += " and rate_id in (#{rate_ids})" if rate_ids

    inventory_details = HourlyInventoryDetail.where(conditions)
                              .select('date, rate_id, room_type_id, hour, sold')
                              .order('date')
    details = []
    inventory_details.each do |detail|
      details << {
        id: detail.id,
        hour: detail.hour,
        date_time: getDatetime(detail.date.to_s, detail.hour.to_s, hotel.tz_info),
        sold: detail.sold,
        room_type_id: detail.room_type_id,
        rate_id: detail.rate_id
      }
    end 
    details.select { |d| d[:date_time] >= begin_date_time and d[:date_time] < end_date_time }
  end



  def self.map_inventories(reservation, is_decrement = false)
    return false unless reservation.is_hourly

    reservation_instance = reservation.current_daily_instance
    rate      = reservation_instance.andand.rate
    room_type = reservation_instance.room_type
    hotel     = reservation.hotel
    date      = reservation_instance.reservation_date

    return if (rate.nil? or room_type.nil? or date.nil?)

    task_completion_time = room_type.tasks.first.andand.completion_time
    end_time = task_completion_time.nil? ? reservation.departure_time : (reservation.departure_time + task_completion_time.to_f)
    # Convert the begin and end time to the current hotel time zone.
    end_hour    = end_time.in_time_zone(hotel.tz_info).strftime('%H').to_i
    begin_hour  = reservation.arrival_time.in_time_zone(hotel.tz_info).strftime('%H').to_i
    (begin_hour...end_hour).each do |reservation_hour|
      inventory = self.find_or_create_by_hour_and_hotel_id_and_rate_id_and_room_type_id_and_date(reservation_hour, hotel.id, rate.id, room_type.id, date)
      inventory.sold = inventory.sold.nil? ? 1 : (is_decrement ? inventory.sold - 1 : inventory.sold + 1)
      inventory.save
    end
      # Record data in inventory details if rate is night  
      if reservation.has_nightly_component?
        InventoryDetail.record!(rate.id, room_type.id, hotel.id, date, !is_decrement)
      end
  end

  def self.getDatetime(date, time, tz_info)
    ActiveSupport::TimeZone[tz_info].parse(date.to_s + ' ' + time.to_s)
  end

end
