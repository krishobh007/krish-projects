class Api::RateDateRangesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  before_filter :retrieve_rate, only: [:index, :create]
  before_filter :retrieve, only: [:show, :update, :destroy]

  # List date ranges for the rate
  def index
    @date_ranges = @rate.date_ranges.order(:begin_date)
  end

  # Show the date range
  def show
    @hotel = current_hotel
  end

  # Create a new date range with sets
  def create
    RateDateRange.transaction do
      @date_range = RateDateRange.create!(begin_date: params[:begin_date], end_date: params[:end_date], rate_id: params[:rate_id])

      params[:sets].andand.each do |set|
        @date_range.sets.create!(name: set[:name], sunday: set[:sunday], monday: set[:monday], tuesday: set[:tuesday], wednesday: set[:wednesday],
                                 thursday: set[:thursday], friday: set[:friday], saturday: set[:saturday],
                                 day_min_hours: set[:day_min_hours], day_max_hours: set[:day_max_hours],
                                 day_checkout_cut_off_time: set[:day_checkout_cutoff_time], 
                                 night_start_time: set[:nightly_start_time],
                                 night_end_time: set[:nightly_end_time],
                                 night_checkout_cut_off_time: set[:night_checkout_cutoff_time])
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

  # Update an existing date range
  def update
    @date_range.update_attributes(begin_date: params[:begin_date], end_date: params[:end_date]) ||
      render(json: @date_range.errors.full_messages, status: :unprocessable_entity)
  end

  # Destroys a date range
  def destroy
    @date_range.destroy || render(json: @date_range.errors.full_messages, status: :unprocessable_entity)
  end

  private

  # Retrieve the selected date range
  def retrieve
    @date_range = RateDateRange.find(params[:id])
    fail I18n.t(:access_denied) unless @date_range.rate.accessible?(current_hotel)
  end

  # Retrieve the selected rate
  def retrieve_rate
    @rate = Rate.find(params[:rate_id])
    fail I18n.t(:access_denied) unless @rate.accessible?(current_hotel)
  end
end
