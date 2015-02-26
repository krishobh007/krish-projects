class ReservationsAddon < ActiveRecord::Base
  attr_accessible :reservation_id, :addon_id , :price, :is_inclusive_in_rate, :quantity
  belongs_to :reservation
  belongs_to :addon

  validates :reservation_id, uniqueness: { scope: :addon_id }
  validates :reservation_id, :addon_id, :quantity, presence: true
  validates :quantity, numericality: { only_integer: true }
end
