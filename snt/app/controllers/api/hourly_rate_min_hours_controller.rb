class Api::HourlyRateMinHoursController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  def index
  # As per CICO-9433, we need select hourly rate in the sequence
  # (that is not Corporate, Government or Consortia)
    rate = current_hotel.rates.active.fully_configured.include_public_only.non_contract.where(is_hourly_rate: true).first
    @min_hours = rate.sets.first.andand.day_min_hours if rate
  end
end
