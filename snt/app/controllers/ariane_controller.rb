class ArianeController < ApplicationController
  SUCCESS_MESSAGE = 'SUCCESS'
  SUCCESS_ERROR_ID = '0'
  FAILURE_ERROR_ID = '3'

  NAMESPACE = 'http://www.ariane-systems.com/'

  soap_service namespace: NAMESPACE, snakecase_input: true, camelize_wsdl: true, wsdl_style: 'document'

  after_filter :convert_response_xml, only: [:get_reservation]

  soap_action :get_reservation,
              args: {
                'request' => {
                  kiosk_id: :string,
                  kiosk_type: :string,
                  hotel_id: :string,
                  sequence_id: :string,
                  filter: {
                    reservation_number: :string,
                    target_reservation_type: :string,
                    name_is_exact_match: :boolean
                  }
                }
              },
              return: {
                get_reservation_result: {
                  kiosk_id: :string,
                  kiosk_type: :string,
                  sequence_id: :string,
                  error_id: :int,
                  warning_id: :int,
                  message: :string,
                  reservations: {
                    reservation: [
                      internal_reservation_number: :string,
                      public_reservation_number: :string,
                      start_date: :dateTime,
                      end_date: :dateTime,
                      business_date: :dateTime,
                      number_of_adults: :int,
                      number_of_children: :int,
                      number_of_persons_paying_city_tax: :int,
                      room_key_compartment: :int,
                      room: {
                        room_number: :string,
                        room_type: {
                          type_code: :string,
                          long_description: :string,
                          capacity: :int,
                          additional_bed: :int
                        },
                        room_status: :string
                      },
                      customer: {
                        last_name: :string,
                        first_name: :string,
                        gender: :string,
                        birth_date: :dateTime
                      },
                      total_balance_i_t: :decimal,
                      total_amount_i_t: :decimal,
                      total_v_a_t: :decimal,
                      total_paid_i_t: :decimal,
                      deposit_i_t: :decimal,
                      nb_of_nights_already_paid: :int,
                      message_count: :int,
                      first_night_balance: :decimal,
                      is_group_reservation: :boolean
                    ]
                  }
                }
              }
  def get_reservation
    error_message = nil

    logger.debug 'ARIANE - Starting SOAP GetReservation'

    begin
      request = params['request']
      hotel_code = request[:hotel_id]
      reservation_id = request.andand[:filter].andand[:reservation_number]

      hotel = Hotel.find_by_code(hotel_code)

      if !hotel
        error_message = 'Hotel not found'
      else
        reservation = hotel.reservations.find_by_id(reservation_id)

        if !reservation
          error_message = 'Reservation not found'
        else
          room = reservation.current_daily_instance.room

          if !room
            error_message = 'Room is not assigned'
          else
            reservation_response = get_reservation_response(reservation, room)
          end
        end
      end
    rescue NoMethodError => e
      error_message = 'SYSTEM ERROR: Please validate request format'
    end

    if error_message
      logger.warn "ARIANE - Error: #{error_message}"
    else
      logger.debug "ARIANE - Reseration Found: #{reservation.id}"
    end

    response = {
      get_reservation_result: {
        error_id: error_message ? FAILURE_ERROR_ID : SUCCESS_ERROR_ID,
        warning_id: 0,
        kiosk_id: request.andand[:kiosk_id],
        kiosk_type: request.andand[:kiosk_type],
        sequence_id: request.andand[:sequence_id],
        message: error_message || SUCCESS_MESSAGE
      }
    }

    response[:get_reservation_result][:reservations] = reservation_response unless error_message

    logger.debug 'ARIANE - Ending SOAP GetReservation'

    render soap: response
  end

  private

  def get_reservation_response(reservation, room)
    room_type = room.room_type
    guest = reservation.primary_guest

    {
      reservation: [
        internal_reservation_number: reservation.id,
        public_reservation_number: reservation.confirm_no,
        start_date: format_date_time(reservation.arrival_date),
        end_date: format_date_time(reservation.dep_date),
        business_date: format_date_time(reservation.hotel.active_business_date),
        number_of_adults: 1,
        number_of_children: 0,
        number_of_persons_paying_city_tax: 0,
        room_key_compartment: 0,
        room: {
          room_number: room.room_no,
          room_type: {
            type_code: room_type.room_type,
            long_description: room_type.description,
            capacity: 1,
            additional_bed: 0
          },
          room_status: 'Clean'
        },
        customer: {
          last_name: guest.last_name,
          first_name: guest.first_name,
          gender: 'Male',
          birth_date: format_date_time(Date.today)
        },
        total_balance_i_t: 0,
        total_amount_i_t: 0,
        total_v_a_t: 0,
        total_paid_i_t: 0,
        deposit_i_t: 0,
        nb_of_nights_already_paid: 0,
        message_count: 0,
        first_night_balance: 0,
        is_group_reservation: false
      ]
    }
  end

  def format_date_time(date)
    date.strftime('%Y-%m-%dT%H:%M:%S')
  end

  def convert_response_xml
    doc = Nokogiri::XML(response.body)

    # Add the namespace to the response tag (first child inside body)
    doc.xpath('//soap:Body').first.element_children.first.default_namespace = NAMESPACE

    # Remove whitespace between tags
    response.body = doc.to_xml.gsub(/>\s*</, '><')
  end
end
