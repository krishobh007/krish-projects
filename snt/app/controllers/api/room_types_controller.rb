class Api::RoomTypesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  # List room types for the hotel sorted by name
  def index
    @room_types = current_hotel.room_types.page(params[:page]).per(params[:per_page]).order(:room_type_name)
    # Exclude all pseudo room_types from the list
    @room_types = @room_types.is_not_pseudo if params[:exclude_pseudo]
    @room_types = @room_types.is_not_suite if params[:exclude_suite]
  end
end
