class VingcardKeyApi
  ISSUE_CARD_CODE = 'CCA;'
  NUMBER_OF_CARDS_CODE = 'NC'
  ENCODER_ADDR_PMS_CODE = 'EA0;'
  CHECKOUT_DATE_CODE = 'CO'
  GUEST_ROOM_CODE = 'GR'
  ANSWER_MODE_CODE = 'AM1;' # Spontaneous Response

  RESPONSE_CODE = 'RC'
  ERROR_CODE = 'ET'
  TRACK3_CODE = 'T3'

  MESSAGE_TERMINATOR = "\r\n"

  SUCCESS_CODE = '0'

  def self.request_key(reservation, room_no, no_of_keys, options = {})
    logger.debug 'VINGCARD: Requesting key'

    keys = []
    errors = []

    hotel = reservation.hotel
    dep_date = reservation.dep_date

    if !room_no || !no_of_keys
      errors << 'room_no and no_of_keys are required'
    else
      begin
        socket = TCPSocket.new hotel.settings.key_access_url, hotel.settings.key_access_port

        request = issue_card_message(dep_date, room_no, no_of_keys)

        logger.debug 'VINGCARD: Sending request: ' + request

        socket.write request
        response = socket.gets

        logger.debug 'VINGCARD: Received response: ' + response

        if successful?(response)
          keys = extract_track3(response).map { |t3| { t3: t3 } }
        else
          error_message = extract_error(response)
          errors << error_message || 'Unable to obtain key'
        end

        socket.close
      rescue => ex
        errors << 'Unable to connect to Vingcard'
        logger.error 'VINGCARD: Unable to connect - Exception: ' + ex.message
      end
    end

    { status: errors.empty?, data: keys, errors: errors }
  end

  def self.issue_card_message(dep_date, room_no, no_of_keys)
    ISSUE_CARD_CODE + ENCODER_ADDR_PMS_CODE + ANSWER_MODE_CODE + check_out_date(dep_date) + guest_room(room_no) + number_of_cards(no_of_keys) +
      MESSAGE_TERMINATOR
  end

  def self.check_out_date(dep_date)
    CHECKOUT_DATE_CODE + dep_date.strftime('%Y%m%d%H%M') + ';'
  end

  def self.guest_room(room_no)
    GUEST_ROOM_CODE + room_no + ';'
  end

  def self.number_of_cards(count)
    NUMBER_OF_CARDS_CODE + count.to_s + ';'
  end

  def self.successful?(response)
    extract_response_code(response) == SUCCESS_CODE
  end

  def self.extract_response_code(response)
    extract_value(response, RESPONSE_CODE)
  end

  def self.extract_error(response)
    extract_value(response, ERROR_CODE)
  end

  def self.extract_track3(response)
    extract_values(response, TRACK3_CODE)
  end

  def self.extract_value(response, code)
    response ? response.chomp.split(';').select { |element| element.starts_with?(code) }.first.andand.gsub(code, '') : nil
  end

  def self.extract_values(response, code)
    response ? response.chomp.split(';').select { |element| element.starts_with?(code) }.map { |element| element.gsub(code, '') } : []
  end
end
