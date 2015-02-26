module SeedChargeCode
  def create_charge_code
    hotel = Hotel.first

    charge_code = ChargeCode.new(charge_code: '8300', hotel_id: hotel.id, charge_code_type: :TAX, description: 'Room Tax - 6%')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '8310', hotel_id: hotel.id, charge_code_type: :TAX, description: 'Occupancy Tax- 4%')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    
    charge_code = ChargeCode.create(charge_code: '9010', hotel_id: hotel.id, charge_code_type: :PAYMENT, description: 'Cash')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '9000', hotel_id: hotel.id, charge_code_type: :PAYMENT, description: 'Cash')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '1003', hotel_id: hotel.id, charge_code_type: :ADDON, description: 'Dinner AP')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '2000', hotel_id: hotel.id, charge_code_type: :ADDON, description: 'Lobby Bar Food')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '2064', hotel_id: hotel.id, charge_code_type: :ADDON, description: 'Internet Connection')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '3000', hotel_id: hotel.id, charge_code_type: :OTHERS, description: 'Fax')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '9020', hotel_id: hotel.id, charge_code_type: :PAYMENT, description: 'Visa')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '9026', hotel_id: hotel.id, charge_code_type: :PAYMENT, description: 'American Express')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '9040', hotel_id: hotel.id, charge_code_type: :PAYMENT, description: 'Master Card')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '9050', hotel_id: hotel.id, charge_code_type: :PAYMENT, description: 'Discover')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '9055', hotel_id: hotel.id, charge_code_type: :PAYMENT, description: 'Diners Club')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '9150', hotel_id: hotel.id, charge_code_type: :PAYMENT, description: 'Deposit Transfer')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '9205', hotel_id: hotel.id, charge_code_type: :PAYMENT, description: 'Direct Bank Deposit')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '9251', hotel_id: hotel.id, charge_code_type: :OTHERS, description: 'Parking')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '9300', hotel_id: hotel.id, charge_code_type: :ADDON, description: 'Package')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '9001', hotel_id: hotel.id, charge_code_type: :PAYMENT, description: 'F&B Cash')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '9005', hotel_id: hotel.id, charge_code_type: :PAYMENT, description: 'AR Cash')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '9015', hotel_id: hotel.id, charge_code_type: :PAYMENT, description: 'Traveler\'s Check')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '9100', hotel_id: hotel.id, charge_code_type: :PAYMENT, description: 'Direct Bill')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '9160', hotel_id: hotel.id, charge_code_type: :PAYMENT, description: 'Pre Paid Commission')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '6030', hotel_id: hotel.id, charge_code_type: :OTHERS, description: 'Laundry')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '2300', hotel_id: hotel.id, charge_code_type: :OTHERS, description: 'Minibar Food')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save
    
    charge_code = ChargeCode.create(charge_code: '6060', hotel_id: hotel.id, charge_code_type: :OTHERS, description: 'Upsell Latecheckout Charge')
    charge_code.charge_groups = [ChargeGroup.first]
    charge_code.save

    unless hotel.late_checkout_charge_code_id
      hotel.update_attribute(:late_checkout_charge_code_id, hotel.charge_codes.find_by_charge_code('6060').id)
    end
  end
end
