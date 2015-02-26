json.data do
  json.message_id @message_id.to_s
  json.image_original @campaign.header_image.present? ? @campaign.header_image.andand.image.andand.url(:medium) : ''
  json.message_title @campaign.subject.to_s
  json.message_body @campaign.body.to_s
  json.created_at map_created_at_time(@users_notification.created_at).to_s
  json.call_to_action_label @campaign.call_to_action_label.to_s
  json.call_to_action_url @campaign.call_to_action_target.to_s
end
json.status "success"
json.errors []