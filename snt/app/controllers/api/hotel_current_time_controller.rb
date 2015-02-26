class Api::HotelCurrentTimeController < ApplicationController
  before_filter :check_session

  def index
    Time.zone = current_hotel.tz_info
    @current_hotel_business_time = Time.now.in_time_zone(current_hotel.tz_info)
  end
end
