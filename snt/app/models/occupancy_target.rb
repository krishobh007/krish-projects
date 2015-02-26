class OccupancyTarget < ActiveRecord::Base
  attr_accessible :hotel_id, :date, :target

  belongs_to :hotel

  validates :hotel, :date, :target, presence: true
  validates :target, numericality: { only_integer: true }
  validates :hotel_id, uniqueness: { scope: :date }
end
