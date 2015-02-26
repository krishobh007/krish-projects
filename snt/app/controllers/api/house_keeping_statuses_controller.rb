class Api::HouseKeepingStatusesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  
  def index
    @house_keeping_statuses = Ref::HousekeepingStatus.all
  end
end