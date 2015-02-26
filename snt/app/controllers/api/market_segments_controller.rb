# Provides the admin APIs for managing the rate types
class Api::MarketSegmentsController < ApplicationController
  before_filter :check_session
  before_filter :set_market_segment, only: [:update, :destroy]
  before_filter :check_business_date

  def index
  	@market_segments = current_hotel.market_segments
  	@market_segments = @market_segments.active if params[:is_active] == 'true'
  	@use_markets = current_hotel.settings.use_markets
  end

  def create
    @market_segment = current_hotel.market_segments.new(name: params[:name], is_active:  true)
    @market_segment.save || render(json: @market_segment.errors.full_messages, status: :unprocessable_entity)
  end

  def update
    @market_segment.update_attributes(name: params[:name], is_active: params[:is_active]) || render(json: @market_segment.errors.full_messages, status: :unprocessable_entity)
  end

  # Destroys a rate type
  def destroy
    @market_segment.destroy || render(json: @market_segment.errors.full_messages, status: :unprocessable_entity)
  end

  # Method to enable/disable market segments
  def use_markets
   current_hotel.settings.use_markets = params[:is_use_markets]
  end

  private

  def set_market_segment
    @market_segment = current_hotel.market_segments.find(params[:id])
    fail I18n.t(:access_denied) unless @market_segment.present?
  end

end