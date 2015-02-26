class Api::GroupsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date

  def index
  	@groups = current_hotel.groups
  end
end