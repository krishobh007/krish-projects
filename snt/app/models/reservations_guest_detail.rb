class ReservationsGuestDetail < ActiveRecord::Base
  attr_accessible :guest_detail_id, :is_primary, :reservation_id, :is_accompanying_guest, :is_added_from_kiosk
  belongs_to :guest_detail
  belongs_to :reservation

  validates :guest_detail_id, :reservation_id, presence: true
  validates :guest_detail_id, uniqueness: { scope: :reservation_id }
end
