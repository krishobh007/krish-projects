class Api::ReservationTypesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date

  def index
    # As per CICO-12639, we need to list all GT for connected/stand alone hotels in Reports.
    if current_hotel.is_third_party_pms_configured?
      @reservation_types = current_hotel.reservations.pluck(:guarantee_type).uniq.compact
    else
      @reservation_types = Ref::ReservationType.all
    end
    @hotel = current_hotel
  end

  def activate
    is_set_active = params[:is_active]
    @reservation_type = Ref::ReservationType.find(params[:id])
    if is_set_active
      current_hotel.reservation_types << @reservation_type unless current_hotel.reservation_types.include?(@reservation_type)
    else
      current_hotel.reservation_types.delete(@reservation_type) if current_hotel.reservation_types.include?(@reservation_type)
    end
  end
end
