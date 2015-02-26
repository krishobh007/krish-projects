class Admin::HotelBusinessDatesController < ApplicationController
  before_filter :check_session

  def index
    business_date = current_hotel.active_business_date

    response = { status: SUCCESS, data: business_date, errors: [] }

    respond_to do |format|
      format.html { render locals: response }
      format.json { render json: response }
    end
  end

  def sync
    errors = []
    data = {}

    result = current_hotel.sync_business_date_with_external_pms

    if result[:status]
      data[:message] = result[:message]
      data[:business_date] = result[:business_date]
    else
      errors << I18n.t(:external_pms_failed)
    end

    render json: { status: errors.empty? ? SUCCESS : FAILURE, data: data, errors: errors }
  end
end
