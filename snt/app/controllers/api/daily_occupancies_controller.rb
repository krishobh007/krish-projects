class Api::DailyOccupanciesController < ApplicationController
  before_filter :check_session
  before_filter :retrieve_paginated_dates, only: :index
  after_filter :load_business_date_info
  before_filter :check_business_date
  
  # List the actual and target occupancy per date
  def index
    @occupancies = current_hotel.occupancy_per_date(@dates.first, @dates.last)
    @targets = current_hotel.target_per_date(@dates.first, @dates.last)
  end

  # Create or update the target percentages per date
  def targets
    params[:dates].andand.each do |info|
      target = current_hotel.occupancy_targets.find_by_date(info[:date])

      if target
        target.update_attributes!(target: info[:target])
      else
        current_hotel.occupancy_targets.create!(date: info[:date], target: info[:target])
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

  private

  # Obtains the paginated dates
  def retrieve_paginated_dates
    fail I18n.t('daily_rates.date_range_required') if !params.key?(:from_date) || !params.key?(:to_date)

    from_date_orig = Date.parse(params[:from_date])
    to_date_orig = Date.parse(params[:to_date])
    # Setting Per page count since Kaminari returns only maximum of 25 counts-CICO-7850
    unless params[:per_page].present?
      params[:per_page] = (to_date_orig - from_date_orig).to_i + 1  
    end
    @dates = Kaminari.paginate_array((from_date_orig..to_date_orig).to_a).page(params[:page]).per(params[:per_page])
  end
end
