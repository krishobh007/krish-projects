class Api::RoomsController < ApplicationController
  before_filter :check_session

  def index
    @rooms = current_hotel.rooms
  end
  
end