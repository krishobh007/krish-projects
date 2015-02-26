class MarketSegment < ActiveRecord::Base
  attr_accessible :hotel_id, :name, :is_active

  belongs_to :hotel
  validates :name,presence: true
  validates_uniqueness_of :name,scope: [:hotel_id]
  
  scope :active, -> { where('is_active = true') }
end