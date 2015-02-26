class UsersNotificationDetail < ActiveRecord::Base
  attr_accessible :user_id, :notification_detail_id, :is_read, :is_pushed, :should_notify, :alert_time, :notification_channel
  belongs_to :user
  belongs_to :notification_detail

  validates :user_id, :notification_detail_id, presence: true,  if: :push_notification?
  validates_uniqueness_of :user_id , :scope => [:notification_detail_id, :is_pushed]

  scope :messages, -> { joins(:notification_detail).where("notification_details.notification_section = ?", :MESSAGE)}
 
  private
  def push_notification?
    ( notification_channel != Setting.notification_channel[:email])
  end
end
