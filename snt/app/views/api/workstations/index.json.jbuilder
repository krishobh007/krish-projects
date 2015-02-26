json.work_stations @work_stations.each do |work_station|
	json.call(work_station, :id, :station_identifier, :name)
end

json.total_count @total_count