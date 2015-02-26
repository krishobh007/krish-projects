class MaintenanceReason < ActiveRecord::Base
  attr_accessible :hotel_id, :maintenance_reason
  validates_uniqueness_of :maintenance_reason, scope: [:hotel_id]
  validates :maintenance_reason,presence: true
  belongs_to :hotel
  has_many :inactive_rooms
end
