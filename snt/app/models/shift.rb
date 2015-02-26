class Shift < ActiveRecord::Base
  attr_accessible :id, :name, :time, :hotel_id, :is_system

  belongs_to :hotel

  validates :name, presence: true         
end