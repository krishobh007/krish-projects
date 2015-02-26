class UpsellRoomLevel < ActiveRecord::Base
  attr_accessible :level, :room_type_id

  belongs_to :room_type

  validates :level, :room_type_id, presence: true
end
