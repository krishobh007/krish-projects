class Guest::BillsController < ApplicationController
  before_filter :check_session

  # Method to send guest bill details for Mobile Application
  def get_bill_items
    data = {}
    status = FAILURE
    errors = []
    reservation = Reservation.find(params[:reservation_id])
    reservation.sync_bills_with_external_pms
    data['average_per_night'] = reservation.guest_room_rates
    data['payment_details'] = reservation.guest_payment_details
    data['bill_details'] =  reservation.guest_bill_details
    status = SUCCESS

    render json: { status: status, data: data, errors: errors }
  end
end
