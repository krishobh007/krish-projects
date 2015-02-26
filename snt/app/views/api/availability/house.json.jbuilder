json.physical_count current_hotel.rooms.exclude_pseudo_and_suite.count

json.results @availability do |date_availability|
  json.date date_availability[:date].strftime('%Y-%m-%d')

  json.house do
    house = date_availability[:house]
    json.call(house, :sold, :sell_limit, :availability, :out_of_order, :in_house, :departed, :departing, :arrived, :arriving, :total_room_revenue, :average_daily_rate)
  end
  
end

json.total_count @dates.total_count
