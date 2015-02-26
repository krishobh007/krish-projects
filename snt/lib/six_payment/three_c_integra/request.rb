module SixPayment
  module ThreeCIntegra
    module Request
      
      class BaseRequest
        
        attr_accessor :type, :sequence_number, :requester_location_id, :requester_trans_ref_num, :requester_station_id
        attr_accessor :children
        
        def initialize(attributes)
          child_class = (self.class.name.to_s + "::Child").constantize
          @children = child_class.new(attributes)
          @type = attributes[:request_type] || self.class.name.demodulize
          @sequence_number = attributes[:sequence_number] || ""
          @requester_location_id = attributes[:requester_location_id] || "000170"
          @requester_trans_ref_num = attributes[:requester_trans_ref_num] || ""
          @requester_station_id =  attributes[:requester_station_id] if attributes[:requester_station_id]
        end
        
        
        def to_xml
          xml_attributes = {}
          child_nodes = {}
          self.instance_variables.each do |attr|
            if attr == :@children
              self.children.instance_variables.each do |c_attr|
                child_nodes[c_attr.to_s.gsub("@", "").to_sym] = self.children.instance_variable_get(c_attr)
              end
              next
            end
            xml_attributes[attr.to_s.gsub("@", "").camelize] = instance_variable_get attr
          end
          
          Gyoku.xml({ :request => child_nodes, :attributes! => { :request => xml_attributes} }, { :key_converter => :camelcase })
        end
      end
    end
  end
end