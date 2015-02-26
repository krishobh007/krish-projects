class Api::BusinessDatesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info

  def active
    @business_date = current_hotel.active_business_date if current_hotel.present?
  end

end
