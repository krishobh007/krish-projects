class Api::RoomTypesTaskCompletionTimeController < ApplicationController
  before_filter :set_time_zone
  after_filter :revert_time_zone
  def index
    @room_types = current_hotel.room_types.page(params[:page]).per(params[:per_page]).order(:room_type_name)
    # Exclude all pseudo room_types from the list
    @room_types = @room_types.is_not_pseudo if params[:exclude_pseudo]
    @room_types = @room_types.is_not_suite if params[:exclude_suite]
  end
end
