json.proximity_id @beacon_details.present? ? @beacon_details.first.hotel.andand.hotel_chain.andand.beacon_uuid_proximity : nil
json.major_id @beacon_details.present? ? @beacon_details.first.hotel.andand.beacon_uuid_major : nil
json.updated_list_time_stamp @last_updated.to_i

json.results @beacon_details do |beacon|
    estimote_id = beacon.uuid.split("-")
    json.beacon_id beacon.id
    json.minor_id estimote_id[6]
    json.location beacon.location
    json.status beacon.is_active
    json.trigger_range beacon.andand.trigger_range.andand.to_s
    json.type beacon.andand.type.andand.to_s
    json.neighbours beacon.neighbours.pluck(:id)
end

json.total_count @beacon_details.present? ? @beacon_details.total_count : 0