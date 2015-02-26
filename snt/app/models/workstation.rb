class Workstation < ActiveRecord::Base
  belongs_to :hotel
  attr_accessible :name, :station_identifier, :hotel
  
  validates_uniqueness_of :name, scope: [:hotel_id]
end
