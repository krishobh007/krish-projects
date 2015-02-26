class BillingApi < ConnectEngineApi
  def get_invoice(resv_name_id)
    @connect_api_class.get_invoice(@hotel_id, resv_name_id)
  end

  def folio_transaction_transfer(resv_name_id, options)
  	@connect_api_class.folio_transaction_transfer(@hotel_id, resv_name_id, options)
  end

end

