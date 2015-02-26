class Api::HotelMessagesController < ApplicationController
  before_filter :check_session
  before_filter :check_business_date
  # Returns a hash of the hotel's settings
  def index
    @hotel_messages = current_hotel.hotel_messages.with_translations(I18n.locale).where(module: params[:module])
  end

  def create
    @hotel_message = current_hotel.hotel_messages.new(message_params)
    @hotel_message.save || render(json: @hotel_message.errors.full_messages, status: :unprocessable_entity)
  end

  def update
    @hotel_message = current_hotel.hotel_messages.find(params[:id])
    @hotel_message.update_attributes(message_params) || render(json: @hotel_message.errors.full_messages, status: :unprocessable_entity)
  end

  def destroy
    @hotel_message = current_hotel.hotel_messages.find(params[:id])
    @hotel_message.destroy || render(json: @hotel_message.errors.full_messages, status: :unprocessable_entity)
  end

  private

  def message_params
    {
      message: params[:message],
      module: params[:module],
      hotel_id: current_hotel.id,
      hotel_message_key_id: params[:hotel_message_key_id]
    }
  end
end
