module SixPayment
  module ThreeCIntegra
    module Response
      
      class BaseResponse
        attr_accessor :doc, :result, :result_reason, :message, :print_data1, :sequence_number, :type, 
                      :requester_trans_ref_num, :print_data2
        
        def initialize(xml_string)
          @doc = Nokogiri::XML(xml_string)
          @doc.root.attributes.each do |k, v|
            instance_variable_set("@#{k.underscore}", "#{v}")
          end
          @doc.root.children.each do |child|
            var_name = child.node_name.underscore
            var_value = child.content.strip
            instance_variable_set("@#{var_name}", var_value)
          end
        end
      end
    end
  end
end