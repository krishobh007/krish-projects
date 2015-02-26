class Api::BillsController < ApplicationController
  before_filter :check_session
  before_filter :check_business_date

  #Method to create bill for reservation
  def create_bill
    reservation = Reservation.find(params[:reservation_id])
    reservation.bills.create(bill_number: 1) if reservation.bills.empty?
    if params[:bill_number].present?
      @bill = reservation.bills.create(bill_number: params[:bill_number])
    else
      @bill = reservation.bills.create(bill_number: reservation.bills.last.bill_number+1)
    end
    render(json: @bill.errors.full_messages, status: :unprocessable_entity) unless @bill.errors.empty?
  end

   # Method to transfer transaction from one bill window to another
  def transfer_transaction
    reservation = Reservation.find(params[:reservation_id])
    result = reservation.transfer_transaction(params.extract!(:from_bill, :to_bill, :transaction_id))
  end

end