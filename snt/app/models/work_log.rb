class WorkLog < ActiveRecord::Base
  attr_accessible :room_id, :begin_time, :end_time
end
