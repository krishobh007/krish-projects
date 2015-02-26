class ViewMappings::GuestZest::BeaconsMapping
  
  def self.map_beacon_list(beacon)
    estimote_id = beacon.uuid.split("-")
    data = {
      beacon_id: beacon.present? ? (beacon.id.to_s) : '',
      minor_id: beacon.present? ? (estimote_id[6].to_s) : '',
      location: beacon.present? ? beacon.location : '',
      trigger_range: beacon.present? ? beacon.trigger_range.andand.value : '',
      neighbouring_beacons: beacon.present? ? beacon.neighbours.map { |neighbour| map_neighbouring_beacons(neighbour) } : []
    }
    data
  end
  
  def self.map_neighbouring_beacons(neighbour)
    estimote_id = neighbour.uuid.split("-") if neighbour.present?
    {
      beacon_id: neighbour.present? ? (neighbour.id.to_s) : '',
      minor_id: neighbour.present? ? (estimote_id[6].to_s) : '',
      location: neighbour.present? ? neighbour.location : '',
      trigger_range: neighbour.present? ? neighbour.trigger_range.andand.value : ''
    }
  end
  
   def self.map_beacon_details(beacon)
     estimote_id = beacon.uuid.split("-")
     {
        beacon_id: beacon.id,
        minor_id: estimote_id[6] ,
        status: beacon.is_active,
        location: beacon.location,
        trigger_range: beacon.trigger_range.andand.value,
        type: beacon.type.andand.value,
        info_picture: beacon.promotion ? beacon.promotion.andand.picture.andand.image.url : "",
        info_title: beacon.promotion ? beacon.promotion.andand.title : "",
        info_description: beacon.promotion ? beacon.promotion.andand.description : ""
    }

   end
  
end