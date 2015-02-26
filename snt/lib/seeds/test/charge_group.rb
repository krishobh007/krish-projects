module SeedChargeGroup
  def create_charge_group
    hotel = Hotel.first

    group1 = ChargeGroup.create(charge_group: 'PARKING', description: 'Parking', hotel_id: hotel.id)
    group2 = ChargeGroup.create(charge_group: 'INCIDENTALS', description: 'Incidentals', hotel_id: hotel.id)

  end
end
