# Provides the admin APIs for managing the key encoders
class Api::KeyEncodersController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date

  before_filter :retrieve, only: [:show, :update, :destroy, :activate]

  # Lists the key encoders
  def index
    @key_encoders = current_hotel.key_encoders.search(params[:query]).page(params[:page]).per(params[:per_page]).order(:description)
  end

  # Lists only active key encoders for the hotel
  def active
    @key_encoders = current_hotel.key_encoders.active.order(:description)
  end

  # Shows the details about a key encoder
  def show
  end

  # Create a new key encoder
  def create
    @key_encoder = KeyEncoder.new(key_encoder_params)
    @key_encoder.save || render(json: @key_encoder.errors.full_messages, status: :unprocessable_entity)
  end

  # Update an existing key encoder
  def update
    @key_encoder.update_attributes(key_encoder_params) || render(json: @key_encoder.errors.full_messages, status: :unprocessable_entity)
  end

  # Destroys a key encoder
  def destroy
    @key_encoder.destroy || render(json: @key_encoder.errors.full_messages, status: :unprocessable_entity)
  end

  # Activates or deactivates a key encoder for a hotel
  def activate
    enabled = params[:status] || false
    @key_encoder.update_attributes(enabled: enabled) || render(json: @key_encoder.errors.full_messages, status: :unprocessable_entity)
  end

  private

  # Retrieve the selected key encoder
  def retrieve
    @key_encoder = KeyEncoder.find(params[:id])
    fail I18n.t(:access_denied) unless @key_encoder.hotel_id == current_hotel.id
  end

  def key_encoder_params
    {
      description: params[:description],
      location: params[:location],
      encoder_id: params[:encoder_id],
      enabled: params[:enabled] || false,
      hotel_id: current_hotel.id
    }
  end
end
