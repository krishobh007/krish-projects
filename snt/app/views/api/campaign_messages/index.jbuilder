json.data @users_notification_details do |user_notification|
  json.message_id user_notification.id.to_s
  json.image_thumbnail user_notification.notification_detail.notification.andand.header_image.present? ? user_notification.notification_detail.notification.header_image.image.url(:thumb) : ''
  json.message_title user_notification.notification_detail.notification.subject.to_s
  json.message_body user_notification.notification_detail.notification.body.to_s
  json.created_at map_created_at_time(user_notification.created_at).to_s
  json.call_to_action_label user_notification.notification_detail.notification.call_to_action_label.to_s
  json.call_to_action_url user_notification.notification_detail.notification.call_to_action_target.to_s
end
json.status "success"
json.errors []