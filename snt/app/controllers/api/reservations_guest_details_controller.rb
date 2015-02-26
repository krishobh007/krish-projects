class Api::ReservationsGuestDetailsController < ApplicationController
  before_filter :check_session
  before_filter :set_reservation
  
  rescue_from StandardError, :with => :catch_exception
  
  def index
    @current_daily_instance = @reservation.current_daily_instance
  end
  
  def create
    @reservation.daily_instances.each do |daily_instance|
      daily_instance.update_attributes({
        :adults   => params[:adult_count],
        :children => params[:children_count],
        :infants  => params[:infants_count]
      })
    end if params[:adult_count].present? && params[:children_count].present? && params[:infants_count].present?
    
    accompanying_guests_details = params[:accompanying_guests_details] || []
    updated_ids = []    
    accompanying_guests_details.each do |guests_detail_params|
      id = guests_detail_params[:id]
      guests_detail = nil
      if id.present?
        guests_detail = @reservation.guest_details.find(id)
        guests_detail.update_attributes!(
          :first_name => guests_detail_params[:first_name],
          :last_name  => guests_detail_params[:last_name]
        )
      else
        guests_detail = @reservation.guest_details.create!(
          :first_name => guests_detail_params[:first_name],
          :last_name  => guests_detail_params[:last_name],
          :hotel_chain_id => current_hotel.hotel_chain_id
        )
        reservations_guest_detail = @reservation.reservations_guest_details.find_by_guest_detail_id(guests_detail.id)
        reservations_guest_detail.is_accompanying_guest = true
        reservations_guest_detail.save
      end
      updated_ids << guests_detail.id if guests_detail
    end
    @reservation.accompanying_guests.where('reservations_guest_details.guest_detail_id NOT IN (?)', updated_ids).destroy_all unless updated_ids.empty?
  end
  
  private
    def set_reservation
      @reservation = Reservation.find(params[:reservation_id])
    end
    
  protected
    def catch_exception(ex)
      logger.error ex.message
      logger.error ex.backtrace
      if ex.is_a?(ActiveRecord::ActiveRecordError)
        render :json => [ex.message], :status => :unprocessable_entity
      else
        render :json => ["An unexpected error has been occured"], :status => :unprocessable_entity
      end
    end
  
end