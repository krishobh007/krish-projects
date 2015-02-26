class CodeApi < ConnectEngineApi
  def get_transaction_codes
    @connect_api_class.get_transaction_codes(@hotel_id)
  end

  def get_rate_codes
    @connect_api_class.get_rate_codes(@hotel_id)
  end
  
  def get_addons
    @connect_api_class.get_addons(@hotel_id)
  end
end
