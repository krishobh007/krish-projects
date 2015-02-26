class LateCheckoutCharge < ActiveRecord::Base
  attr_accessible :extended_checkout_charge, :extended_checkout_time, :hotel_id

  validates :extended_checkout_time, uniqueness: { scope: [:hotel_id] }
  validates :extended_checkout_time, :extended_checkout_charge, presence: true
  validates :extended_checkout_charge, numericality: true

  belongs_to :hotel
end
