class Neighbourhood < ActiveRecord::Base
  
  attr_accessible :beacon_id, :neighbour_id
  
  belongs_to :beacon
  belongs_to :neighbour, :class_name => "Beacon"
  
end