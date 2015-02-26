class BookingOrigin < ActiveRecord::Base
  attr_accessible :code, :description, :hotel_id, :is_active
  belongs_to :hotel
  
  validates_presence_of :code, :hotel_id
  validates_uniqueness_of :code, scope: [:hotel_id]
end
