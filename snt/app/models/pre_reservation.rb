class PreReservation < ActiveRecord::Base
  attr_accessible :room, :user, :from_time, :to_time, :confirm_no, :rate

  validates :room, :user, :from_time, :to_time, presence: true
  belongs_to :room
  belongs_to :user
  belongs_to :rate
end