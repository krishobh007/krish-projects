#countries_controller.rb
class Api::CountriesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info

  def index
    @countries = Country.order('name')
    respond_to do |format|
      format.json { render json: { status: SUCCESS, data: @countries, errors: [] } }
    end
  end

end