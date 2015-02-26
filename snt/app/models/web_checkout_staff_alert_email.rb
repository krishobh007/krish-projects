class WebCheckoutStaffAlertEmail < ActiveRecord::Base
  attr_accessible :email, :hotel_id, :email_type
  belongs_to :hotel

  scope :checkout_alerts, -> { where(email_type: Setting.staff_alert_types[:checkout]) }
  scope :late_checkout_alerts, -> { where(email_type: Setting.staff_alert_types[:late_checkout]) }
end
