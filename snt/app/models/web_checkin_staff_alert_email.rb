class WebCheckinStaffAlertEmail < ActiveRecord::Base
  attr_accessible :email, :hotel_id
  belongs_to :hotel
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})\Z/ }
end
