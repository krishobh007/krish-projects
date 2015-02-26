json.availability_count_per_hour @hours_availability do |each_hour|
  json.time each_hour[:hour]
  json.count each_hour[:availability]
end