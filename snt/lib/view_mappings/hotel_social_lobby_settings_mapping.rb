class ViewMappings::HotelSocialLobbySettingsMapping
  def self.hotel_social_lobby_settings(settings)
    {
      is_social_lobby_on: settings.is_social_lobby_on,
      is_my_group_on: settings.is_my_group_on,
      arrival_grace_days: settings.arrival_grace_days,
      departure_grace_days: settings.departure_grace_days,
    }
  end
end
