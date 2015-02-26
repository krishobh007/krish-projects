json.departures do
  json.call(@departures, :clean, :total_hours, :total_maids_required, :total_rooms_assigned, :total_rooms_completed)
end

json.stayovers do
  json.call(@stayovers, :clean, :total_hours, :total_maids_required, :total_rooms_assigned, :total_rooms_completed)
end