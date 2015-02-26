class WorkAssignment < ActiveRecord::Base
  attr_accessible :id, :work_sheet_id, :task_id, :room_id, :work_status_id, :order, :work_status, :task

  belongs_to :work_sheet
  belongs_to :task
  belongs_to :room
  belongs_to :work_status
  
  has_enumerated :work_status, class_name: 'Ref::WorkStatus'

  validates :room_id, :work_status_id, presence: true
  
  validate :is_room_type_applicable_for_work_sheet
 
  def is_room_type_applicable_for_work_sheet
    if not work_sheet.work_type.tasks.joins(:room_types).exists?('room_types.id' => room.room_type.id)
      errors.add(:room, "is not applicable for the work type")
    end
  end
  
end