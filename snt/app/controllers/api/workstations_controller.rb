class Api::WorkstationsController < ApplicationController
  before_filter :check_session
  
  def index
    @work_stations = Workstation.where('hotel_id = ?', current_hotel.id).page(params[:page]).per(params[:per_page])
    @total_count = Workstation.where('hotel_id = ?', current_hotel.id).count
  end

  def show
    @work_station = Workstation.where('hotel_id = ?', current_hotel.id).find(params[:id])
  end
  
  def new
    @work_station = Workstation.new
  end
  
  def create
    @work_station = Workstation.create(
      :hotel => current_hotel,
      :name  => params[:name],
      :station_identifier => params[:identifier]
    )
  end
  
  def edit
    @work_station = Workstation.where('hotel_id = ?', current_hotel.id).find(params[:work_sation_id])
  end
  
  def update
    @work_station = Workstation.where('hotel_id = ?', current_hotel.id).find(params[:id])
    @work_station.update_attributes(
      :name  => params[:name],
      :station_identifier => params[:identifier]
    )
  end
  
  def destroy
    @work_station = Workstation.where('hotel_id = ?', current_hotel.id).find(params[:id])
    @work_station.delete
  end
  
end