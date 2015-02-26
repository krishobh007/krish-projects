json.ar_notes @ar_notes do |note|
  json.id note.id
  json.note note.description
  json.created_at formatted_date(note.created_at)
  json.created_time note.created_at.strftime('%I:%M %p')
  json.avatar note.andand.creator.andand.detail.andand.avatar
  json.user_name note.andand.creator.andand.detail.andand.full_name
end