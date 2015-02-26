module SixPayment
  module Web2Pay
    class BaseResponse
      def initialize(response_body)
        begin
          six_logger.info response_body # Log the response

          request_name = "#{self.class}".demodulize.underscore
          response_result = response_body["#{request_name}_response".to_sym]
          result_data = response_result["#{request_name}_result".to_sym]
          result_data.each_pair do |name, value|
            if value.is_a?(Nori::StringWithAttributes)
              instance_variable_set("@#{name}", value.to_s)
            elsif value.is_a?(Hash)
              instance_variable_set("@#{name}", "")
            end
          end
        rescue TypeError => ex
          six_logger.error "#{ex.message} #13"
        end
      end
    end
  end
end