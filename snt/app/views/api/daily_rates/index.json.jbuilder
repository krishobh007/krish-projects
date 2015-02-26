json.results @dates do |date|
  date_restrictions = @restrictions_hash[date] ? @restrictions_hash[date] : {}
  json.date date.strftime('%Y-%m-%d')
  all_rate_restrictions = []
  ccount = 0
  json.rates @rates.each do |rate|
    ccount += 1
    rate_restrictions = nil
    rate_restrictions_hash = date_restrictions[rate.id] ? date_restrictions[rate.id] : {}

    json.id rate.id
    json.name rate.rate_name 
    json.is_suppress_rate_on rate.is_suppress_rate_on  
    json.is_hourly rate.is_hourly_rate

    # In order to avoid mysql hits, we had excluded Psudo Room Type from the rate query.
    # This will not impact any performance query logic - since used 'includes'
    rate.room_types.each do |room_type|  
      room_type_restrictions = rate_restrictions_hash[room_type.id] ? rate_restrictions_hash[room_type.id] : []
      room_type_restrictions = room_type_restrictions
        .map { |restriction| { type_id: restriction['type_id'], days: restriction['days'], is_on_rate: false } }
      rate_restrictions = rate_restrictions ? rate_restrictions & room_type_restrictions : room_type_restrictions
    end
    # If any rate has restriction attached from rate setup screen, thats will be append along with rate_restrictions
    rate_restrictions ||= []
    rate_restrictions += rate.rate_restrictions.map { |restriction| { type_id: restriction.type_id, days: restriction.days, is_on_rate: true } }

    # Intersect the all rate restrictions with the rate restrictions
    all_rate_restrictions = ccount == 1 ? rate_restrictions.flatten : all_rate_restrictions & rate_restrictions.flatten 

    json.restrictions rate_restrictions.each do |restriction|
      json.restriction_type_id restriction[:type_id]
      json.days restriction[:days]
      json.is_on_rate restriction[:is_on_rate]
    end    
  end
  json.all_rate_restrictions all_rate_restrictions  
end

json.total_count @dates.total_count
