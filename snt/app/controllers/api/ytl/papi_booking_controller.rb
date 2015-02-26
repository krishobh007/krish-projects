# References:
# 1. http://testwebservices.yotel.com/papiGeneral.asmx?WSDL
# 2. https://stayntouch.atlassian.net/secure/attachment/17706/PAPI%20Overview%20for%20Hourly%20Booking%20v1_3.pdf

class Api::Ytl::PapiBookingController < ApplicationController
  # Now this controller is defined to work only for Yotel hotel chain.
  # We may have to remove the hard coded hotel chain once we start to accept it dynamically.
  before_filter :authenticate_user, :log_request, :only => [:fetch_hourly_availability, :check_and_lock_available_rooms, :check_and_unlock_room, :process_hourly_booking, :check_booking_exists, :update_resource_occupant]
  
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

  YOTEL_LOGGER.info("Info from papai_booking_controller")

  # Method to convert the input date time in hotel time zone to UTC
  def convert_hotel_time_to_utc(date_time_string, current_hotel)
    current_hotel_time_zone = current_hotel.tz_info
    # We are formatting this date_time_string to satndardize the input and to avoid any unexpected data coming through 
    formatted_date_time_string = DateTime.parse(date_time_string).strftime('%Y-%m-%dT%H:%M:%S')
    DateTime.parse(formatted_date_time_string + current_hotel_time_zone).utc
  end

  # Method to convert the UTC date time object in database to date time in hotel time zone 
  def convert_utc_to_hotel_time(date_time_object, time_zone)
    date_time_object.in_time_zone(time_zone)
  end

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

  # The API check for the availability of room types in the given location for the provided date range.
  soap_action 'PBGetHourlyAvailability',
    args: {
      apiUser: :string,
      apiPass: :string,
      locationId: :integer,
      dateFrom: :string,
      dateTo: :string,
      #bookingId: :string, not adding now since we are not using this. Also, it was not given in the provided sample request.
    },
    return: {
      PBGetHourlyAvailabilityResult: {
        ResponseHeader: ResponseHeader,
        PriceChangeID: :string,
        AvailableTypes: {
          AvailableType: [
            {
              ResourceType: :string,
              Price: :float,
              NoAvailable: :integer
            }
          ]
        }
      }
    },
    to: :fetch_hourly_availability

  # API to lock a room if available
  soap_action 'PBLockPending',
    args: {
      apiUser: :string,
      apiPass: :string,
      locationId: :integer,
      bookingId: :integer,
      resourceType: :string,
      dateFrom: :string,
      dateTo: :string,
      noToLock: :integer,
      returnPrice: :boolean,
      priceChangeID: :string
    },
    return: {
      PBLockPendingResult: {
        ResponseHeader: ResponseHeader,
        BookingID: :integer,
        LockedResources: {
          LockedResource: [
            ResourceName: :string,
            Price: :float,
            OccupantID: :string
          ]
        }
      }
    },
    to: :check_and_lock_available_rooms

  # API to unlock a locked room
  soap_action 'PBUnlockPending',
    args: {
      apiUser: :string,
      apiPass: :string,
      bookingId: :integer
    },
    return: {
      PBUnlockPendingResult: {
        ErrNo: :integer,
        ErrNoDesc: :string
      }
    },
    to: :check_and_unlock_room

  class CustomerDetail < WashOut::Type
    map Title: :string,
        Forename: :string,
        Surname: :string,
        Add1: :string,
        Add2: :string,
        Town: :string,
        County: :string,
        Country: :string,
        Postcode: :string,
        TelNo: :string,
        MobNo: :string,
        Email: :string,
        CCNo: :string,
        CCName: :string,
        CCType: :string,
        CCFrom: :string,
        CCExpiry: :string,
        CCIssNo: :string,
        CCSecNo: :string
  end

  class Occupant < WashOut::Type
    map Occupant:
    [
      BookingID: :integer,
      OccupantID: :string,
      Title: :string,
      Forename: :string,
      Surname: :string,
      ResourceName: :string,
      Price: :double
    ]
  end

  class Booking < WashOut::Type
    map Booking:
    [
      BookingID: :integer,
      Occupants: Occupant
    ]
  end

  class Payment < WashOut::Type
    map Payment:
    [
      Type: :string,
      Amount: :double,
      OrderID: :string,
      AuthCode: :string,
      Reference: :string,
      CardCharge: :double
    ]
  end

  class HourlyBookingDetails < WashOut::Type
    map Source: :string,
        CustomerDetail: CustomerDetail,
        Bookings: Booking,
        Payments: Payment,
        SendSMS: :string
  end

  # API to process hourly booking
  soap_action 'PBProcessHourlyBooking',
    args: {
      apiUser: :string,
      apiPass: :string,
      HourlyBookingDetails: HourlyBookingDetails
    },
    return: {
      PBProcessHourlyBookingResult: {
        ResponseHeader: ResponseHeader,
        CustomerID: :integer
      }
    },
    to: :process_hourly_booking

  # API to check whether a booking exists
  soap_action 'PBUpdateLock',
    args: {
      apiUser: :string,
      apiPass: :string,
      bookingId: :integer
    },
    return: {
      PBUpdateLockResult: {
        ResponseHeader: ResponseHeader
      }
    },
    to: :check_booking_exists

  class OccupantForUpdate < WashOut::Type
    map BookingID: :integer,
        OccupantID: :string,
        Title: :string,
        Forename: :string,
        Surname: :string,
        Price: :double,
        AllowExtras: :string
  end

  # API to check whether a booking exists
  soap_action 'PBUpdateResourceOccupant',
    args: {
      apiUser: :string,
      apiPass: :string,
      occupant: OccupantForUpdate
    },
    return: {
      PBUpdateResourceOccupantResult: {
        ResponseHeader: ResponseHeader
      }
    },
    to: :update_resource_occupant

  def update_resource_occupant
    response = {}
    response['PBUpdateResourceOccupantResult'] = {}
    @valid_user = authorize(params)
    if !@valid_user
      response_header = ERROR[:failed_to_login]
    else
      begin
        params_occupant = params[:occupant]
        pre_reservation = PreReservation.find(params_occupant[:BookingID])
        response_header = ERROR[:ok] if pre_reservation.present?
      rescue Exception => e
        response_header = ERROR[:booking_exists_no_longer]
      end
    end
    response['PBUpdateResourceOccupantResult'][:ResponseHeader] = response_header
    final_response = render soap: response
    log_response(final_response)
    final_response
  end

  def check_booking_exists
    response = {}
    response['PBUpdateLockResult'] = {}
    @valid_user = authorize(params)
    if !@valid_user
      response_header = ERROR[:failed_to_login]
    else
      begin
        pre_reservation = PreReservation.find(params[:bookingId])
        if pre_reservation.present?
          pre_reservation.updated_at = DateTime.now.utc
          response_header = ERROR[:ok] if pre_reservation.save!
        end
      rescue Exception => e
        response_header = ERROR[:booking_exists_no_longer]
      end
    end
    response['PBUpdateLockResult'][:ResponseHeader] = response_header
    final_response = render soap: response
    log_response(final_response)
    final_response
  end

  # Begin methods for PBGetHourlyRates
  def fetch_hourly_availability
    begin
      @valid_user = authorize(params)
      response = {}
      response['PBGetHourlyAvailabilityResult'] = {}
      current_hotel = Hotel.find(params[:locationId])
      difference_hours = ( ( Time.parse(params[:dateTo]) - Time.parse(params[:dateFrom]) ) / 1.hours)
      if !@valid_user
        response_header = ERROR[:failed_to_login]
      elsif current_hotel.hotel_chain != @@hotel_chain
        #User is not supposed to access a hotel outside the provided chain
        response_header = ERROR[:unauthorized]
        response_header[:ErrNoDesc] = "Unauthorized since the given location does not belongs to the #{@@hotel_chain.code} hotel chain"
      else
        current_hotel = Hotel.find(params[:locationId])
        hourly_rate = current_hotel.rates.active.fully_configured.include_public_only.not_expired(params[:begin_date]).non_contract.where('is_hourly_rate = true').first 
        params[:hourly_rate_id] = hourly_rate.id
        response = {}
        response['PBGetHourlyAvailabilityResult'] = {}
        response['PBGetHourlyAvailabilityResult'][:PriceChangeID] = hourly_rate.id
        response['PBGetHourlyAvailabilityResult'][:AvailableTypes] = {}
        response_header = ERROR[:ok]
        response['PBGetHourlyAvailabilityResult'][:AvailableTypes][:AvailableType] = fetch_room_type_availability_details(params)
      end
    rescue Exception => e
      response_header = { ErrNo: 5, ErrNoDesc: e.message }
    end
    response['PBGetHourlyAvailabilityResult'][:ResponseHeader] = response_header
    final_response = render soap: response
    log_response(final_response)
    final_response
  end

  def fetch_room_type_availability_details(params)
    current_hotel = Hotel.find(params[:locationId])
    hourly_rate = Rate.find(params[:hourly_rate_id])
    room_types = hourly_rate.room_types.is_not_pseudo

    pre_reservation_from_time = convert_hotel_time_to_utc(params[:dateFrom], current_hotel)
    pre_reservation_to_time = convert_hotel_time_to_utc(params[:dateTo], current_hotel)

    begin_date = pre_reservation_from_time.in_time_zone(current_hotel.tz_info).to_date
    end_date = pre_reservation_to_time.in_time_zone(current_hotel.tz_info).to_date

    available_rooms =  RoomAvailability.available_rooms(current_hotel, room_types, pre_reservation_from_time, pre_reservation_to_time, exclude_locked_rooms=true)
    available_room_details = available_rooms.select([:id, :room_type_id])
    room_type_ids = available_room_details.pluck(:room_type_id).uniq
    # For PBLockPending
    if params[:room_type_id].present?
      room_type = RoomType.find(params[:room_type_id])
      # Method: lock_available_rooms(params)
      if params[:need_available_room_ids].present?
        result = available_room_details.where(room_type_id: params[:room_type_id]).pluck(:id)
      # Method: check_and_lock_available_rooms
      else
        result =  {
                    ResourceType: room_type.room_type,
                    Price: hourly_rate.calculate_hourly_rate_amount(pre_reservation_from_time.to_date, room_type, pre_reservation_from_time, pre_reservation_to_time),
                    NoAvailable: available_room_details.where(room_type_id: room_type.id).count
                  } 
      end
    # For PBGetHourlyAvailability, method: fetch_hourly_availability(params)
    else
      YOTEL_LOGGER.info("Current hotel time zone (Availability API): #{current_hotel.tz_info}")
      result = []
      room_type_ids.each do |room_type_id|
        room_type = RoomType.find(room_type_id)
        available_room_type = {
                              ResourceType: room_type.room_type,
                              Price: hourly_rate.calculate_hourly_rate_amount(pre_reservation_from_time.to_date, room_type, pre_reservation_from_time, pre_reservation_to_time),
                              NoAvailable: available_room_details.where(room_type_id: room_type.id).count
                            } 
        result << available_room_type if ( (available_room_type[:NoAvailable] > 0) && (available_room_type[:Price] > 0) )
      end
    end
    result
  end

  # End methods for PBGetHourlyRates

  # Begin methods for PBlockPending 
  def check_and_lock_available_rooms
    # check 'noToLock' number of rooms of 'resourceType' are available
    # if available lock 'noToLock' of rooms and return locked rooms with resourceType, price and occupantID
    begin
      response = {}
      response['PBLockPendingResult'] = {}
      response['PBLockPendingResult'][:lockedResources] = {}
      difference_hours = ( DateTime.parse(params[:dateTo]) - DateTime.parse(params[:dateFrom]) ) / 1.hours
      @valid_user = authorize(params)
      if !@valid_user
        response_header = ERROR[:failed_to_login]
      elsif @@hotel_chain.hotels.empty?
        response_header = { ErrNo: 5, ErrNoDesc: "No hotels found for the hotel chain #{@@hotel_chain}" }
      elsif difference_hours >= 24
        response_header = {ErrNo: 41, ErrNoDesc: "Hourly booking cannot be made for a duration of or more than 24 hours"}
      else
        current_hotel = Hotel.find(params[:locationId])
        params[:hourly_rate_id] = params[:priceChangeID]
        room_type = current_hotel.room_types.where(room_type: params[:resourceType]).first
        params[:room_type_id] = room_type.id
        availability_result = fetch_room_type_availability_details(params)
        availability_count = availability_result[:NoAvailable]
        is_available = availability_count > 0 ? true : false
        if is_available
          params[:price_for_stay] = availability_result[:Price]
          result = lock_available_rooms(params)
          if result[:response_header][:error_no] = 0
            response['PBLockPendingResult'][:BookingID] = result[:BookingID]
            response['PBLockPendingResult'][:LockedResources] = {}
            response['PBLockPendingResult'][:LockedResources][:LockedResource] = result[:LockedResource]
          else
            response['PBLockPendingResult'][:bookingID] = 0
          end
          response_header = result[:response_header]
        else
          response_header = ERROR[:resource_no_longer_available]
          response['PBLockPendingResult'][:bookingID] = 0
        end
      end
    rescue Exception => e
      response_header = { ErrNo: 5, ErrNoDesc: e.message }
    end
    response['PBLockPendingResult'][:ResponseHeader] = response_header
    final_response = render soap: response
    log_response(final_response)
    final_response
  end

  def lock_available_rooms(params)
    current_hotel = Hotel.find(params[:locationId])
    room_type = current_hotel.room_types.where(room_type: params[:resourceType]).first
    user = User.find_by_login(params[:apiUser])
    rate = Rate.find(params[:priceChangeID])
    pre_reservation_from_time = convert_hotel_time_to_utc(params[:dateFrom], current_hotel)
    pre_reservation_to_time = convert_hotel_time_to_utc(params[:dateTo], current_hotel)
    params[:room_type_id] = room_type.id
    params[:need_available_room_ids] = true
    available_room_ids = fetch_room_type_availability_details(params)
    #locked_rooms_is = []
    room_ids_can_be_locked_array = select_room_for_locking(available_room_ids, pre_reservation_from_time, pre_reservation_to_time)
    if room_ids_can_be_locked_array.empty?
      response_header = ERROR[:resource_no_longer_available]
    elsif (params[:bookingId].present? && params[:bookingId] > 0 )
      pre_reservation = PreReservation.where(id: params[:bookingId]).first
      if !pre_reservation.present?
        response_header = ERROR[:booking_exists_no_longer]
      elsif !room_ids_can_be_locked_array.include? pre_reservation.room_id
        response_header = ERROR[:resource_no_longer_available]
      else
        pre_reservation.from_time = pre_reservation_from_time
        pre_reservation.to_time = pre_reservation_to_time
        saved_pre_reservation = pre_reservation if pre_reservation.save!
        response_header = ERROR[:ok]
      end
    else
      room = Room.find(room_ids_can_be_locked_array.first)
      pre_reservation = PreReservation.new(user: user, room: room, from_time: pre_reservation_from_time, to_time: pre_reservation_to_time, rate: rate)
      saved_pre_reservation = pre_reservation if pre_reservation.save!
      response_header = ERROR[:ok]
    end
    
    result = {}
    if saved_pre_reservation.present?
      response_header = ERROR[:ok]
      result[:BookingID] = pre_reservation.id
      result[:LockedResource] = []
      locked_resource = {}
      locked_resource[:ResourceName] = pre_reservation.room.room_no
      locked_resource[:Price] = params[:price_for_stay]
      locked_resource[:OccupantID] = 'A'
      result[:LockedResource] << locked_resource
    end
    result[:response_header] = response_header
    result
  end

  def select_room_for_locking(room_ids, pre_reservation_from_time, pre_reservation_to_time)
    room_ids_array = []
    room_ids.each do |room_id|
      room = Room.find(room_id)
      existing_reservation_count = room.reservation_daily_instances.joins(:reservation).
                                         where("reservations.arrival_time <= ? and reservations.departure_time >= ?", 
                                         pre_reservation_to_time, pre_reservation_from_time).where("reservations.status_id NOT IN (?,?)", 
                                         Ref::ReservationStatus[:NOSHOW].id, Ref::ReservationStatus[:CANCELED].id).uniq.count
      room_ids_array << room_id if existing_reservation_count <= 0
    end
    room_ids_array
  end
  # End methods for PBLockPending
  # Begin methods for PBUnlockPending
  def check_and_unlock_room
    begin
      response_header = {}
      @valid_user = authorize(params)
      if !@valid_user
        response_header = ERROR[:failed_to_login]
      elsif @@hotel_chain.hotels.empty?
        response_header = { ErrNo: 5, ErrNoDesc: "No hotels found for the hotel chain #{@@hotel_chain}" }
      else
        pre_reservation = PreReservation.find(params[:bookingId])
        pre_reservation.delete 
        response_header = ERROR[:ok]
      end
    rescue Exception => e
      response_header = { ErrNo: 5, ErrNoDesc: e.message }
    end
    response = {}
    response['PBUnlockPendingResult'] = response_header
    final_response = render soap: response
    log_response(final_response)
    final_response
  end
  # End methods for PBUnlockPending
  # Begin methods for PBProcessHourlyBooking
  def process_hourly_booking
    response = {}
    response['PBProcessHourlyBookingResult'] = {}
    @valid_user = authorize(params)
    if !@valid_user
      response_header = ERROR[:failed_to_login]
    else
      begin
        pre_reservation = PreReservation.where(id: params['HourlyBookingDetails']['Bookings']['Booking'].first['BookingID']).first
        if pre_reservation.present?
          current_hotel = pre_reservation.room.hotel
          country_id = Country.find_by_code(params['HourlyBookingDetails']['CustomerDetail']['Country']).andand.id
          guest_attributes = map_guest_attributes
          guest_attributes[:address][:country_id] = country_id if country_id
          
          # check guest already exists for an email
          guest_detail = GuestDetail.includes(:emails).where('additional_contacts.value = ? AND additional_contacts.is_primary = true AND hotel_chain_id = ? AND user_id IS NULL', guest_attributes[:email], current_hotel.hotel_chain.id).first
          if guest_detail.present?
            # guest_detail.update_attributes!(guest_attributes)
            guest_detail_id = guest_detail.id
          else
            # create customer
            guest_detail = GuestCreator.new(guest_attributes, current_hotel.id)
            guest_detail = guest_detail.create
            guest_detail_id = guest_detail.id if guest_detail.present?
          end

          if guest_detail_id
            
            # create booking
            passed_amount = params['HourlyBookingDetails']['Payments']['Payment'].first['Amount'] - params['HourlyBookingDetails']['Payments']['Payment'].first['CardCharge']
            reservation_attributes = reservation_attributes(pre_reservation, guest_detail_id, current_hotel.tz_info, passed_amount)
            reservation = ReservationCreator.new(reservation_attributes, current_hotel.id)
            reservation = reservation.create

            if reservation[:errors].present?
              # Error 570,  message will be Error message
              response_header = ERROR[:failed_to_create_transaction_type]
              response_header[:ErrNoDesc] = reservation[:errors].first
            else
              occupant_details_array =  params['HourlyBookingDetails']['Bookings']['Booking'].first['Occupants']['Occupant']
              YOTEL_LOGGER.info("params['HourlyBookingDetails']['Bookings']['Booking']: #{params['HourlyBookingDetails']['Bookings']['Booking']}")
              YOTEL_LOGGER.info("occupant_details_array: #{occupant_details_array}")
              if occupant_details_array.present?
                reservation_object = Reservation.find_by_hotel_id_and_confirm_no(current_hotel.id, reservation[:data][:confirm_no])
                occupant_details_array.each do |occupant_hash|
                  if reservation_object.primary_guest.first_name != occupant_hash['Forename'] && reservation_object.primary_guest.last_name != occupant_hash['Surname']
                    guest_detail = reservation_object.guest_details.create(title: occupant_hash['Title'], first_name: occupant_hash['Forename'].capitalize , last_name: occupant_hash['Surname'].capitalize, hotel_chain: current_hotel.hotel_chain)
                    guest_detail.reservations_guest_details.find_by_reservation_id(reservation_object.id).update_attributes(is_primary: false, is_accompanying_guest: true)
                  end
                end
              end
              response_header = ERROR[:ok]
              response['PBProcessHourlyBookingResult'][:CustomerID] = reservation[:data][:confirm_no]
              pre_reservation.delete
            end
          else
            # Error 570, message will be 'Unable to to create transaction type'
            response_header = ERROR[:failed_to_create_transaction_type]
          end
        else
          response_header = ERROR[:resource_no_longer_available]
        end
      rescue Exception => e
        YOTEL_LOGGER.error("Reservation Exception Backtrace: #{e.backtrace}")
        YOTEL_LOGGER.error("Reservation Exception Message: #{e.message}")
        response_header = ERROR[:failed_to_create_transaction_type]
      end
    end
    response['PBProcessHourlyBookingResult'][:ResponseHeader] = response_header
    final_response = render soap: response
    log_response(final_response)
    final_response
  end

  def map_guest_attributes
    guest_params = params['HourlyBookingDetails']['CustomerDetail']
    {
      title: guest_params['Title'],
      first_name: guest_params['Forename'],
      last_name: guest_params['Surname'],
      email: guest_params['Email'],
      phone: guest_params['TelNo'],
      mobile: guest_params['MobNo'],
      address: {
        street1: (guest_params['Add1'].to_s+ " " + guest_params['Add2'].to_s).strip,
        city: guest_params['Town'],
        state: guest_params['County'],
        postal_code: guest_params['Postcode']
      }
    }
  end

  def payment_type_attributes(pre_reservation)
    payment_params = params['HourlyBookingDetails']['CustomerDetail']
    bill_params = params['HourlyBookingDetails']['Payments']['Payment'].first
    payment_attrs = {}
    # check whether payment type available in custom payment methods
    payment_type = pre_reservation.room.hotel.payment_types.where(value: bill_params[:Type]).last
    if payment_type.present?
      payment_attrs = 
      {
        type_id: payment_type.present? ? payment_type.id : nil,
        credit_card_transactions_attributes: {
          amount:                       bill_params['Amount'],
          credit_card_transaction_type: Ref::CreditCardTransactionType[:PAYMENT],
          external_transaction_ref:     bill_params['PassRef'],
          merchant_id:                  bill_params['MerchantAccount'],
          req_reference_no:             bill_params['Reference'],
          authorization_code:           bill_params['AuthCode'],
          hotel: pre_reservation.room.hotel
        }
      }
      if payment_params[:CCNo].present? && payment_params[:CCExpiry].present? && payment_params[:CCName].present?
        payment_attrs = {
          card_number: payment_params[:CCNo],
          expiry_date: payment_params[:CCExpiry].present? ? Date.parse(payment_params[:CCExpiry]).to_s : nil,
          card_name: payment_params[:CCName]
        }
      end
    end
    payment_attrs
  end

  def map_bill_attributes(pre_reservation)
    bill_params = params['HourlyBookingDetails']['Payments']['Payment'].first
    comments = 'AuthCode: ' + bill_params[:AuthCode].to_s + 'CardCharge: ' + bill_params[:CardCharge].to_s + 'OrderID: ' + bill_params[:OrderID].to_s
    comments += 'Reference: ' + bill_params[:Reference].to_s
    user = User.find_by_login(params[:apiUser])
    charge_code_list = pre_reservation.room.hotel.charge_codes
    # find charge code
    charge_codes = charge_code_list.payment
    # check whether payment type available in custom payment methods
    payment_type = pre_reservation.room.hotel.payment_types.where(value: bill_params[:Type]).last
    charge_code = charge_codes.find_by_associated_payment_id(payment_type.id) if payment_type
    bill_info = []
    bill_items = []
    amt = bill_params['Amount'].present? ? bill_params['Amount'].to_f * -1 : 0 # setting as -ve as its credit payment
    fees_info = charge_code.andand.fees_information
    child_transactions = []
    if fees_info && fees_info[:charge_code_id]
      fees_charge_code = charge_code_list.find(fees_info[:charge_code_id])
      
      if fees_charge_code && bill_params[:CardCharge] != 0
        child_transactions << {
          date: DateTime.now,
          amount: bill_params[:CardCharge],
          currency_code: '',
          revenue_group: '',
          charge_code_id: fees_charge_code.id,
          updater_id: user.id,
          creator_id: user.id
        }
      end

    end
    if amt != 0
      bill_items << {
        date: DateTime.now,
        amount: amt,
        currency_code: '',
        revenue_group: '',
        transaction_no: bill_params['AuthCode'],
        reference_text: bill_params[:Reference].to_s,
        charge_code: charge_code.present? ? charge_code.charge_code : nil,
        comments: comments,
        updater_id: user.id,
        creator_id: user.id,
        child_transactions_attributes: child_transactions
      }
    end
    bill_info << {
      bill_no: 1,
      bill_items: bill_items
    }
    bill_info
  end

  def reservation_attributes(pre_reservation, guest_detail_id, tz_info, passed_amount)
    arrival_date = pre_reservation.from_time.in_time_zone(tz_info).to_date
    departure_date = pre_reservation.to_time.in_time_zone(tz_info).to_date
    result =
    {
      arrival_date: arrival_date,
      arrival_time: pre_reservation.from_time,
      departure_date: departure_date,
      departure_time: pre_reservation.to_time,
      room_type_id: pre_reservation.room.room_type.id,
      room_id: [pre_reservation.room.id],
      guest_detail_id: guest_detail_id,
      stay_dates: build_and_return_stay_dates(pre_reservation, arrival_date, departure_date),
      status: :RESERVED,
      is_hourly: true,
      passed_rate_amount: passed_amount,
      creator_id: @current_api_user.id,
      updator_id: @current_api_user.id
    }
    payment_attrs = payment_type_attributes(pre_reservation)
    result[:payment_type] = payment_attrs if payment_attrs.present?
    bill_attrs = map_bill_attributes(pre_reservation)
    result[:payment] = bill_attrs if bill_attrs.present?
    result
  end
  
  def build_and_return_stay_dates(pre_reservation, arrival_date, departure_date)
    stay_dates = []
    arrival_date.upto(departure_date).each do |date|
      stay_date = {}
      stay_date[:date] = date.to_s
      stay_date[:rate_id] = pre_reservation.rate_id
      stay_date[:room_type_id] = pre_reservation.room.room_type.id
      stay_date[:adults_count] = 1
      stay_date[:children_count] = 0
      stay_date[:infants_count] = 0
      stay_dates << stay_date
    end
    stay_dates
  end
  # End methods for PBProcesshourlyBooking
end
