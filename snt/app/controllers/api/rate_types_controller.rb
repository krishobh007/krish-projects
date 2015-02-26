# Provides the admin APIs for managing the rate types
class Api::RateTypesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  before_filter :retrieve, only: [:show, :update, :destroy, :activate]
  before_filter :updatable, only: [:update, :destroy]

  # Lists the rate types
  def index
    @rate_types = current_hotel.available_rate_types.page(params[:page]).per(params[:per_page]).order(:name)
  end

  # Lists only active rate types for the hotel
  def active
    @rate_types = current_hotel.rate_types.order(:name)
  end

  # Shows the details about a rate type
  def show
  end

  # Create a new rate type.
  def create
    @rate_type = RateType.new(rate_type_params)
    @rate_type.save || render(json: @rate_type.errors.full_messages, status: :unprocessable_entity)
  end

  # Update an existing rate type
  def update
    @rate_type.update_attributes(rate_type_params) || render(json: @rate_type.errors.full_messages, status: :unprocessable_entity)
  end

  # Destroys a rate type
  def destroy
    @rate_type.destroy || render(json: @rate_type.errors.full_messages, status: :unprocessable_entity)
  end

  # Activates or deactivates a rate type for a hotel
  def activate
    currently_activated = current_hotel.rate_types.include?(@rate_type)

    if params[:status]
      current_hotel.rate_types << @rate_type unless currently_activated
    else
      current_hotel.rate_types.destroy(@rate_type) if currently_activated
    end
  end

  private

  # Retrieve the selected rate type
  def retrieve
    @rate_type = RateType.find(params[:id])
    fail I18n.t(:access_denied) unless @rate_type.hotel_id == current_hotel.id || @rate_type.system_defined?
  end

  # Ensures the user can update the rate based on their current hotel
  def updatable
    fail I18n.t(:access_denied) unless @rate_type.hotel_id == current_hotel.id
  end

  def rate_type_params
    { name: params[:name], hotel_id: current_hotel.id }
  end
end
