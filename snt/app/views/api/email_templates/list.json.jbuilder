json.hotel_name @hotel.name

json.themes @email_template_themes do |email_template_theme|
  json.id email_template_theme.id
  json.name email_template_theme.name.humanize
end

json.email_templates @email_templates do | email_template |
  json.id email_template.id
  json.title email_template.title.humanize
  json.email_template_theme_id email_template.email_template_theme_id
end

json.existing_email_templates @existing_email_templates do | existing_email_template |
  json.array! existing_email_template.id
end

json.existing_email_template_theme @existing_email_template_theme.andand.id
