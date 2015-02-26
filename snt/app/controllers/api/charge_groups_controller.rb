class Api::ChargeGroupsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date

  # List charge groups for the hotel
  def index
    @charge_groups = current_hotel.charge_groups.page(params[:page]).per(params[:per_page]).order(:charge_group)
  end

  # List charge groups for the hotel that are assigned to an active addon, per the request parameters
  def for_addons
    @charge_groups = current_hotel.charge_groups.page(params[:page]).per(params[:per_page]).order(:charge_group)
    @charge_groups = @charge_groups.includes(:addons).merge(current_hotel.addons.search(params, current_hotel.active_business_date))
  end
end
