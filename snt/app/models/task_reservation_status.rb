class TaskReservationStatus < ActiveRecord::Base
  attr_accessible :task_id, :ref_reservation_hk_status_id, :ref_reservation_hk_status

  belongs_to :task
  belongs_to :ref_reservation_hk_status, class_name: 'Ref::ReservationHkStatus'

  validates :task_id, :ref_reservation_hk_status_id, presence: true
  validates :task_id, uniqueness: { scope: :ref_reservation_hk_status_id }

  has_enumerated :reservation_hk_status, class_name: 'Ref::ReservationHkStatus'
end
