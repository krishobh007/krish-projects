module SeedLateCheckout
  def create_late_checkout
    hotel = Hotel.find_by_code('DOZERQA')

    if hotel.late_checkout_charges.empty?
      LateCheckoutCharge.create(extended_checkout_time: '14:00:00', extended_checkout_charge: '10', hotel_id: hotel.id)
      LateCheckoutCharge.create(extended_checkout_time: '16:00:00', extended_checkout_charge: '25', hotel_id: hotel.id)
      LateCheckoutCharge.create(extended_checkout_time: '18:00:00', extended_checkout_charge: '40', hotel_id: hotel.id)
    end
  end
end
