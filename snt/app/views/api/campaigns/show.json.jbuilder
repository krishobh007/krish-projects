  json.id @campaign.id
  json.name @campaign.name
  json.audience_type @campaign.audience_type.name
  json.subject @campaign.subject
  json.body @campaign.body
  json.specific_users @campaign.guest_details.andand.first.andand.email.to_s
  json.call_to_action_label @campaign.call_to_action_label
  json.call_to_action_target @campaign.call_to_action_target
  json.alert_ios7 @campaign.alert_ios7
  json.alert_ios8 @campaign.alert_ios8
  json.is_recurring @campaign.is_recurring
  json.recurrence_end_date @campaign.recurrence_end_date
  json.header_image @campaign.header_image.andand.image.andand.url(:thumb)
  json.day_of_week @campaign.day_of_week if @campaign.is_recurring
  json.date_to_send @campaign.date_to_send if @campaign.is_recurring
  json.time_to_send @campaign.time_to_send if @campaign.is_recurring
  json.status @campaign.status
  json.updated_at @campaign.updated_at.in_time_zone(current_hotel.tz_info)
  json.completed_date @campaign.is_recurring ? @campaign.recurrence_end_date.andand.strftime("%Y-%m-%d") : 
    @campaign.date_to_send.strftime("%Y-%m-%d")
  json.completed_time @campaign.is_recurring ? @campaign.recurrence_end_date.andand.strftime("%H:%M") : 
    @campaign.time_to_send
