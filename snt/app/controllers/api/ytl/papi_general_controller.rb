# References:
# 1. http://testwebservices.yotel.com/papiGeneral.asmx?WSDL
# 2. https://stayntouch.atlassian.net/secure/attachment/17706/PAPI%20Overview%20for%20Hourly%20Booking%20v1_3.pdf
# Methods supposed to be defined are 1. PBGetLocations, 2. PBGetPaymentTypes, 3. PBGetCustomerBookings,

class Api::Ytl::PapiGeneralController < ApplicationController
  # Now this controller is defined to work only for Yotel hotel chain.
  # We may have to remove the hard coded hotel chain once we start to accept it dynamically.
  before_filter :authenticate_user, :log_request, :only => [:build_locations_response, :build_payment_types_response, :get_customer_bookings]
  
  # CICO-12682
  def authenticate_user
    soap_action = request.env["wash_out.soap_action"]
    required_params = params[:Envelope][:Body][soap_action]
    @current_api_user = authenticate_api_user(required_params)
  end

  def log_request
    YOTEL_LOGGER.info("API Request: \n #{request.env["action_dispatch.request.parameters"].except!("controller", "action")}\n")
  end

  def log_response(final_response)
    YOTEL_LOGGER.info("API Response: \n #{final_response}\n")
  end

  hotel_chain_code = Setting.yotel_hotel_chain_code
  @@hotel_chain = HotelChain.find_by_code(hotel_chain_code)


  YOTEL_LOGGER.info("Info from papai_general_controller")
  
  # For authenticating the API user
  def authorize(params)
    is_valid = true
    begin
      is_valid = @current_api_user.present? ? true : false
    rescue Exception => e
      is_valid = false
    end
    is_valid
  end

  # These are the error code defined in https://stayntouch.atlassian.net/secure/attachment/17706/PAPI%20Overview%20for%20Hourly%20Booking%20v1_3.pdf
  ERROR = {
    ok: # completed without error
    { ErrNo: 0, ErrNoDesc: 'OK' },
    unknown_system_error:
    { ErrNo: 5, ErrNoDesc: 'Unknown system error' },
    failed_to_create_transaction_type:
    { ErrNo: 570, ErrNoDesc: 'Unable to to create transaction type' },
    resource_no_longer_available:
    { ErrNo: 101, ErrNoDesc: 'Resource is no longer available' },
    booking_exists_no_longer:
    { ErrNo: 201, ErrNoDesc: 'Booking no longer exists' },
    existing_booking:
    { ErrNo: 202, ErrNoDesc: 'Booking already exists' },
    failed_to_login:
    { ErrNo: 301, ErrNoDesc: 'Can not login. User does not exist or password incorrect.' },
    unauthorized:
    { ErrNo: 41, ErrNoDesc: 'Unauthorized' }
  }

  soap_service namespace: 'http://tempuri.org/', wsdl_style: 'document'

  class ResponseHeader < WashOut::Type
    map ErrNo: :integer, ErrNoDesc: :string
  end

  # Locations are hotels of the given hotel chain
  soap_action 'PBGetLocations',
    args: {
      apiUser: :string,
      apiPass: :string
    },
    return: {
      PBGetLocationsResult: {
        ResponseHeader: ResponseHeader,
        
        Locations: {
          Location: [
            {
              LocationID: :integer,
              LocationName: :string,
              Currency: :string
            }
          ]
        }
      }
    },
    to: :build_locations_response

  # Payment methods defined for all the hotels(duplicates are avoided)
  # The fields 'hand_charge_min' and 'hand_charge_perc' are not clear yet, so dummy data is given now
  soap_action 'PBGetPaymentTypes',
    args: {
      apiUser: :string,
      apiPass: :string
    },
    return: {
      PBGetPaymentTypesResult: {
        ResponseHeader: ResponseHeader,
        PaymentTypes: {
          PaymentType: [
            {
              PayType: :string,
              PayDescription: :string,
              HandChargeMin: :string,
              HandChargePerc: :string
            }
          ]
        }
      }
    },
    to: :build_payment_types_response

  # API to get all the bookings done by a customer
  soap_action 'PBGetCustomerBookings',
    args: {
      apiUser: :string,
      apiPass: :string,
      customerID: :integer,
      emailAddress: :string
    },
    return: {
      PBGetCustomerBookingsResult: {
        ResponseHeader: ResponseHeader,
        CustomerBookings: {
          CustomerBooking: [
            BookingID: :integer,
            LocationID: :integer,
            InvoiceAvailable: :boolean,
            BookingDetails: {
              OccupantID: :string,
              OccupantName: :string,
              Arrival: :datetime,
              Departure: :datetime,
              Price: :float
            }
          ]
        }
      }
    },
    to: :get_customer_bookings

  # Begin methods for PBGetLocations
  def build_locations_response
    begin
      response = {}
      response['PBGetLocationsResult'] = {}
      response['PBGetLocationsResult'][:Locations] = {}
      @valid_user = authorize(params)
      if !@valid_user
        response_header = ERROR[:failed_to_login]
      elsif @@hotel_chain.hotels.empty?
        response_header = { ErrNo: 5, ErrNoDesc: "No hotels found for the hotel chain #{@@hotel_chain}" }
      else
        response['PBGetLocationsResult'][:Locations][:Location] = fetch_location_details
        response_header = ERROR[:ok]
      end
    rescue Exception => e
      response_header = { ErrNo: 5, ErrNoDesc: e.message }
    end
    response['PBGetLocationsResult'][:ResponseHeader] = response_header
    final_response = render soap: response
    log_response(final_response)
    final_response
  end

  def fetch_location_details
    location = []
    @@hotel_chain.hotels.all.each do |hotel|
      location_detail = {}
      location_detail[:LocationID] = hotel.id
      location_detail[:LocationName] = hotel.name
      location_detail[:Currency] = hotel.default_currency.value
      location << location_detail
    end
    location
  end
  # End methods for PBGetLocations

  # Begin methods for PBGetPaymentTypes
  def build_payment_types_response
    begin
      response = {}
      response['PBGetPaymentTypesResult'] = {}
      @valid_user = authorize(params)
      if !@valid_user
         response['PBGetPaymentTypesResult'][:ResponseHeader] = ERROR[:failed_to_login]
      else
        response['PBGetPaymentTypesResult'][:PaymentTypes] = {}
        response['PBGetPaymentTypesResult'][:PaymentTypes][:PaymentType] = fetch_payment_types
        response['PBGetPaymentTypesResult'][:ResponseHeader] = ERROR[:ok]
      end
    rescue Exception => e
      error_message = e.message
    end
    if error_message.present?
      response['PBGetPaymentTypesResult'][:ResponseHeader] = ERROR[:unknown_system_error]
    end
    final_response = render soap: response
    log_response(final_response)
    final_response
  end

  def fetch_payment_types
    payment_types = []
    credit_card_types = Ref::CreditCardType.all
    hotel_credit_card_type_ids = []
    @@hotel_chain.hotels.all.each do |hotel|
      hotel_credit_card_type_ids += hotel.credit_card_types.pluck(:id)
    end
    # avoid duplicate, since different hotels will have the same CC activated
    hotel_credit_card_type_ids = hotel_credit_card_type_ids.uniq
    credit_card_types.each do |credit_card_type|
      if hotel_credit_card_type_ids.include?(credit_card_type.id)
        result = {}
        result[:PayType] = credit_card_type.value
        result[:PayDescription] = credit_card_type.description
      end
      payment_types << result
    end
    payment_types
  end
  # End methods for PBGetPaymentTypes

  # Begin methods for PBGetCustomerBookings
  def get_customer_bookings
    begin
      response = {}
      response['PBGetCustomerBookingsResult'] = {}
      @valid_user = authorize(params)
      if !@valid_user
        response_header = ERROR[:failed_to_login]
      else
        response['PBGetCustomerBookingsResult'][:CustomerBookings] = {}
        if params[:customerID].present? && params[:customerID] != 0
          @guest_detail = GuestDetail.find_by_id(params[:customerID])
        elsif params[:customerID] == 0 && params[:emailAddress].present?
          guest_detail_relation = @@hotel_chain.guest_details.joins(:emails).where('additional_contacts.value=? AND additional_contacts.is_primary=?',params[:emailAddress], true)
          if guest_detail_relation.present?
            @guest_detail = guest_detail_relation.first
          else
            @guest_detail = nil
          end 
        else
          response_header = { ErrNo: 5, ErrNoDesc: 'both customerID and emailAddress are missing!' }
        end
        if @guest_detail.nil?
          response_header = ERROR[:resource_no_longer_available]
        else
          reservations = @guest_detail.reservations
          response['PBGetCustomerBookingsResult'][:CustomerBookings][:CustomerBooking] = get_reservation_details(reservations)
          response_header = ERROR[:ok]
        end
      end
    rescue Exception => e
      response_header = ERROR[:unknown_system_error]
    end
    response['PBGetCustomerBookingsResult'][:ResponseHeader] = response_header
    final_response = render soap: response
    log_response(final_response)
    final_response
  end

  def get_reservation_details(reservations)
    customer_booking = []
    reservations.each do |reservation|
      guest_name = reservation.primary_guest_details.first.first_name + reservation.primary_guest_details.first.last_name
      reservation_details = {}
      reservation_details[:BookingID] = reservation.confirm_no
      reservation_details[:LocationID] = reservation.hotel_id
      reservation_details[:InvoiceAvailable] = reservation.bills.count == 0 ? false : true
      reservation_details[:BookingDetails] = {}
      reservation_details[:BookingDetails][:OccupantID] = 'A'
      reservation_details[:BookingDetails][:OccupantName] = guest_name
      reservation_details[:BookingDetails][:Arrival] = reservation.arrival_date
      reservation_details[:BookingDetails][:Departure] = reservation.dep_date
      reservation_details[:BookingDetails][:Price] = reservation.get_total_stay_amount.to_f
      customer_booking << reservation_details
    end
    customer_booking
  end
  # End methods for PBGetCustomerBookings
end
