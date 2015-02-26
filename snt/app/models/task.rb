class Task < ActiveRecord::Base
  before_destroy :is_system_defined?, :has_future_work_assignments?
  
  attr_accessible :id, :name, :work_type_id, :ref_housekeeping_status_id, :is_occupied,
                  :is_vacant, :room_type_id, :completion_time, :room_type_ids, :front_office_status_ids,
                  :ref_reservation_hk_status_ids, :hk_status

  belongs_to :work_type
  belongs_to :ref_housekeeping_status
  has_many :room_type_tasks
  has_many :task_reservation_statuses
  has_many :ref_reservation_hk_statuses,
           through: :task_reservation_statuses,
           class_name: "Ref::ReservationHkStatus"
           
  has_enumerated :ref_housekeeping_status, class_name: 'Ref::HousekeepingStatus'

  has_many :room_types, through: :room_type_tasks
  has_many :work_assignments

  has_and_belongs_to_many :front_office_statuses, class_name: "Ref::FrontOfficeStatus"

  validates :name, :work_type_id, presence: true
  
  def is_system_defined?
    errors.add(:is_system, "defined") if is_system
    errors.blank?
  end
  
  def has_future_work_assignments?
    errors.add(:work_type, "has future work sheets") if (work_type) && work_type.work_sheets.where('date >= date(?)', Time.now).count > 0
    errors.blank?
  end
end