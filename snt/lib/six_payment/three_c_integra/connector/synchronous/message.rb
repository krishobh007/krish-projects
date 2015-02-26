module SixPayment
  module ThreeCIntegra
    module Connector
      module Synchronous
        class Message
          def initialize(request, hotel)
            six_logger.info "Requesting with XML -> #{Time.now}"
            six_logger.info request
            
            # Validates the XML formating
            Nokogiri::XML(request) { |config| config.options = Nokogiri::XML::ParseOptions::STRICT }
            
            @ip_address = hotel.settings.six_server_ipaddress #'217.37.134.112'
            @port       = hotel.settings.six_server_port #10083
            @response   = ""
            
            raise ThreeCIntegraConfigurationError, "The ip address and port should be set inorder to connect" if @ip_address.blank? || @port.blank?
            
            EventMachine.run {
              @connection = EventMachine::connect @ip_address, @port, Handler, request
            }
            @response = @connection.response
          end
          
          def response
            if @response.is_a?(SixPayment::ThreeCIntegra::Response::Error) || @response.is_a?(NilClass)
              raise SixPayment::ThreeCIntegra::ThreeCIntegraConfigurationError, @response.nil? ? I18n.t('processor_response_not_valid') : @response.message
            end
            @response
          end
        end
        
        class Handler < EventMachine::Connection
        
          def initialize(request)
            super
            # Sets inactivity timeout to 60 seconds
            set_comm_inactivity_timeout 60
            
            six_logger.info "Connection is established #{Time.now}"
            
            @received_data = ''
            send_data request
          end
          
          def receive_data(data)
            six_logger.info "Received response -> #{Time.now}"
            six_logger.info data
            
            @received_data = @received_data + data
            if @received_data.include? '</Response>'
              @doc = Nokogiri::XML(@received_data)
              if @doc.errors.empty?
                response_class = ("SixPayment::ThreeCIntegra::Response::"+@doc.root.attributes["Type"].value).constantize
                begin
                  @response = response_class.new(@received_data)
                rescue NoMethodError => ex
                  six_logger.error ex
                end
              else
                six_logger.error @doc.errors
              end
              EventMachine.stop
            end
          end
          
          def unbind
            six_logger.info "Connection is closing #{Time.now}"
            EventMachine.stop
          end
          
          def response
            @response
          end
        end
      end
    end
  end
end