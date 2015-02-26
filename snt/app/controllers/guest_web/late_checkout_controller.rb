class GuestWeb::LateCheckoutController < ApplicationController
  before_filter :check_session

  layout 'guestweb'

  # Get late checkout charges configured for the hotel
  def get_late_checkout_charges
    reservation = Reservation.find(params[:reservation_id])
    current_hotel = reservation.andand.hotel
    hotel = current_hotel if current_hotel
    late_checkout_charges = {}

    if !hotel.late_checkout_charges.empty? &&
      reservation.is_late_checkout_available?
      late_checkout_charges = ViewMappings::GuestWeb::WebCheckoutMapping.map_late_checkout_charges(hotel.late_checkout_charges)
    end
    render json: late_checkout_charges
  end

  def apply_late_checkout
    status = true
    reservation = Reservation.find(params[:reservation_id])
    late_checkout_offer = LateCheckoutCharge.find(params[:late_checkout_offer_id])
    status = make_payment(reservation, late_checkout_offer.extended_checkout_charge) if params[:is_cc_attached_from_guest_web]
    if status
      status = reservation.apply_late_checkout(params, :WEB) 
      begin
        reservation.send_late_checkout_staff_alert_emails(status[:status], status[:errors])
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        @logger ||= Logger.new('log/EmailNotifications.log')
        @logger.info "Warning: Late Check Out  - Staff Alert - Email not sent to #{recipient} : #{e.message}"
      end
      status = status[:status]
    end
    render json: { status:  status }
  end

  private

  def make_payment(reservation, amount)
    bill = reservation.bills.first
    card_data = reservation.bill_payment_method(1)
    # if hotel is pms config
    hotel = reservation.hotel
    if hotel.is_third_party_pms_configured?
      result = reservation.make_reservation_payment(card_data, 1, amount)
      return result[:status]
    else
      # call post_payment
      charge_code = card_data.charge_code(hotel) if card_data
      transaction = reservation.post_transaction(bill, amount, charge_code.id, hotel.active_business_date) if charge_code
      return true if transaction
    end
  end
end
