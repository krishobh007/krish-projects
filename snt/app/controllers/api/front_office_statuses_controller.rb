class Api::FrontOfficeStatusesController < ApplicationController 
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  
  def index
    @front_office_statuses = Ref::FrontOfficeStatus.all
  end
end