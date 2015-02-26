class Api::FloorsController < ApplicationController
  before_filter :check_session
  before_filter :check_business_date
  
  def index
    # Listing the floors based on the ascending order of floor number
    # Dependency on House Keeping screen.
    @floors = current_hotel.floors.order(:floor_number)
  end

  def show
    @floor = current_hotel.floors.find(params[:id])
  end

  def save
    @floor = params[:id].present? ? current_hotel.floors.find(params[:id]) : current_hotel.floors.new
    attributes = { floor_number: params[:floor_number], description: params[:description] }
    begin
      @floor.update_attributes!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      render(json: e.record.errors.full_messages, status: :unprocessable_entity)
    end
  end

  def destroy
    floor = current_hotel.floors.find(params[:id])
    if floor.rooms.present?
      render(json: [I18n.t(:floor_associated_with_room)], status: :unprocessable_entity)
    else
      floor.delete
    end
    rescue ActiveRecord::RecordInvalid => e
      render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

end
