# Admin Reviews Setup
Setting.defaults[:is_guest_reviews_on] = false
Setting.defaults[:reviews_per_page] = 50
Setting.defaults[:rating_for_auto_publish] = 0

# Admin Checkin Setup
Setting.defaults[:checkin_alert_is_on] = false
Setting.defaults[:checkin_alert_message] = 'Welcome @TITLE. @FIRSTNAME @LASTNAME, your room is now ready for Check In, you can Check In now using your phone.'
Setting.defaults[:checkin_alert_on_room_ready] = false
Setting.defaults[:checkin_require_cc_for_email] = false

# Admin Late Checkout Setup
Setting.defaults[:late_checkout_is_on] = false
Setting.defaults[:late_checkout_is_pre_assigned_rooms_excluded] = false

# Admin Upsell Setup
Setting.defaults[:upsell_is_on] = false
Setting.defaults[:upsell_is_one_night_only] = false
Setting.defaults[:upsell_is_force] = false

# Admin Checkout Setup
Setting.defaults[:checkout_require_cc_for_email] = false

# Hotel:: is_inspected_only, use_pickup, use_inspected default value
Setting.defaults[:checkin_inspected_only] = false
Setting.defaults[:use_pickup] = false
Setting.defaults[:use_inspected] = false

Setting.defaults[:include_cash_reservations] = false
# Addons
Setting.defaults[:addon_is_bestseller] = false

Setting.defaults[:use_kiosk_entity_id] = false

Setting.defaults[:icare_enabled] = false

Setting.defaults[:pre_checkin_enabled] = false

# Hotel have default Queue Rooms Disabled
Setting.defaults[:is_queue_rooms_on] = false

Setting.defaults[:alert_notification_display_limit] ||= 20

Setting.defaults[:default_pms_timeout] ||= 10

Setting.defaults[:default_auto_logout_delay] ||= 5 # in minutes

Setting.defaults[:default_checkout_email_alert_time] ||= '08:00:00'

Setting.defaults[:use_kiosk_entity_id_for_fetch_booking] = false
Setting.defaults[:use_snt_entity_id_for_checkin_checkout] = false

Setting.defaults[:sftp_timeout] = 30 # seconds
Setting.defaults[:smartband_import_time] ||= '07:00'

Setting.defaults[:room_key_delivery_for_rover_check_in] ||= 'qr_code_tablet'
Setting.defaults[:room_key_delivery_for_guestzest_check_in] ||= 'smartphone'
Setting.defaults[:night_import_freq] = 5
Setting.defaults[:day_import_freq] = 5
Setting.defaults[:external_references_import_freq] = 60

Setting.defaults[:icare_save_customer_info] ||= false
Setting.defaults[:is_auto_change_bussiness_date] ||= false
Setting.defaults[:enable_room_status_at_checkout] ||= false

# Default settings for AR-NUMBER Details settings

Setting.defaults[:is_auto_assign_ar_numbers] = false

Setting.defaults[:icare_combined_key_room_charge_create] ||= false
Setting.defaults[:enable_room_status_at_checkout] ||= false

Setting.defaults[:is_allow_manual_cc] = false
# Hourly Rate - Default Off
Setting.defaults[:is_hourly_rate_on] = false

# Addon - Default On
Setting.defaults[:is_addon_on] = true

# To save Checkin offsets - Default 30min
# As per story - CICO-11237
Setting.defaults[:hourly_checkin_offset] = 30
Setting.defaults[:is_allow_early_checkin] = false
Setting.defaults[:max_number_of_early_checkins_per_day] = 0

#Based on story CICO-12191
# Early departure penalty - Off by default
Setting.defaults[:disable_early_departure_penalty] = false
# Reservation posting control: Off by default
Setting.defaults[:disable_reservation_posting_control] = false
Setting.defaults[:max_password_expiry] = 90

Setting.defaults[:email_confirmation_types] = {
  :confirmation => 'confirmation',
  :cancellation => 'cancellation'
}

Setting.defaults[:consecutive_failed_logins_limit] = 3
# Campaigns :  length of ios7 and ios8_alert field
Setting.defaults[:ios7_alert_length] = 120
Setting.defaults[:ios8_alert_length] = 120
