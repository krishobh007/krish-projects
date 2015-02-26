class Source < ActiveRecord::Base
  attr_accessible :code, :description, :hotel_id, :is_active
  belongs_to :hotel
  validates_presence_of :code
  validates_uniqueness_of :code, scope: [:hotel_id]
  
  scope :active, -> { where(is_active: true) }
end
