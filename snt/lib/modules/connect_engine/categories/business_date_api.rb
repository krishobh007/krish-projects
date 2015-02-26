class BusinessDateApi < ConnectEngineApi
  def get_business_date(connection_params = nil)
    @connect_api_class.get_business_date(@hotel_id, connection_params)
  end
end
