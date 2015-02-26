class PaymentApi < ConnectEngineApi
  def make_payment(resv_name_id, make_payment_data,  bill_number, amount)
    @connect_api_class.make_payment(@hotel_id, resv_name_id, make_payment_data,  bill_number, amount)
  end
end
