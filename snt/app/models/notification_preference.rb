class NotificationPreference < ActiveRecord::Base
  self.table_name = 'user_notification_preferences'
  attr_accessible :user_id, :new_post, :response_to_post, :response_to_review, :alert_text_to_staff, :is_alert_promotions

  belongs_to :user, class_name: 'User', foreign_key: 'user_id'

  def as_json(opts = {})
    json = super(opts)
    Hash[*json.map { |k, v| [k, v.to_s || ''] }.flatten]
  end
end
