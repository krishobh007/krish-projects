# Used to process availability calls in a remote API
class CalendarApi < ConnectEngineApi
  # Get the availability of particular room type and rate code for the hotel
  def fetch_calendar(start_date, end_date, adult_count, child_count, room_type = nil, rate_plan_code = nil)
    @connect_api_class.fetch_calendar(@hotel_id, start_date, end_date, adult_count, child_count, room_type, rate_plan_code)
  end
end
