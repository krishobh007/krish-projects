class RoomTypeTask < ActiveRecord::Base
  attr_accessible :id, :task_id, :room_type_id, :completion_time

  belongs_to :task
  belongs_to :room_type

  validates :task_id, :room_type_id, presence: true

          
end