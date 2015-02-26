class Api::ArTransactionsController < ApplicationController

  #Method to list the bills linked to the account
  def index
  	@account = current_hotel.hotel_chain.accounts.find(params[:account_id])
    @all_ar_transactions = @account.ar_transactions.where(hotel_id: current_hotel.id)

    # Input values for pagination
    @total_count = @all_ar_transactions.debits.count
    page = params[:page].to_i
    per_page = params[:per_page].to_i
    offset = (page-1)*per_page || 0;
    limit = per_page || 10;
    @hotel = current_hotel
    #Paginated list
    @ar_transactions = @account.ar_reservations(current_hotel.id).uniq

    # Date Filter and search
    @ar_transactions = @ar_transactions.search_by_room_no(params[:query]) if params[:query].present? && params[:room_search] == 'true'
    @ar_transactions = @ar_transactions.search_by_guest_name_or_room_or_confirm_no(params[:query]) if params[:query].present?
    @ar_transactions = @ar_transactions.checked_out_before(params[:to_date]) if params[:to_date].present?
    @ar_transactions = @ar_transactions.checked_out_after(params[:from_date]) if params[:from_date].present?
    # End: Date Filter and search

    #Paid / Open Filter
    @ar_transactions = @ar_transactions.paid if params[:paid] == 'true'
    @ar_transactions = @ar_transactions.unpaid if params[:paid] == 'false'
    # End: Paid / Open Filter

    @open_ar_transactions = @all_ar_transactions.unpaid
    @total_count = @ar_transactions.count
    @ar_transactions = @ar_transactions.limit(limit).offset(offset)
  end

  def create
    @account = fetch_account
    credit = (params[:symbol]+params[:amount]).to_f
    @ar_transaction = @account.ar_transactions.new(hotel_id: current_hotel.id, credit: credit)
    @ar_transaction.save || render(json: @ar_transaction.errors.full_messages, status: :unprocessable_entity)
  end

  def pay_all
    @errors = []
    @account = fetch_account
    ar_transactions = current_hotel.ar_transactions.where(account_id: @account.id)
    unpaid_ar_transactions = ar_transactions.unpaid
    @open_count = unpaid_ar_transactions.count
    unpaid_ar_transactions = unpaid_ar_transactions.order('debit desc')
    unpaid_ar_transactions.each do |transaction|
      if transaction.pay
        @open_count -= 1
      else
        @errors << t(:insufficient_credits)
      end
    end
  end

  def pay
    @account = fetch_account
    open_ar_transactions = current_hotel.ar_transactions.where(account_id: @account.id).unpaid
    ar_transaction = open_ar_transactions.find(params[:id])
    @open_count = open_ar_transactions.count
    if ar_transaction.pay
      @open_count -= 1
    else
      render(json: [t(:insufficient_credits)], status: :unprocessable_entity)
    end
  end

  def open
    @account = fetch_account
    paid_ar_transactions = current_hotel.ar_transactions.where(account_id: @account.id).paid
    ar_transaction = paid_ar_transactions.find(params[:id])
    ar_transaction.open 
    @open_ar_transactions = @account.ar_transactions.where(hotel_id: current_hotel.id).debits.unpaid
  end

  private

  def fetch_account
    current_hotel.hotel_chain.accounts.find(params[:account_id])
  end
end
