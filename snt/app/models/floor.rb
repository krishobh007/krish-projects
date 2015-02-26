class Floor < ActiveRecord::Base
   attr_accessible :floor_number, :description, :hotel_id
   belongs_to :hotel
   has_many :rooms
   validates_uniqueness_of :floor_number, scope: [:hotel_id]
   validates :floor_number, presence: true
end
