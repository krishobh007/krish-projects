class EarlyCheckinSetup < ActiveRecord::Base
  attr_accessible :charge, :start_time, :hotel_id, :addon_id

  validates :start_time, uniqueness: { scope: [:hotel_id] }
  validates :start_time, :charge, presence: true
  validates :charge, numericality: true

  belongs_to :hotel
  belongs_to :addons
  
end
