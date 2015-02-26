class InactiveRoom < ActiveRecord::Base

  attr_accessible :id, :room_id, :ref_service_status_id, :maintenance_reason_id, :date, :comments

  belongs_to :room
  belongs_to :ref_service_status
  belongs_to :maintenance_reason
  
  has_enumerated :ref_service_status, class_name: 'Ref::ServiceStatus'

  validates :room_id, :ref_service_status_id, :date, presence: true

end