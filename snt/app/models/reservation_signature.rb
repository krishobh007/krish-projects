class ReservationSignature < ActiveRecord::Base
  attr_accessible :base64_data, :reservation_id, :data

  belongs_to :reservation

  validates :data, :reservation_id, presence: true
  validates :reservation_id, uniqueness: true

  # Converts a base64 encoded string into binary data for the signature image
  def base64_data=(input_data)
    self.data = input_data
  end
end
