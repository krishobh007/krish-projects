json.array! @users do |user|
  json.id user.id
  full_name = user.id ? user.full_name : "EOD"
  json.full_name full_name 
  json.email user.email
  json.department_id user.department_id
end
