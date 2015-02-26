class HotelMessage < ActiveRecord::Base
  attr_accessible :hotel_id, :module, :message, :hotel_message_key_id
  belongs_to :hotel
  translates :message
  has_enumerated :hotel_message_key, class_name: 'Ref::HotelMessageKey'
  validates :hotel_message_key_id, :module, :hotel_id, :message, presence: true
end
