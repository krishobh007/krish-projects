  json.id @note.id
  json.note @note.description
  json.created_at formatted_date(@note.created_at) if @note.created_at
  json.avatar @note.andand.creator.andand.detail.andand.avatar
  json.created_time @note.andand.created_at.andand.strftime('%I:%M %p')
  json.user_name @note.andand.creator.andand.detail.andand.full_name