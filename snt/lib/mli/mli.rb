class Mli
  include HTTParty
  format :xml
  base_uri Setting.mli_access_url
  SUCCESS_STATUSES = %w(OK Approval Accepted)
  DEFAULT_MANUFACTURE_CODE = '01'
  INFINEA_MANUFACTURE_CODE = '54'

  def initialize(object, hotel_chain = nil)
    @hotel = nil
    
    if object.is_a?(Hotel)
      @hotel    = object
      settings  = object.settings
      hotel_chain = object.hotel_chain
      @chain_code = hotel_chain.code
      @hotel_code = object.code
    else
      settings = object
    end

    if settings
      self.class.ssl_ca_file "#{Rails.root}/certs/mli/ca-cert-#{hotel_chain.andand.id}.crt"
      self.class.pem(settings[:mli_pem_certificate], 'stayntouch')
      @company_code = settings[:mli_chain_code]
      @site_code = settings[:mli_hotel_code]
    end

  end

  # Test the connection to MLI. Returns success or failure.
  def test_connection
    now = Time.now.utc
    company_code = @company_code
    site_code = @site_code

    builder = Nokogiri::XML::Builder.new do
      LTV(VID: 200) do
        CC company_code
        SC site_code
        X do
          PS now.to_i
          PT now.iso8601
          CT ''
        end
      end
    end

    submit_request '/LTV/ADMINTRANS', builder
  end

  def test_mli_payment_gate_way_connection
    result = HTTParty.get(Setting.mli_payment_gateway_url + Setting.mli_api_version + Setting.mli_connection_test_path)
    result.parsed_response
  end

  # Get the token from MLI.
  # - If not encrypted, pass :card_number and :is_encrypted attributes
  # - If encrypted, pass :et2 or :etb and :ksn attributes
  def get_token(attributes)
    is_encrypted = !(attributes[:is_encrypted] == false)
    is_manual = attributes.key?(:is_manual) ? attributes[:is_manual] : false
    manufacture_code = attributes[:etb].present? ? INFINEA_MANUFACTURE_CODE : DEFAULT_MANUFACTURE_CODE

    now = Time.now.utc
    company_code = @company_code
    site_code = @site_code

    if attributes.key?(:session_id)
      submit_session_request(attributes)
    else
      builder = Nokogiri::XML::Builder.new do
        LTV(VID: 104) do
          CC company_code
          SC site_code
          X do
            PS now.to_i
            PT now.iso8601
            EM is_manual ? 'M' : '2'  # Track Number or Manual
            CD is_encrypted ? '' : attributes[:card_number]
          end

          if is_encrypted
            ENCD do
              ENTI '2'  # Track Number
              ENF manufacture_code # 2 character manufacture code
              ENKSN attributes[:ksn] # KSN
              ET1 attributes[:et1] # Encrypted Track 1 Card Number
              ET2 attributes[:et2] # Encrypted Track 2 Card Number
              ETB attributes[:etb] # Encrypted Both Tracks Card Number
            end
          end
        end
      end

      submit_request '/LTV/ADMINTRANS', builder, lambda { |response|
        # Return the token
        response.xpath('//CK').text
      }
    end
  end

  # Sends a token to MLI and gets the credit card number back
  def get_credit_card_number(mli_token)
    now = Time.now.utc
    company_code = @company_code
    site_code = @site_code

    builder = Nokogiri::XML::Builder.new do
      LTV(VID: 104) do
        CC company_code
        SC site_code
        X do
          PS now.to_i
          PT now.iso8601
          EM 'K'
          CD mli_token
        end
      end
    end

    submit_request '/LTV/ADMINTRANS', builder, lambda { |response|
      # Return the credit card number
      response.xpath('//CD').text
    }
  end

  # Send the original authorization request to MLI for $1.
  def original_authorization(reservation, mli_token, expiry_date)
    now = Time.now.utc
    company_code = @company_code
    site_code = @site_code

    builder = Nokogiri::XML::Builder.new do
      LTV(VID: 200) do
        CC company_code
        SC site_code
        LN  1234
        T do
          V 'StayNTouch 0.1'
          PS now.to_i
          PT now.iso8601
          A do
            FN 1
            EM 'K'
            CD mli_token
            E expiry_date
            AA 1.00
            CI reservation.arrival_date.strftime('%Y%m%d')
            CO reservation.dep_date.strftime('%Y%m%d')
          end
        end
      end
    end

    submit_request '/LTV/CREDITAUTH', builder, lambda { |response|
      # Return the transaction code
      response.xpath('/LTV//AR/MLT').text
    }
  end

  private

  def submit_request(action, builder, process_closure = ->(response) {})
    xml = builder.to_xml

    logger.debug 'MLI Request: ' + xml.gsub("\n", '').to_s unless Rails.env.production?

    begin
      response = self.class.post(action, body: xml)

      logger.debug "MLI Response: #{response.body}" unless Rails.env.production?

      get_result(Nokogiri::XML(response.body), process_closure)
    rescue => ex
      logger.error 'MLI Connection Failed: ' + ex.message
      { status: false, data: nil, errors: ['MLI Connection Failed'] }
    end
  end

  def get_result(doc, process_closure)
    status = true
    data = nil
    errors = []

    response_code = doc.xpath('/LTV//RC').text

    if SUCCESS_STATUSES.include?(response_code)
      data = process_closure.call(doc)

    else
      response_text = doc.xpath('/LTV//RT').text

      if response_code.present?
        message = "MLI Response #{response_code}: #{response_text}"
      else
        message = 'MLI Response Failed'
      end

      status = false
      logger.warn message
      errors << message
    end

    { status: status, data: data, errors: errors }
  end

  def submit_session_request(attributes)
    hotel = Hotel.find_by_code(@hotel_code)
    token_url = Setting.mli_payment_gateway_url + Setting.mli_api_version + Setting.mli_get_token_path.gsub('{merchant_id}',
                                                                                                            hotel.settings.mli_merchant_id)

    request_params = {
      body: {
        session: { id: attributes[:session_id] },
        sourceOfFunds: { type: 'CARD' },
        externalTokenProvider: { customData: "{\"siteCode\":\"#{hotel.settings.mli_site_code}\"}" }
      }.to_json,
      basic_auth: {
        username: 'merchant.' + hotel.settings.mli_merchant_id,
        password: hotel.hotel_chain.decrypt_pswd(hotel.settings.mli_api_key)
      },
      headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    }

    logger.debug 'MLI Request: ' + request_params.to_s unless Rails.env.production?

    response = HTTParty.post(token_url, request_params).parsed_response

    logger.debug 'MLI Response: ' + response.to_s unless Rails.env.production?

    response
  end
end
