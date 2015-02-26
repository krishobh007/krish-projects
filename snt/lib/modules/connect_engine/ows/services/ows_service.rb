class OwsService
  OWS_SUCCESS = 'SUCCESS'

  # Setup the SOAP client using the hotel's wsdl url and ENDPOINT defined.
  def initialize(hotel_id, endpoint_name, wsdl_url, options = {})
    @hotel_id = hotel_id
    @wsdl_url = wsdl_url

    @request_namespace = options[:request_namespace] || wsdl_url
    @hotel_attrs = hotel_attrs(options[:connection_params] || {})
    @use_kiosk = options[:use_kiosk] || false
    @client = soap_client(get_endpoint(endpoint_name), options[:override_client_namespace])

    # Disable HTTPI logging to console
    HTTPI.log = false
  end

  # Iterate through the soap operations list and dynamically create methods for them
  def self.soap_operation(operation, options = {})
    define_method(operation) do |message, response_element, process_closure = ->(operational_response) {}|
      soap_operation = operation.to_s.camelize
      soap_action = (options[:soap_action] || operation).to_s.camelize

      soap_request(message, soap_action, soap_operation, response_element, process_closure)
    end
  end

  # Place soap request using the message, action, and namespace. Return the results.
  def soap_request(message, action, operation, response_element, process_closure)
    result = nil

    operation += 'Request'
    soap_action = @wsdl_url + '#' + action

    start_time = Time.now

    begin
      response = @client.call(operation, soap_action: soap_action, attributes: message.action_attributes, message: message.value)

      # Remove the namespaces from the response to simplify parsing
      response.doc.remove_namespaces!

      result = handle_response(response.xpath(response_element), process_closure)
    rescue => ex
      logger.error "OWS SOAP Action #{action} - Exception: " + ex.message
      result = { status: false, message: ex.message }
      raise PmsException::ExternalPmsError
    end

    duration = Time.now - start_time
    logger.info "OWS SOAP Action #{action} - Duration: #{duration}"

    result
  end

  private

  # Handle there response from the OWS operation, passing a closure of how to setup the result object
  def handle_response(operation_response, process_closure)
    response_result = operation_response.xpath('Result')
    response_status = response_result.xpath('@resultStatusFlag').text

    status = response_status == OWS_SUCCESS

    result = { status: status }

    # If successful, call the closure. If failure, add the error message to the result and log
    if status
      external_id = response_result.xpath('IDs/IDPair[1]/@operaId').text
      result[:external_id] = external_id if external_id.present?
      result[:data] = process_closure.call(operation_response)
    else
      message = response_result.xpath('GDSError').text
      message = response_result.xpath('Text/TextElement').text unless message.present?
      message = response_result.xpath('OperaErrorCode').text unless message.present?

      result[:message] = message

      logger.warn "Received OWS response status '#{response_status}' with message '#{message}'"
    end

    result
  end

  # Get the OWS hotel attributes from the product config
  def hotel_attrs(connection_params)
    hotel = Hotel.find(@hotel_id)

    {
      access_url: connection_params[:pms_access_url] || hotel.settings.pms_access_url,
      username: connection_params[:pms_user_name] || hotel.settings.pms_user_name,
      password: connection_params[:pms_user_pwd] || hotel.hotel_chain.decrypt_pswd(hotel.settings.pms_user_pwd),
      channel_code: connection_params[:pms_channel_code] || hotel.settings.pms_channel_code,
      domain: connection_params[:pms_hotel_code] || hotel.settings.pms_hotel_code,
      pms_timeout: connection_params[:pms_timeout] || hotel.settings.pms_timeout || Setting.defaults[:default_pms_timeout]
    }
  end

  # Gets the hotel's wsdl url from the product config
  def get_endpoint(endpoint_name)
    access_url = @hotel_attrs[:access_url]

    fail "OWS Access URL not configured for hotel_id: #{@hotel_id}" unless access_url

    "#{access_url}/#{endpoint_name}"
  end

  # Gets the SOAP client using the hotel's wsdl url and the child class's wsdl name
  def soap_client(endpoint, override_client_namespace)
    namespace = override_client_namespace ? @request_namespace : @wsdl_url

    Savon.client(endpoint: endpoint, read_timeout: @hotel_attrs[:pms_timeout].to_i,  namespace: namespace, soap_header: soap_header,
                 logger: Rails.logger, ssl_verify_mode: :none, filters: [:cardNumber, :Track2], namespaces: {
                   'xmlns' => @request_namespace,
                   'xmlns:c' => 'http://webservices.micros.com/og/4.3/Common/',
                   'xmlns:hc' => 'http://webservices.micros.com/og/4.3/HotelCommon/',
                   'xmlns:r' => 'http://webservices.micros.com/og/4.3/Reservation/', # Reservation with identifier r
                   'xmlns:a' => 'http://webservices.micros.com/og/4.3/Availability/', # Availability with identifier a
                   'xmlns:ra' => 'http://webservices.micros.com/og/4.3/ResvAdvanced/', # Reservation Advanced with identifier ra
                   'xmlns:n' => 'http://webservices.micros.com/og/4.3/Name/' # Name with identifier n
                 }
    )
  end

  # Define the SOAP header to use
  def soap_header
    username = @hotel_attrs[:username]
    password = @hotel_attrs[:password]
    domain = @hotel_attrs[:domain]
    channel_code = @hotel_attrs[:channel_code]

    entity_id = @use_kiosk ? 'KIOSK' : channel_code
    system_type = @use_kiosk ? 'KIOSK' : 'WEB'

    now = Time.now.utc

    if !username || !password || !channel_code
      fail "OWS username, password, and channel code must be configured for hotel_id: #{@hotel_id}"
    end

    {
      'OGHeader' => {
        'Origin' => '',
        'Destination' => '',
        'Authentication' => {
          'UserCredentials' => {
            'UserName' => username,
            'UserPassword' => password,
            'Domain' => domain
          }
        },
        :attributes! => {
          'Origin' => { entityID: entity_id, systemType: system_type },
          'Destination' => { entityID: entity_id, systemType: system_type }
        }
      },
      :attributes! => {
        'OGHeader' => {
          xmlns: 'http://webservices.micros.com/og/4.3/Core/',
          transactionID: SecureRandom.uuid,
          timeStamp: now.iso8601
        }
      }
    }
  end
end
