module SeedProductConfig
  def create_product_config
    # PAGE COUNTS
    Setting.feature_page_count ||= 10
    Setting.posts_page_count ||= 10
    Setting.events_page_count ||= 10
    Setting.comments_page_count ||= 5
    Setting.reviews_page_count ||= 50
    Setting.messages_page_count ||= 10

    # MLI Settings
    Setting.mli_access_url ||= 'https://tv1var.merchantlink.com:8184'
    Setting.mli_payment_gateway_url ||= 'https://cnp.merchantlink.com/api/rest/version/'
    Setting.mli_api_version ||= '20'
    Setting.mli_connection_test_path ||= '/information'
    Setting.mli_get_token_path ||= '/merchant/{merchant_id}/token'

    # Default early/late change stay day limits
    Setting.stay_date_lower_limit ||= 1
    Setting.stay_date_upper_limit ||= 7

    Setting.community_name ||= 'StayNTouch PMS'
    Setting.app_host ||= 'localhost:3000'
    Setting.host_name ||= 'http://localhost:3000'

    Setting.default_admin_password ||= 'R}v5 x{6FG'

    # Database Reservation Statuses
    Setting.reservation_view_status = {
      checking_in: 'CHECKING_IN',
      checking_out: 'CHECKING_OUT',
      noshow_current: 'NOSHOW_CURRENT'
    }

    # Constants for identifying hotel logo and template logo
    Setting.hotel_logo_types = {
      rover: 'ROVER',
      template: 'TEMPLATE',
      no_logo: 'NO_LOGO'
    }

    # Input Reservation Statuses
    Setting.reservation_input_status = {
      in_house: 'INHOUSE',
      due_in: 'DUEIN',
      due_out: 'DUEOUT',
      reserved: 'RESERVED',
      checked_in: 'CHECKEDIN',
      checked_out: 'CHECKEDOUT',
      no_show: 'NOSHOW',
      canceled: 'CANCELED',
      pre_checkin: 'PRE_CHECKIN'
    }

    Setting.guest_web_email_types = {
      checkin: 'CHECKIN',
      checkout: 'CHECKOUT',
      late_checkout: 'LATE_CHECKOUT',
      pre_checkin: 'PRE_CHECKIN'
    }

    Setting.room_fo_status = {
      dueout: 'DUEOUT'
    }

   Setting.charge_type = {
      base_rate: 'BASE RATE'
    }

    Setting.addon_type = {
      rate: 'RATE',
      reservation: 'RESERVATION'
    }
    Setting.account_types = {
      travel_agent: 'TRAVEL_AGENT',
      company: 'COMPANY'
    }

    # Wakeup Days
    Setting.wakeup_day = {
      today: 'TODAY',
      tomorrow: 'TOMORROW'
    }

    # Staff Email Alert Types
    Setting.staff_alert_types = {
      checkin: 'CHECKIN',
      checkout: 'CHECKOUT',
      late_checkout: 'LATE_CHECKOUT',
      queue_reservation: 'QUEUE_RESERVATION'
    }

    # Mapping Types
    Setting.mapping_types = {
      rate_code: 'RATE_CODE',
      room_type: 'ROOM_TYPE',
      group_code: 'GROUP_CODE',
      credit_card_type: 'CC_TYPE',
      membership_type: 'MEMBER_TYPE',
      membership_class: 'MEMBER_CLASS',
      address_type: 'ADDRESS_TYPE',
      email_type: 'EMAIL_TYPE',
      phone_type: 'PHONE_TYPE',
      preference_type: 'PREFERENCE_TYPE',
      preference_value: 'PREFERENCE_VALUE',
      reservation_status: 'RESERVATION_STATUS',
      currency_code: 'CURRENCY_CODE',
      fo_status: 'FO_STATUS',
      hk_status: 'HK_STATUS',
      nationality: 'NATIONALITY',
      vip_exclusion: 'VIP_EXCLUSION'
    }

    Setting.exclude_vip_value ||= 'EXCLUDE'

    # SUPPRESSED RATE SETTING
    Setting.suppressed_rate ||= 'SR'

    # Reservation Import Config
    Setting.res_import_remote_guest_filename ||= 'stayntouchres*.txt'
    Setting.daily_filename_pattern ||= /stayntouchresguest/
    Setting.smart_bands_import_filename ||= 'stayntouchsmartbands*.txt'
    Setting.external_references_import_remote_filename ||= 'stayntouchextref*.txt'
    Setting.res_import_local_guest_filename ||= 'guests.txt'
    Setting.smart_bands_import_local_filename ||= 'smartbands.txt'
    Setting.external_references_import_local_filename ||= 'external_references.txt'
    Setting.res_import_remote_files_to_keep ||= 10
    Setting.smartbands_import_remote_files_to_keep ||= 10
    Setting.external_references_import_remote_files_to_keep ||= 10
    Setting.res_import_local_dir ||= '/tmp/reservations'
    Setting.smartbands_local_dir ||= '/tmp/smartbands'
    Setting.external_references_import_local_dir ||= '/tmp/external_references'

    # Admin menu available for roles
    Setting.admin_menu_available_for = {
      snt_admin: 'ADMIN',
      hotel_admin: 'HOTELADMIN'
    }

    # Set the width and height for the signature image canvas.
    # See app/models/reservation.rb line no :368
    Setting.signature_canvas_width ||= 2000

    Setting.signature_canvas_height ||= 400

    # Default frequencies for the scheduled resque jobs
    Setting.resque_freq_default ||= {
      res_import: 60,
      room_status_import: 5
    }

    Setting.notification_section = {
      1 => 'CHECK IN',
      2 => 'CHECK OUT',
      3 => 'THE SOCIAL LOBBY',
      4 => 'MY GROUP',
      5 => 'HOTEL REVIEWS',
      6 => 'TEXT_TO_STAFF'
    }

    Setting.notification_section_id = {
      'CHECK IN' => 1,
      'CHECK OUT' => 2,
      'THE SOCIAL LOBBY' => 3,
      'MY GROUP' => 4,
      'HOTEL REVIEWS' => 5,
      'TEXT TO STAFF' => 6,
      'BEACON_CHECKIN' => 7,
      'BEACON_CHECKOUT' => 8
    }

    Setting.notification_section_text = {
      check_in: 'CHECK IN',
      check_out: 'CHECK OUT',
      beacon_checkout: 'BEACON_CHECKOUT',
      beacon_checkin: 'BEACON_CHECKIN',
      social_lobby: 'THE SOCIAL LOBBY',
      my_group: 'MY GROUP',
      review: 'HOTEL REVIEWS',
      checkout_email: 'CHECKOUT_EMAIL',
      checkin_email: 'CHECKIN_EMAIL',
      text_to_staff: 'TEXT TO STAFF'
    }
    Setting.notification_channel = {
      email: 'EMAIL_NOTIFICATION',
      push_notification: ' PUSH_NOTIFICATION'
    }

    Setting.notification_type = {
      post: 'SbPost',
      comment: 'Comment',
      review: 'Review',
      reservation: 'Reservation',
      message: 'Message',
      campaign: 'Campaign'
    }

    Setting.contract_rate_types = {
      corporate_rates: 'Corporate Rates',
      government_rates: 'Government Rates',
      consortia_rates: 'Consortia Rates'
    }

    Setting.payment_associated = {
      guest_detail: 'GuestDetail',
      reservation: 'Reservation'
    }

    # Default stay day(upper and lower limit) to show calendar page(in days)
    Setting.stay_date_lower_limit ||= 1
    Setting.stay_date_upper_limit ||= 7

    Setting.signature_display = {
      checkin: 'CHECKIN',
      checkout: 'CHECKOUT',
      no_signature: 'NO_SIGNATURE'
    }

    Setting.message_section = {
      sl_posts: 'SL_POSTS',
      reviews: 'REVIEWS',
      my_group: 'MY_GROUP',
      text_to_staff: 'TEXT_TO_STAFF'
    }

    Setting.beacon_types = {
      checkin: 'CHECKIN',
      checkout: 'CHECKOUT',
      promotion: 'PROMOTION'
    }
     Setting.routing_entity_types = {
      reservation: 'RESERVATION',
      company_card:  'COMPANY_CARD',
      travel_agent:  'TRAVEL_AGENT'
    }

     Setting.zest_key_delivery_options = {
      email: 'email',
      front_desk: 'front_desk'

    }

    Setting.alert_staff_options = {
      ALL: 'all',
      NOT_SUCCESS: 'not_success'
    }

    Setting.mli_card_types = {
      AMEX: 'AX',
      DINERS_CLUB: 'DC',
      DISCOVER: 'DS',
      JCB: 'JCB',
      MASTERCARD: 'MC',
      VISA: 'VA'
    }

    # Six payment card map
    Setting.six_payment_card_types = {
      AX: 'AX',
      DC: 'DC',
      DI: 'DS',
      JCB: 'JCB',
      MC: 'MC',
      VS: 'VA',
      UM: 'UM',
      MX: 'DS',
      VX: 'VA',
      MV: 'MC'
    }
    
    if Rails.env.production?
      # Six Payment ipage Url
      Setting.six_ipage_url = "https://web2pay.3cint.com/iPage/Service/_2006_05_v1_0_1/service.aspx"
      # SIXPayments token service WSDL
      Setting.six_token_service_wsdl = "https://web2pay.3cint.com/mxg/service/_2011_02_v5_1_0/Token.asmx?WSDL"
      Setting.yotel_hotel_chain_code = "YOT"
    else
      # Six Payment ipage Url
      Setting.six_ipage_url = "https://web2payuat.3cint.com/iPage/Service/_2006_05_v1_0_1/service.aspx"
      # SIXPayments token service WSDL
      Setting.six_token_service_wsdl = "https://web2payuat.3cint.com/mxg/service/_2011_02_v5_1_0/Token.asmx?WSDL"
      Setting.yotel_hotel_chain_code = "YTL"
    end
    

    # Define the start and end of the day for the import process frequencies
    Setting.import_day_start = '06:00'
    Setting.import_day_end = '23:00'

    Setting.date_formats = {
      "DD-MM-YYYY" => "%d-%m-%Y",
      "DD/MM/YYYY"=> "%d/%m/%Y",
      "MM-DD-YYYY"=> "%m-%d-%Y",
      "MM/DD/YYYY"=> "%m/%d/%Y"
    }

    # Cms Component Types
    Setting.component_types = {
      section: 'SECTION',
      category: 'CATEGORY',
      page: 'PAGE'
    }

    # Cms Component Status
    Setting.component_status = {
      available: 'AVAILABLE',
      draft: 'DRAFT'
    }

    # Cms Component Page Templates
    Setting.page_template = {
      poi: 'POI',
      general: 'GENERAL',
      link: 'LINK'
    }
    Setting.room_availablity = {
      web_booking: 'WEBBOOKING',
      available: 'AVAILABLE'
    }
    Setting.external_references_associated_types = {
      reservation: 'Reservation'
    }

    Setting.checkin_actions = {
      auto_checkin: 'auto_checkin',
      sent_to_queue: 'sent_to_queue'
    }
    
    Setting.user_activity = {
      success: 'SUCCESS',
      failure: 'FAILURE',
      login: 'LOGIN',
      logout: 'LOGOUT',
      invalid_login: 'INVALID_LOGIN'
    }

    Setting.printer_template_types = {
      checkin: 'CHECKIN',
      checkout: 'CHECKOUT'
    }

    Setting.anaytics_types = {
      product_cross_customer: 'PRODUCT_CROSS_CUSTOMER',
      product_customer: 'PRODUCT_CUSTOMER',
      product_customer_proprietary: "PRODUCT_CUSTOMER_PROPRIETARY"
    }

    Setting.anaytics_product_types = {
      zest_web: "ZEST_WEB",
      zest_app_ios: 'ZEST_APP_IOS',
      zest_app_android: 'ZEST_APP_ANDROID'
    }

    # Campaigns : length of ios7 and ios8_alert field
    Setting.ios7_alert_length ||= 120
    Setting.ios8_alert_length ||= 120

  end
end
