# Used to process availability calls in a remote API
class AvailabilityApi < ConnectEngineApi
  # Get the availability of particular room type and rate code for the hotel
  def availability(begin_date, end_date, room_type, rate_code, promotion_code)
    @connect_api_class.availability(@hotel_id, begin_date, end_date, room_type, rate_code, promotion_code)
  end
end
