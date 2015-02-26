class Api::ChargeCodesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date

  # List charge codes for the hotel
  def index
    @charge_codes = current_hotel.charge_codes.page(params[:page]).per(params[:per_page]).order(:charge_code)
    @charge_codes = @charge_codes.room_charge_codes if params[:is_room_charge_code] == 'true'
  end
end
