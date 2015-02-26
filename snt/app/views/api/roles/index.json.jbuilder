json.user_roles @roles do |role|
  json.value role.id
  json.name role.name.titleize
  if role.hotels_roles
    roles = role.hotels_roles.where(hotel_id: current_hotel.id)
    default_dashboard = roles.any? ? roles.first.default_dashboard : nil
    dashboard_name = default_dashboard ? default_dashboard.description : nil
    dashboard_id = default_dashboard ? default_dashboard.id : nil
  end
  json.dashboard_id dashboard_id
  json.dashboard_name dashboard_name
end