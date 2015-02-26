class Wakeup < ActiveRecord::Base
  attr_accessible :id, :reservation_id, :hotel_id, :room_no, :start_date, :end_date, :status_id, :status, :time

  belongs_to :reservation
  belongs_to :hotel

  has_enumerated :status, class_name: 'Ref::WakeupStatus'

  validates :reservation_id, :hotel_id, :start_date, :end_date, :time, :status_id,
            presence: true

  validates :time,
            uniqueness: { scope: [:reservation_id, :start_date, :end_date] }
end
