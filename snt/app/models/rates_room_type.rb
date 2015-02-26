class RatesRoomType < ActiveRecord::Base
  attr_accessible :rate_id, :room_type_id

  belongs_to :rate
  belongs_to :room_type

  validates :rate_id, :room_type_id,
            presence: true

  validates :rate_id,
            uniqueness: { scope: :room_type_id }
end
