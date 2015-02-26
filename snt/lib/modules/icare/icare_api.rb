class IcareApi
  APPROVED = 'A'
  VERSION = '1'
  LANGUAGE = 'en-US'
  TERMINAL_ID = '1'
  TERMINAL_TYPE = 'SNTPOS'
  TRANSACTION_EMPLOYEE = '1'
  REVENUE_CENTER = '1'
  SOURCE_NAME = 'customer.com'
  AUTO_CREATE_PROGRAM = 1

  def initialize(reservation)
    @reservation = reservation
    @hotel = reservation.hotel

    @username = @hotel.settings.icare_username
    @password = @hotel.settings.icare_password
    endpoint = @hotel.settings.icare_url

    @client = Savon.client(endpoint: endpoint, namespace: 'ejb.storedValue.micros.com', logger: Rails.logger, ssl_verify_mode: :none,
                           raise_errors: false)
  end

  def issue(account_number, amount)
    logger.debug 'ICARE: Issue'

    request_builder = create_builder 'SV_ISSUE', lambda { |xml|
      xml.SVAN(account_number)
      xml.Amount(amount)
    }

    submit_request request_builder
  end

  def reload(account_number, amount)
    logger.debug 'ICARE: Reload'

    request_builder = create_builder 'SV_RELOAD', lambda { |xml|
      xml.SVAN(account_number)
      xml.Amount(amount)
    }

    submit_request request_builder
  end

  def cash_out(account_number)
    logger.debug 'ICARE: Cash Out'

    request_builder = create_builder 'SV_CASHOUT', lambda { |xml|
      xml.SVAN(account_number)
      xml.Amount(0.00)
    }

    submit_request request_builder, ->(xml) { { amount: xml.xpath('//Amount').text } }
  end

  def balance_inquiry(account_number)
    logger.debug 'ICARE: Balance Inquiry'
    # As per CICO-9071, we are sending Track2 insted of SVAN
    request_builder = create_builder 'SV_BALANCE_INQUIRY', lambda { |xml|
      xml.Track2(account_number)
      xml.Amount(0.00)
    }

    submit_request request_builder, ->(xml) { { amount: xml.xpath('//AccountBalance').text } }
  end

  def  create_customer(first_name, last_name, account_number)
    logger.debug 'ICARE: Customer Creation'

    request_builder = create_builder_crm 'SetCustomer', lambda { |xml|
      xml.DataSet do
        xml.DataSetColumns do
          xml.DSColumn(name: 'AutoCreatePrograms')
          xml.DSColumn(name: 'primaryPOSRef')
          xml.DSColumn(name: 'firstName')
          xml.DSColumn(name: 'lastName')
        end
        xml.Rows do
          xml.Row do
            xml.Col(AUTO_CREATE_PROGRAM)
            xml.Col(account_number)
            xml.Col(first_name)
            xml.Col(last_name)
          end
        end
      end
    }

    submit_request request_builder, ->(xml) { { customer_id: xml.xpath('//Row/@id').text } }
  end

  private

  def create_builder(request_code, builder_process)
    now = Time.now.utc

    Nokogiri::XML::Builder.new do |xml|
      xml.SVCMessage(version: VERSION, language: LANGUAGE, currency: @hotel.default_currency.to_s) do
        xml.RequestCode(request_code)
        xml.TraceID(now.strftime('%Y%m%d%H%M%S%6N'))
        xml.TerminalID(TERMINAL_ID)
        xml.TerminalType(TERMINAL_TYPE)
        xml.LocalCurrency(@default_currency.to_s)
        xml.LocalDate(now.strftime('%Y%m%d'))
        xml.LocalTime(now.strftime('%H%M%S'))
        xml.LocalDateTime(now.iso8601(7))
        xml.BusinessDate(@hotel.active_business_date.strftime('%Y%m%d'))
        xml.TransactionEmployee(TRANSACTION_EMPLOYEE)
        xml.RevenueCenter(REVENUE_CENTER)
        xml.CheckNumber(@reservation.id)

        builder_process.call(xml)
      end
    end
  end

  def create_builder_crm(request_code, builder_process)
    Nokogiri::XML::Builder.new do |xml|
      xml.CRMMessage(version: VERSION, language: LANGUAGE, currency: @hotel.default_currency.to_s) do
        xml.RequestSource(name: SOURCE_NAME,  version: VERSION)
        xml.RequestCode(request_code)
        builder_process.call(xml)
      end
    end
  end

  # Build the message using the request xml builder
  def build_message(request_builder)
    request_string = remove_whitespace_between_tags(request_builder.to_xml)

    logger.debug('ICARE Request: ' + request_string)

    {
      'in0' => request_string,
      'in1' => @username,
      'in2' => @password,
      'in3' => Digest::CRC32.hexdigest(request_string)
    }
  end

  # Place soap request and return the results.
  def submit_request(request_builder, process_closure = ->(xml) {})
    result = nil
    start_time = Time.now

    begin
      response = @client.call('processRequest', attributes: { root: 1 }, message: build_message(request_builder))

      # Remove the namespaces from the response to simplify parsing
      response.doc.remove_namespaces!

      result = handle_response(response, process_closure)
    rescue => ex
      logger.error 'ICARE Action - Exception: ' + ex.message
      result = { status: false, errors: [I18n.t(:icare_connection_failed)] }
    end

    duration = Time.now - start_time
    logger.info "ICARE Action - Duration: #{duration}"

    result
  end

  # Parse the response and return the details
  def handle_response(response, process_closure)
    response_escaped = response.xpath('//result').text
    response_string = CGI.unescapeHTML(response_escaped)
    response_xml = Nokogiri::XML(response_string)

    response_code = response_xml.xpath('//ResponseCode').text

    if response_code == APPROVED
      { status: true, data: process_closure.call(response_xml), errors: [] }
    else
      error = response_xml.xpath('//DisplayMessage').text
      error = I18n.t(:icare_request_invalid) unless error.present? && !error.start_with?('REJECTED')
      { status: false, data: nil, errors: [error] }
    end
  end

  def remove_whitespace_between_tags(xml)
    xml.gsub(/>\s*</, '><')
  end
end
