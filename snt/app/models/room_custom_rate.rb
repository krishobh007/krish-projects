class RoomCustomRate < ActiveRecord::Base
  attr_accessible :room_rate_id, :room_rate, :date, :single_amount, :double_amount, :extra_adult_amount, :child_amount

  belongs_to :room_rate

  validates :room_rate, :date, presence: true
  validates :single_amount, :double_amount, :extra_adult_amount, :child_amount,  numericality: true, allow_nil: true
  validates :room_rate_id, uniqueness: { scope: [:date] }

  scope :between_dates, ->(begin_date, end_date) { where('? <= date and date <= ?', begin_date, end_date) }
end
