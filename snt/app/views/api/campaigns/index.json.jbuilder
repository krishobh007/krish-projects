json.results @campaigns do |campaign|
  json.id campaign.id
  json.name campaign.name
  json.audience_type campaign.audience_type.andand.name.titlecase
  json.delivery campaign.is_recurring ? 'Recurring' : 'One Time'
  json.status campaign.status
  json.updated_at campaign.updated_at.in_time_zone(current_hotel.tz_info)
  json.last_updated_date campaign.updated_at.strftime("%Y-%m-%d")
  json.last_updated_time campaign.updated_at.strftime("%H:%M")
end
json.total_count @campaigns.total_count
