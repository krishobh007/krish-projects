class HourlyRoomRate < ActiveRecord::Base
  attr_accessible :id, :hour, :amount, :room_rate_id
  belongs_to :room_rates
end
