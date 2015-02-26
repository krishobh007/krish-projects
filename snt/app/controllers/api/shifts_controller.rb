class Api::ShiftsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :set_time_zone
  after_filter :revert_time_zone
  before_filter :check_business_date
  
  def index
    @shifts = current_hotel.shifts.page(params[:page]).per(params[:per_page])
  end

  def create
    @shift = Shift.new(shift_params)
    @shift.save || render(json: @shift.errors.full_messages, status: :unprocessable_entity)
  end
  
  def show
    @shift = Shift.find(params[:id])
  end

  def update
    @shift = Shift.find(params[:id])
    @shift.update_attributes(shift_params) || render(json: @shift.errors.full_messages, status: :unprocessable_entity)
  end

  def destroy
    @shift = Shift.find(params[:id])
    @shift.destroy || render(json: @shift.errors.full_messages, status: :unprocessable_entity)
  end

  private

  def shift_params
    { name: params[:name],
      time: params[:time].to_datetime,
      hotel_id: params[:hotel_id] }
  end
end