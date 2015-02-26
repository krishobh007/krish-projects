json.results @dates do |date|
  json.date date.strftime('%Y-%m-%d')

  date_restrictions = @rate.room_rate_restrictions.select { |restriction| restriction.date == date }
  rate_restrictions = @rate.rate_restrictions.map { |restriction| { type_id: restriction.type_id, days: restriction.days, is_on_rate: true } }

  all_room_type_restrictions = nil

  json.room_rates @rate.room_types.is_not_pseudo do |room_type|
    room_rate = @rate.room_rates.for_date_and_room_type(date, room_type).first

    json.room_type do
      json.id room_type.id
      json.name room_type.room_type_name
    end

    amounts = room_rate.andand.amounts(date)
    json.is_hourly @rate.is_hourly_rate
    if amounts.present?
      json.single amounts[:single_amount]
      json.double amounts[:double_amount]
      json.extra_adult amounts[:extra_adult_amount]
      json.child amounts[:child_amount]
      json.nightly_rate amounts[:single_amount]
    end

    # Get all of the restrictions assigned to this room type for this date
    room_type_restrictions = date_restrictions.select { |restriction| restriction.room_type == room_type }
      .map { |restriction| { type_id: restriction.type_id, days: restriction.days, is_on_rate: false } }

    room_type_restrictions += rate_restrictions

    # Intersect the rate restrictions with the room type restrictions
    all_room_type_restrictions = all_room_type_restrictions ? all_room_type_restrictions & room_type_restrictions : room_type_restrictions

    json.restrictions room_type_restrictions do |restriction|
      json.restriction_type_id restriction[:type_id]
      json.days restriction[:days]
      json.is_on_rate restriction[:is_on_rate]
    end
  end

  all_room_type_restrictions ||= rate_restrictions

  json.rate_restrictions all_room_type_restrictions do |restriction|
    json.restriction_type_id restriction[:type_id]
    json.days restriction[:days]
    json.is_on_rate restriction[:is_on_rate]
  end
end

json.total_count @dates.total_count
