json.markets @market_segments do |segment|
  json.value segment.id
  json.name segment.name
  json.is_active segment.is_active
end
json.is_use_markets @use_markets
json.total_count @market_segments.count