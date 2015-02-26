class SaltoKeyApi
  START_MESSAGE = "\x02"
  END_MESSAGE = "\x03"
  ENQUIRY_MESSAGE = "\x05"
  ACK_MESSAGE = "\x06"
  NAK_MESSAGE = "\x15"
  DELIMITER = "\xB3"

  NEW_CARD = 'CNB'
  COPY_CARD = 'CCB'

  CARD_TYPE = '4, 128'

  RECEIVE_BYTES = 1000
  RETRY_COUNT = 3
  RETRY_DELAY = 0.5 # seconds

  NOON = '1200'
  END_OF_DAY = '2359'

  def self.request_key(reservation, room_no, no_of_keys, options = {})
    logger.debug 'SALTO: Requesting key'

    keys = []
    errors = []

    hotel = reservation.hotel
    uid = options[:uid]
    is_additional = options[:is_additional]

    if !room_no || !no_of_keys || !uid
      errors << 'room_no and no_of_keys are required'
    else
      begin
        logger.debug 'SALTO: Get socket'

        socket = TCPSocket.new hotel.settings.key_access_url, hotel.settings.key_access_port

        logger.debug 'SALTO: wrap_request'
        
        request = wrap_request(issue_card_message(reservation, room_no, uid, is_additional))

        logger.debug "SALTO: Sending request: #{request}" 

        response = send_request(socket, request)

        logger.debug "SALTO: Received response: #{response}"  
        key = extract_key(response)

        if key
          keys << { image: key }
        else
          errors << 'Failed to get key image from Salto'
        end

        socket.close
      rescue => ex
        errors << 'Unable to connect to Salto'
        logger.error 'SALTO: Unable to connect - Exception: ' + ex.message
      end
    end

    { status: errors.empty?, data: keys, errors: errors }
  end

  def self.issue_card_message(reservation, room_no, uid, is_additional)
    DELIMITER + [
      is_additional ? COPY_CARD : NEW_CARD,
      uid,
      CARD_TYPE,
      room_no,
      '', '', '', '', '',
      start_date(reservation),
      end_date(reservation),
      END_MESSAGE
    ].join(DELIMITER)
  end

  def self.start_date(reservation)
    reservation.hotel.current_date.strftime('%H%M%d%m%y')
  end

  def self.end_date(reservation)
    hotel = reservation.hotel

    # If day use, set the departure time to the end of the day
    if reservation.zero_nights?
      departure_time = END_OF_DAY
    else
      departure_time = (reservation.departure_time || hotel.checkout_time).andand.strftime('%H%M') || NOON
    end

    departure_time + reservation.dep_date.strftime('%d%m%y')
  end

  def self.wrap_request(input)
    START_MESSAGE + input + lrc(input)
  end

  def self.lrc(input)
    input.bytes.reduce { |a, e| a ^ e }.chr
  end

  def self.send_request(socket, request)
    attempts = 0
    status = nil

    loop do
      socket.write request
      status = socket.recv(RECEIVE_BYTES)
      attempts += 1

      break if successful?(status) || attempts == RETRY_COUNT

      sleep RETRY_DELAY
    end

    if successful?(status)
      # Get response
      socket.recv(RECEIVE_BYTES)
    else
      fail 'request unsuccessful'
    end
  end

  def self.successful?(status)
    status == ACK_MESSAGE
  end

  def self.extract_key(response)
    valid_response = response.split(DELIMITER)[3].split(',')[2]
    valid_response = valid_response.strip if valid_response
    valid_response
  end
end
