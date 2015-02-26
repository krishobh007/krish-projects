json.results @rates do |rate|
  json.id rate.id
  json.name rate.rate_name
  json.description rate.rate_desc
  json.code rate.rate_code
  json.promotion_code rate.promotion_code
  json.is_hourly_rate rate.is_hourly_rate
  
  json.based_on do
    based_on_rate = rate.based_on_rate

    if based_on_rate
      json.id based_on_rate.id
      json.name based_on_rate.rate_name
    else
      json.null!
    end
  end

  json.rate_type do
    rate_type = rate.rate_type

    if rate_type
      json.id rate_type.id
      json.name rate_type.name
    else
      json.null!
    end
  end

  json.date_range_count rate.date_ranges.count
  json.status rate.is_active
end

json.total_count @total_count
