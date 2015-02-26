class OwsPaymentApi
  def self.make_payment(hotel_id, resv_name_id, make_payment_data, bill_number, amount)
    payment_service = OwsResvAdvancedService.new(hotel_id)
    hotel = Hotel.find(hotel_id)
    message = OwsMessage.new

    post_attributes = {
      post_date: hotel.active_business_date,
      charge: amount,
      folio_view_no: bill_number
    }
    message.append_posting_reservation_request(hotel_id, resv_name_id, post_attributes) unless resv_name_id.nil?

    # TODO this will replace with original data.
    # card_type, name, number, expiry_date, approval_code = "VI", "MAHESH MOHAN", "4024007147736119", "2015-12-31", "A1234"

    card_type, name, mli_token, expiry_date, card_number = make_payment_data[:card_type], make_payment_data[:card_name], make_payment_data[:mli_token], make_payment_data[:expiry_date], make_payment_data[:card_number]

    message.append_credit_card_for_payment(hotel_id, card_type, name, mli_token, expiry_date, card_number)

    payment_service.make_payment message, '//MakePaymentResponse', lambda { |operation_response|
      { receipt_no: operation_response.xpath('@receiptNo').text }
    }
  end
end
