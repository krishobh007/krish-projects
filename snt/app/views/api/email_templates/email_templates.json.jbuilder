json.email_templates @email_templates do | email_template |
  json.id email_template.id
  json.title email_template.title.humanize
end