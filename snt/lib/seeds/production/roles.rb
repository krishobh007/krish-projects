module SeedRoles
  def create_roles
    # Create new roles over and above admin, member, moderator

    Role.create(name: 'admin')
    Role.create(name: 'hotel_admin')
    Role.create(name: 'guest')
    Role.create(name: 'api_user')
  end
end
