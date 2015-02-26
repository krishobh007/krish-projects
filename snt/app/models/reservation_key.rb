class ReservationKey < ActiveRecord::Base
  attr_accessible :number_of_keys, :qr_data, :room_number, :reservation_id, :is_inactive, :uid
  belongs_to :reservation

  validates :number_of_keys, :reservation_id, presence: true
  

  # Using this method to get all active record as JSON String format.
  def as_json(opts = {})
    json = super(opts)
    Hash[*json.map { |k, v| [k, v.to_s || ''] }.flatten]
  end
end
