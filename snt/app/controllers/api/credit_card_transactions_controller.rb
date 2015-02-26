class Api::CreditCardTransactionsController < ApplicationController
  before_filter :check_session
  before_filter :payment_processor
  before_filter :check_business_date
  before_filter :set_payment_method, only: [:authorize, :settle, :auth_settle, :refund, :cancel, :reverse]
  before_filter :set_work_station, only: [:check_status]
  
  after_filter :record_creator_or_updater
  
  def authorize
    process_authorize(params)
  end
  
  def settle
    process_completion(params)
  end
  
  def refund
    process_refund(params)
  end
  
  def auth_settle
    process_sale(params)
  end
  
  def reverse
    process_reversal(params)
  end
  
  def cancel
    process_cancel(params)
  end
  
  def check_status
    process_check_status(params)
  end
  
  def get_token
    process_get_token(params)
    
    if @out_put_response.present?
      if @out_put_response.token.present?
        payment_type = PaymentType.credit_card
        payment_method_attributes = {
          :mli_token => @out_put_response.token,
          :payment_type => payment_type,
          :credit_card_type => Ref::CreditCardType[Setting.six_payment_card_types[@out_put_response.card_scheme_id.to_sym]],
          :is_swiped => true,
          :bill_number => params[:bill_number] || 1,
          :card_expiry => Date.strptime(@out_put_response.card_expiry_date,"%m%y").to_s
        }
        
        if params[:reservation_id].present?
          reservation = Reservation.find(params[:reservation_id])
          reservation.payment_methods.destroy_all
          @payment_method = reservation.payment_methods.create(payment_method_attributes)
        end
        
        if params[:guest_id].present? && params[:add_to_guest_card] == true
          guest = GuestDetail.find(params[:guest_id])
          @guest_payment_method = guest.payment_methods.create(payment_method_attributes)
        end
      end
    end
  end
  
  private
  
  def set_work_station
    @work_station ||= Workstation.where(:hotel_id => current_hotel.id).find(params[:work_station_id])
  end
  
  def set_payment_method
    @payment_method ||= PaymentMethod
                  .joins("INNER JOIN reservations ON reservations.id = associated_id AND associated_type = 'Reservation'")
                  .where("reservations.hotel_id = ?", current_hotel.id).find(params[:payment_method_id])
  end
  
  def payment_processor
    if payment_gateway(current_hotel) == 'sixpayments'
      class << self
         include SixPayment::ThreeCIntegra::Processor
      end
    elsif current_hotel.payment_gateway == 'MLI'
      class << self
         include MerchantLink::Lodging::Processor
      end
    else
      raise 'The hotel does not configured any payment processor'
    end
  end
  
  def record_creator_or_updater
    if @credit_card_transaction.present?
      if @credit_card_transaction.creator_id.nil?
        @credit_card_transaction.creator_id = current_user.id
      end
      @credit_card_transaction.updater_id = current_user.id
      @credit_card_transaction.save
    end
  end
end