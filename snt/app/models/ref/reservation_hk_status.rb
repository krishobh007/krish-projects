class Ref::ReservationHkStatus < Ref::ReferenceValue
  
  has_many :task_reservation_statuses, foreign_key: :ref_reservation_hk_status_id
  has_many :tasks, through: :task_reservation_statuses
end