class Api::ContractNightsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  
  def index
    @rate = Rate.find(params[:contract_id])
    @contract_nights = @rate.contract_nights
  end

  def create
    @rate = Rate.find(params[:contract_id])
    @rate.contract_nights.destroy_all
    @rate.contract_nights.build(contract_night_params)
    @rate.save || render(json: @rate.errors.full_messages, status: :unprocessable_entity)
  end

  private

  def contract_night_params
    params[:occupancy].map do |contract_night|
      {
        month_year: Date.new(contract_night[:year].to_i, Date::ABBR_MONTHNAMES.index(contract_night[:month]), 01),
        no_of_nights: contract_night[:contracted_occupancy]
      }
    end
  end
end
