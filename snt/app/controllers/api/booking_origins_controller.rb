class Api::BookingOriginsController < ApplicationController
  before_filter :check_session
  before_filter :set_booking_origin, only: [:update, :destroy]
  after_filter :load_business_date_info
  before_filter :check_business_date
  
  # Method to list all sources for a hotel
  def index
    @booking_origins = current_hotel.booking_origins
    @is_use_origins = current_hotel.settings.use_origins
  end
  # Method to create source for a hotel
  def create
    @booking_origin = current_hotel.booking_origins.new(code: params[:name], description: params[:description], is_active: true)
    @booking_origin.save || render(json: @booking_origin.errors.full_messages, status: :unprocessable_entity)
  end
  # Method to update a source
  def update
    @booking_origin.update_attributes(code: params[:name], description: params[:description], is_active: params[:is_active])  ||
      render(json: @booking_origin.errors.full_messages, status: :unprocessable_entity)
  end
  # Method to delete a source
  def destroy
    @booking_origin.delete || render(json: @booking_origin.errors.full_messages, status: :unprocessable_entity)
  end
  # Method to enable/disable all sources
  def use_origins
    current_hotel.settings.use_origins = params[:is_use_origins]
  end

  private

  def set_booking_origin
    @booking_origin = current_hotel.booking_origins.find(params[:id])
    fail I18n.t(:invalid_origin_id) unless @booking_origin.present?
  end
end
