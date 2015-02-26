class  Staff::BillsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  # Method to transfer transaction from one bill window to another
  def transfer_transaction
    reservation = Reservation.find(params[:reservation_id])
    result = reservation.transfer_transaction(params.extract!(:from_bill, :to_bill, :transaction_id, :id))
    if result[:status]
      render json: { status: SUCCESS, errors: [], data: {} }
    else
      render json: { status: FAILURE, errors: [result[:message]], data: {} }
    end
  end
  

  # Method to transfer transaction from one bill window to another
  def print_guest_bill
    reservation = Reservation.find(params[:reservation_id])
    bill = reservation.bills.find_by_bill_number(params[:bill_number])
    data = bill.bill_data_for_email(reservation)
    render json: { status: SUCCESS, errors: [], data: data }
  end
  

end
