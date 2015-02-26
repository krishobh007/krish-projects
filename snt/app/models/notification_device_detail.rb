class NotificationDeviceDetail < ActiveRecord::Base
  attr_accessible :user_id, :unique_id, :registration_id, :device_type

  belongs_to :user, class_name: 'User', foreign_key: 'user_id'

  validates :unique_id, uniqueness: true
  validates :user_id, :unique_id, :device_type, presence: true
end
