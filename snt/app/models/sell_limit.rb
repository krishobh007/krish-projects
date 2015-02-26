class SellLimit < ActiveRecord::Base
  attr_accessible :hotel_id, :rate_id, :room_type_id, :from_date, :to_date, :to_sell

  belongs_to :hotel
  belongs_to :rate
  belongs_to :room_type

  validates :hotel, :from_date, :to_date, :to_sell, presence: true
  validates :to_sell, numericality: { only_integer: true }
  validate :from_less_than_to
  validate :no_overlaps

  def no_overlaps
    overlapping_ranges = hotel.sell_limits.where(rate_id: rate_id, room_type_id: room_type_id).overlapping(from_date, to_date)
    overlapping_ranges = overlapping_ranges.where('id != ?', id) if persisted?

    errors.add(:base, :date_range_overlap) if overlapping_ranges.exists?
  end

  # Validates that the from date is less than the to date
  def from_less_than_to
    errors.add(:from_date, :less_than_to) if from_date > to_date
  end

  scope :between_dates, ->(begin_date, end_date) { where('from_date <= ? and ? <= to_date', begin_date, end_date) }

  scope :overlapping, lambda { |from_date, to_date|
    where('(from_date <= :from_date and to_date >= :from_date) or
           (from_date <= :to_date and to_date >= :to_date) or
           (from_date >= :from_date and to_date <= :to_date)', from_date: from_date, to_date: to_date)
  }

  scope :house, -> { where('rate_id is null and room_type_id is null') }
  scope :rate, ->(rate_id) { where(rate_id: rate_id, room_type_id: nil) }
  scope :room_type, ->(room_type_id) { where(rate_id: nil, room_type_id: room_type_id) }
  scope :rate_room_type, ->(rate_id, room_type_id) { where(rate_id: rate_id, room_type_id: room_type_id) }
end
