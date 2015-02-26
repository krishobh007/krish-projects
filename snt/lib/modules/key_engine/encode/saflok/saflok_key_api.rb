class SaflokKeyApi
  def self.request_key(reservation, room_no, no_of_keys, options)
    logger.debug 'SAFLOK: Requesting key'

    keys = []
    errors = []

    hotel = reservation.hotel
    uid = options[:uid]
    encoder_id = options[:encoder_id]
    is_kiosk = options[:is_kiosk]

    access_url = hotel.settings.key_access_url # http://winserver.stayntouch.com/LensPMSWebService
    username = hotel.settings.key_username
    password = hotel.settings.key_password
    key_system = hotel.key_system
    if !access_url || !username || !password
      errors << 'Saflok key settings are missing'
    elsif !uid.present? && !is_kiosk && !(key_system.value == 'SAFLOK_MSR')
      errors << 'uid is a required field'
    else
      endpoint = "#{access_url}/MessengerPMSService.asmx"

      begin
        client = Savon.client(endpoint: endpoint, namespace: 'http://tempuri.org', soap_header: soap_header(username, password),
                              logger: Rails.logger, ssl_verify_mode: :none, raise_errors: false)

        if options[:is_additional]
          # Request the additional key
          result = make_duplicate_key(client, reservation, uid, encoder_id)
        else
          # Request the first key
          result = create_new_booking(client, reservation, room_no, uid, encoder_id)
        end

        if result[:status]
          keys << result[:data]
        else
          errors += result[:errors]
        end
      rescue => ex
        errors << 'Unable to connect to Saflok'
        logger.error 'SAFLOK: Unable to connect - Exception: ' + ex.message
      end
    end

    if errors.empty?
      { status: true, data: keys, errors: [] }
    else
      { status: false, data: [], errors: errors }
    end
  end

  # Define the SOAP Header
  def self.soap_header(username, password)
    {
      'AuthHeader' => {
        'Security' => {
          'UsernameToken' => {
            'Username' => username,
            'Password' => password
          },
          :attributes! => {
            'UsernameToken' => { xmlns: 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd' }
          }
        }
      },
      :attributes! => {
        'AuthHeader' => { xmlns: 'http://tempuri.org' }
      }
    }
  end

  # Create the first key from Saflok
  def self.create_new_booking(client, reservation, room_no, uid, encoder_id)
    response = client.call('CreateNewBooking', soap_action: 'http://tempuri.org/CreateNewBooking', attributes: request_attributes,
                                               message: create_new_booking_message(reservation, room_no, uid, encoder_id))

    # Remove the namespaces from the response to simplify parsing
    response.doc.remove_namespaces!

    parse_response(response.xpath('//CreateNewBookingResponse'))
  end

  # Create additional key from Saflok
  def self.make_duplicate_key(client, reservation, uid, encoder_id)
    response = client.call('MakeDuplicateKey', soap_action: 'http://tempuri.org/MakeDuplicateKey', attributes: request_attributes,
                                               message: make_duplicate_key_message(reservation, uid, encoder_id))

    # Remove the namespaces from the response to simplify parsing
    response.doc.remove_namespaces!

    parse_response(response.xpath('//MakeDuplicateKeyResponse'))
  end

  # Define the namespace in the request attributes
  def self.request_attributes
    { xmlns: 'http://tempuri.org' }
  end

  # Define the create new booking message
  def self.create_new_booking_message(reservation, room_no, uid, encoder_id)
    {
      'ReservationID' => reservation.confirm_no,
      'SiteName' => reservation.hotel.code,
      'PMSTerminalID' => 1,
      'EncoderID' => encoder_id || 0,
      'CheckIn' => (reservation.arrival_date + 18.hours).strftime('%Y-%m-%dT%H:%M:%S'),
      'CheckOut' => (reservation.dep_date + 18.hours).strftime('%Y-%m-%dT%H:%M:%S'),
      'GuestName' => reservation.primary_guest.full_name,
      'MainRoomNo' => strip_leading_zeros(room_no),
      'bGrantAccessPredefinedSuiteDoors' => false,
      'KeyCount' => 1,
      'KeySize' => 1,
      'TrackIIFolioNo' => '',
      'TrackIGuestNo' => '',
      'UID' => uid,
      :attributes! => {
        'GuestName' => { xmlns: 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd' }
      }
    }
  end

  # Define the make duplicate key message
  def self.make_duplicate_key_message(reservation, uid, encoder_id)
    {
      'ReservationID' => reservation.confirm_no,
      'SiteName' => reservation.hotel.code,
      'PMSTerminalID' => 1,
      'EncoderID' => encoder_id || 0,
      'KeyCount' => 1,
      'KeySize' => 1,
      'UID' => uid
    }
  end

  # Parse the response and obtain the key data in base64
  def self.parse_response(operation_response)
    errors = []
    data = nil

    status = operation_response.xpath('//bSuccess').text == 'true'

    if status
      data = { base64: operation_response.xpath('//retAccessKey').text }
    else
      errors << operation_response.xpath('//Fault/detailInfo').text
    end

    { status: status, data: data, errors: errors }
  end

  # Strips the leading zeros off of the value
  def self.strip_leading_zeros(value)
    value.andand.sub(/\A0+/, '')
  end
end
