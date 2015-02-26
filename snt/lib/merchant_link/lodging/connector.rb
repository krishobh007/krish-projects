module MerchantLink
  module Lodging
    module Connector
      
      SUCCESS_STATUSES = %w(OK Approval Accepted)
      DECLINE_CODE     = 'Decline'
      
      def make_request(base_url, message_body)
        mli_logger.info("Requesting #{base_url} with \n #{message_body} \n at #{Time.now}")
        
        begin
          response = self.class.post(base_url, body: message_body)
        rescue OpenSSL::SSL::SSLError
          raise PaymentGateWayError, "SSL Error: Please check the certificates"
        end
        
        mli_logger.info("Got Response \n #{response.body} \n with status code #{response.code} \n at #{Time.now}")
        
        raise PaymentGateWayError, "Payment Gateway: Error reading from remote server" if response.code == 502
        xml_doc = nil
        if response.code == 200
          begin
            xml_doc = Nokogiri::XML(response.body){ |config| config.strict }
            response_code = xml_doc.xpath('/LTV//RC').text
            unless SUCCESS_STATUSES.include?(response_code)
              response_text = xml_doc.xpath('/LTV//RT').text
              if response_code == DECLINE_CODE
                raise PaymentGateWayError, "Payment Gateway: The transaction has declined"
              end
              raise PaymentGateWayError, "Payment Gateway: Error with MLI. #{response_code}:#{response_text}"
            end
          rescue Nokogiri::XML::SyntaxError => ex
            raise "Got Unexpected Response From Payment Processor"
          end            
        end
        
        xml_doc
      end
    end
  end
end