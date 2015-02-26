class ViewMappings::HotelAnnouncementsSettingsMapping
  def self.hotel_announcement_settings(settings)
    {
      guest_zest_welcome_message: settings.guest_zest_welcome_message,
      guest_zest_checkout_complete_message: settings.guest_zest_checkout_complete_message,
      key_delivery_email_message: settings.key_delivery_email_message
    }
  end
end
