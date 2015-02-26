class Restriction < ActiveRecord::Base
  self.abstract_class = true

  attr_accessible :hotel_id, :type, :type_id, :rate_id, :days

  belongs_to :hotel
  belongs_to :rate

  validates :hotel, :type, :rate, presence: true
  validates :days, numericality: { only_integer: true }, allow_nil: true

  def restricted?(day_index, stay_length, advanced_booking)
    closed? ||
    closed_arrival?(day_index) ||
    closed_departure?(day_index, stay_length) ||
    min_stay_through?(day_index, stay_length) ||
    min_stay_length?(day_index, stay_length) ||
    max_stay_length?(day_index, stay_length) ||
    min_advanced_booking?(day_index, advanced_booking) ||
    max_advanced_booking?(day_index, advanced_booking)
  end

  def closed?
    type === :CLOSED
  end

  def closed_arrival?(day_index)
    type === :CLOSED_ARRIVAL && day_index == 0
  end

  def closed_departure?(day_index, stay_length)
    type === :CLOSED_DEPARTURE && day_index == stay_length - 1
  end

  # Min Stay Through means that the stay must be X days long starting on the day of the restriction
  def min_stay_through?(day_index, stay_length)
    type === :MIN_STAY_THROUGH && days >= stay_length - day_index
  end

  # Min Stay Length means that the whole stay must be X days long
  def min_stay_length?(day_index, stay_length)
    type === :MIN_STAY_LENGTH && days > stay_length && day_index == 0
  end

  def max_stay_length?(day_index, stay_length)
    type === :MAX_STAY_LENGTH && days < stay_length && day_index == 0
  end

  def min_advanced_booking?(day_index, advanced_booking)
    type === :MIN_ADV_BOOKING && days >= advanced_booking && day_index == 0
  end

  def max_advanced_booking?(day_index, advanced_booking)
    type === :MAX_ADV_BOOKING && days <= advanced_booking && day_index == 0
  end
end
