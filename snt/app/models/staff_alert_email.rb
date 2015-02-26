class StaffAlertEmail < ActiveRecord::Base
  attr_accessible  :email, :hotel_id, :email_type
  belongs_to :hotel
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})\Z/}, allow_nil: true

  scope :queue_reservation_alerts, -> { where(email_type: Setting.staff_alert_types[:queue_reservation]) }


end
