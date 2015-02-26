class ViewMappings::RoomKeyDeliverySettingsMapping
  def self.map_room_key_delivery_settings(hotel)
    {
      key_systems: Ref::KeySystem.all.map { |key_system| { value: key_system.id, name: key_system.value } },
      room_key_delivery_for_guestzest_check_in: hotel.settings.room_key_delivery_for_guestzest_check_in,
      room_key_delivery_for_rover_check_in: hotel.settings.room_key_delivery_for_rover_check_in,
      selected_key_system: hotel.key_system_id,
      key_encoder_enabled: hotel.key_system.andand.encoder_enabled || false,
      key_access_url: hotel.settings.key_access_url,
      key_access_port: hotel.settings.key_access_port,
      key_username: hotel.settings.key_username,
      key_password: hotel.settings.key_password,
      key_delivery_message: hotel.settings.key_delivery_message
    }
  end
end
