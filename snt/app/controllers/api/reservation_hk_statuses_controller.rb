class Api::ReservationHkStatusesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  
  def index
    @reservation_hk_statuses = Ref::ReservationHkStatus.all
  end
end