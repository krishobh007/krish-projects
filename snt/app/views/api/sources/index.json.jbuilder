json.sources @sources do |source|
  json.value source.id
  json.name source.code
  json.description source.description
  json.is_active source.is_active
end
json.is_use_sources @is_use_sources