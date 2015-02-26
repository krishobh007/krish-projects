module SeedHotelPaymentTypes
  def create_payment_types
    hotel = Hotel.first

    if hotel.payment_types.empty?
      payment_type = PaymentType.first
      hotel.payment_types << payment_type
      hotel.save
    end
  end
end
