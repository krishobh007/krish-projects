module SeedAdminMenusAndOptions
  def create_admin_menus_and_options
    # HOTEL ADMIN MENU
    # Hotel & Staff Menu and Options
    hotel_staff_menu = AdminMenu.find_by_name_and_available_for('Hotel & Staff', Setting.admin_menu_available_for[:hotel_admin])
    hotel_staff_menu = AdminMenu.create(name: 'Hotel & Staff', description: 'Hotel & Staff setup',
                                        display_order: 1, available_for: Setting.admin_menu_available_for[:hotel_admin]) unless hotel_staff_menu

    AdminMenuOption.create(name: 'Hotel Details', action_path: '/admin/hotels/:id/edit',
                           admin_menu_id: hotel_staff_menu.id, icon_class: 'icon-hotel', action_state: 'admin.hoteldetails')
    AdminMenuOption.create(name: 'User Setup', action_path: '/admin/users',
                           admin_menu_id: hotel_staff_menu.id, icon_class: 'icon-user', action_state: 'admin.users')
    AdminMenuOption.create(name: 'Departments', action_path: '/admin/departments',
                           admin_menu_id: hotel_staff_menu.id, icon_class: 'icon-admin-menu icon-departments', action_state: 'admin.departments')
    AdminMenuOption.create(name: 'User Roles', action_path: '/admin/roles',
                            admin_menu_id: hotel_staff_menu.id, icon_class: 'icon-admin-menu icon-roles',
                            action_state: 'admin.userRoles')
    AdminMenuOption.create(name: 'Settings & Parameters', action_path: '#',
                           admin_menu_id: hotel_staff_menu.id, icon_class: 'icon-admin-menu icon-profile', action_state: 'admin.settingsAndParams', require_standalone_pms: true)
    AdminMenuOption.create(name: 'Stationary', action_path: '#',
                           admin_menu_id: hotel_staff_menu.id, icon_class: 'icon-admin-menu icon-stationary', action_state: 'admin.stationary')

    # Guest Menu and Options
    guestzest_menu = AdminMenu.find_by_name_and_available_for('Zest', Setting.admin_menu_available_for[:hotel_admin])
    guestzest_menu = AdminMenu.create(name: 'Zest', description: 'Zest setup',
                                      display_order: 2, available_for: Setting.admin_menu_available_for[:hotel_admin]) unless guestzest_menu

    AdminMenuOption.create(name: 'Hotel Announcements', action_path: '/admin/hotel/get_announcements_settings', admin_menu_id: guestzest_menu.id,
                           icon_class: 'icon-admin-menu icon-announcement', action_state: 'admin.hotelannouncementsettings')
    AdminMenuOption.create(name: 'Social Lobby', action_path: '/admin/hotel/get_social_lobby_settings',
                           admin_menu_id: guestzest_menu.id, icon_class: 'icon-admin-menu icon-lobby', action_state: 'admin.sociallobbysettings')
    AdminMenuOption.create(name: 'Guest Reviews', action_path: '/admin/get_review_settings',
                           admin_menu_id: guestzest_menu.id, icon_class: 'icon-admin-menu icon-reviews', action_state: 'admin.guestreviewsetup')
    AdminMenuOption.create(name: 'Messages', action_path: '#',
                           admin_menu_id: guestzest_menu.id, icon_class: 'icon-admin-menu icon-messages', action_state: 'admin.dashboard({"menu":8})')
    AdminMenuOption.create(name: 'Check In', action_path: '/admin/checkin_setups/list_setup',
                           admin_menu_id: guestzest_menu.id, icon_class: 'icon-admin-menu icon-check-in', action_state: 'admin.checkin')
    AdminMenuOption.create(name: 'Check Out', action_path: '/admin/get_checkout_settings',
                           admin_menu_id: guestzest_menu.id, icon_class: 'icon-admin-menu icon-check-out', action_state: 'admin.checkout')
    AdminMenuOption.create(name: 'My Account', action_path: '#', admin_menu_id: guestzest_menu.id,
                           icon_class: 'icon-admin-menu icon-profile', action_state: 'admin.dashboard({"menu":8})')
    AdminMenuOption.create(name: 'iBeacon Setup', action_path: '#', admin_menu_id: guestzest_menu.id,
                           icon_class: 'icon-admin-menu icon-ibeacon', action_state: 'admin.ibeaconSettings')
    AdminMenuOption.create(name: 'Content Management', action_path: '/api/cms_components/index', admin_menu_id: guestzest_menu.id,
                           icon_class: 'icon-admin-menu icon-cmscomponents', action_state: 'admin.cmscomponentSettings')
    AdminMenuOption.create(name: 'Upsell Early Checkin', action_path: '#', admin_menu_id: guestzest_menu.id,
                           icon_class: 'icon-admin-menu icon-cmscomponents', action_state: 'admin.earlyCheckin')
    AdminMenuOption.create(name: 'Analytics Setup', action_path: '#', admin_menu_id: guestzest_menu.id,
                           icon_class: 'icon-admin-menu icon-key-encoders', action_state: 'admin.analyticsSetup')
    AdminMenuOption.create(name: 'Campaigns', action_path: '#', admin_menu_id: guestzest_menu.id,
                           icon_class: 'icon-admin-menu icon-campaigns', action_state: 'admin.campaigns')
    AdminMenuOption.create(name: 'Email Blacklist', action_path: '#', admin_menu_id: guestzest_menu.id,
                           icon_class: 'icon-admin-menu icon-campaigns', action_state: 'admin.emailBlacklist')
    # Promotions & Upsell Menu and Options
    promotion_upsell_menu = AdminMenu.find_by_name_and_available_for('Promos & Upsell', Setting.admin_menu_available_for[:hotel_admin])
    promotion_upsell_menu = AdminMenu.create(name: 'Promos & Upsell', description: 'Promos & Upsell setup',
                                             display_order: 3, available_for: Setting.admin_menu_available_for[:hotel_admin]) unless promotion_upsell_menu
    AdminMenuOption.create(name: 'Upsell Rooms', action_path: '/admin/room_upsells/room_upsell_options',
                           admin_menu_id: promotion_upsell_menu.id, icon_class: 'icon-admin-menu icon-upsell-rooms', action_state: 'admin.roomupsell')
    AdminMenuOption.create(name: 'Upsell Late Checkout', action_path: '/admin/hotel/get_late_checkout_setup', admin_menu_id: promotion_upsell_menu.id,
                           icon_class: 'icon-admin-menu icon-upsell-checkout', action_state: 'admin.upselllatecheckout')

    # Guest Card Menu and Options
    guest_card_menu = AdminMenu.find_by_name_and_available_for('Guest Cards', Setting.admin_menu_available_for[:hotel_admin])
    guest_card_menu = AdminMenu.create(name: 'Guest Cards', description: 'Guest Cards setup',
                                       display_order: 4, available_for: Setting.admin_menu_available_for[:hotel_admin]) unless guest_card_menu
    AdminMenuOption.create(name: 'Likes', action_path: '/admin/hotel_likes/get_hotel_likes',
                           admin_menu_id: guest_card_menu.id, icon_class: 'icon-admin-menu icon-likes', action_state: 'admin.hotellikes')
    AdminMenuOption.create(name: 'Frequent Flyer Program', action_path: '/admin/hotel/list_ffps',
                           admin_menu_id: guest_card_menu.id, icon_class: 'icon-admin-menu icon-ffp', action_state: 'admin.ffp')
    AdminMenuOption.create(name: 'Hotel Loyalty Program', action_path: '/admin/hotel/list_hlps',
                           admin_menu_id: guest_card_menu.id, icon_class: 'icon-admin-menu icon-loyalty', action_state: 'admin.hotelLoyaltyProgram')

    # Rooms Menu and Options
    rooms_menu = AdminMenu.find_by_name_and_available_for('Rooms', Setting.admin_menu_available_for[:hotel_admin])
    rooms_menu = AdminMenu.create(name: 'Rooms', description: 'Rooms setup',
                                  display_order: 5, available_for: Setting.admin_menu_available_for[:hotel_admin]) unless rooms_menu

    AdminMenuOption.create(name: 'Room types', action_path: '/admin/room_types',
                           admin_menu_id: rooms_menu.id, icon_class: 'icon-admin-menu icon-room-types', action_state: 'admin.roomtypes')
    AdminMenuOption.create(name: 'Rooms', action_path: '/admin/hotel_rooms',
                           admin_menu_id: rooms_menu.id, icon_class: 'icon-room', action_state: 'admin.rooms')
    AdminMenuOption.create(name: 'Room Key Delivery', action_path: '/admin/get_room_key_delivery_settings',
                           admin_menu_id: rooms_menu.id, icon_class: ' icon-admin-menu icon-key', action_state: 'admin.roomKeyDelivery')
    AdminMenuOption.create(name: 'Housekeeping', action_path: '#',
                           admin_menu_id: rooms_menu.id, icon_class: 'icon-admin-menu icon-housekeeping', action_state: 'admin.housekeeping')
    AdminMenuOption.create(name: 'Maintenance Reasons', action_path: '/admin/maintenance_reasons',
                           admin_menu_id: rooms_menu.id, icon_class: 'icon-admin-menu icon-maintenance',
                           action_state: 'admin.maintenanceReasons', require_standalone_pms: true)
    AdminMenuOption.create(name: 'Floor Setup', action_path: '/admin/floors',
                           admin_menu_id: rooms_menu.id, icon_class: 'icon-admin-menu icon-floor',
                           action_state: 'admin.floorsetups')
    AdminMenuOption.create(name: 'Daily Work Assignment', action_path: '/daily_work_assignment',
                           admin_menu_id: rooms_menu.id, icon_class: 'icon-admin-menu icon-dailyworkassignment',
                           action_state: 'admin.dailyWorkAssignment', require_standalone_pms: true)

    # Financials Menu and Options
    financials_menu = AdminMenu.find_by_name_and_available_for('Financials', Setting.admin_menu_available_for[:hotel_admin])
    financials_menu = AdminMenu.create(name: 'Financials', description: 'Financials setup',
                                       display_order: 6, available_for: Setting.admin_menu_available_for[:hotel_admin]) unless financials_menu

    AdminMenuOption.create(name: 'Charge Groups', action_path: '/admin/charge_groups',
                           admin_menu_id: financials_menu.id, icon_class: 'icon-charge-group', action_state: 'admin.chargeGroups')
    AdminMenuOption.create(name: 'Payment methods', action_path: '/admin/hotel_payment_types',
                           admin_menu_id: financials_menu.id, icon_class: 'icon-admin-menu icon-payment', action_state: 'admin.paymentMethods')
    AdminMenuOption.create(name: 'Charge Codes', action_path: '/admin/charge_codes/list',
                           admin_menu_id: financials_menu.id, icon_class: 'icon-charge-code', action_state: 'admin.chargeCodes')
    AdminMenuOption.create(name: 'Items', action_path: '/admin/items/get_items',
                           admin_menu_id: financials_menu.id, icon_class: 'icon-admin-menu icon-billing', action_state: 'admin.items')
    AdminMenuOption.create(name: 'Billing Groups', action_path: '#',
                           admin_menu_id: financials_menu.id, icon_class: 'icon-charge', action_state: 'admin.billingGroups', require_standalone_pms: true)
    AdminMenuOption.create(name: 'Accounts Receivables', action_path: '#',
                           admin_menu_id: financials_menu.id, icon_class: 'icon-admin-menu icon-account-receivable', action_state: 'admin.accountsReceivables', require_standalone_pms: true)

    # Rates Menu and Options
    rates_menu = AdminMenu.find_by_name_and_available_for('Rates', Setting.admin_menu_available_for[:hotel_admin])
    rates_menu = AdminMenu.create(name: 'Rates', description: 'Rates setup',
                                  display_order: 7, available_for: Setting.admin_menu_available_for[:hotel_admin]) unless rates_menu

    AdminMenuOption.create(name: 'Rates', action_path: '/admin/rates',
                           admin_menu_id: rates_menu.id, icon_class: 'icon-admin-menu icon-rate', action_state: 'admin.rates')
    AdminMenuOption.create(name: 'Rate Types', action_path: '/admin/hotel_rate_types',
                           admin_menu_id: rates_menu.id, icon_class: 'icon-admin-menu icon-rate-types', action_state: 'admin.ratetypes')
    AdminMenuOption.create(name: 'Rules & Restrictions', action_path: '/api/admin/restriction_types',
                           admin_menu_id: rates_menu.id,
                           icon_class: 'icon-admin-menu icon-restrictions', action_state: 'admin.rulesRestrictions', require_standalone_pms: true)
    AdminMenuOption.create(name: 'Add-Ons', action_path: '/api/admin/addons',
                           admin_menu_id: rates_menu.id,
                           icon_class: 'icon-admin-menu icon-addon', action_state: 'admin.ratesAddons', require_standalone_pms: true)

    # Reservations Menu and Options
    reservations_menu = AdminMenu.find_by_name_and_available_for('Reservations', Setting.admin_menu_available_for[:hotel_admin])
    reservations_menu = AdminMenu.create(name: 'Reservations', description: 'Reservations setup',
                                         display_order: 8, available_for: Setting.admin_menu_available_for[:hotel_admin]) unless reservations_menu
    AdminMenuOption.create(name: 'Markets', action_path: '#',
                           admin_menu_id: reservations_menu.id, icon_class: 'icon-admin-menu icon-markets',
                           action_state: 'admin.markets', require_standalone_pms: true)
    AdminMenuOption.create(name: 'Sources', action_path: '/admin/source', admin_menu_id: reservations_menu.id,
                           icon_class: 'icon-admin-menu icon-sources',
                           action_state: 'admin.sources', require_standalone_pms: true)
    AdminMenuOption.create(name: 'Origin Of Booking', action_path: '#', admin_menu_id: reservations_menu.id,
                           icon_class: 'icon-admin-menu icon-booking-origin',
                           action_state: 'admin.bookingOrigins', require_standalone_pms: true)
    AdminMenuOption.create(name: 'Reservation Types', action_path: '#', admin_menu_id: reservations_menu.id,
                           icon_class: 'icon-admin-menu icon-reservation-types',
                           action_state: 'admin.reservationTypes', require_standalone_pms: true)
    AdminMenuOption.create(name: 'Reservation Settings', action_path: '#', admin_menu_id: reservations_menu.id,
                           icon_class: 'icon-admin-menu icon-reservation-settings',
                           action_state: 'admin.reservationSettings', require_standalone_pms: true)

    # Interface Menu and Options
    interfaces_menu = AdminMenu.find_by_name_and_available_for('Interfaces', Setting.admin_menu_available_for[:hotel_admin])
    interfaces_menu = AdminMenu.create(name: 'Interfaces', description: 'Interfaces setup',
                                       display_order: 9, available_for: Setting.admin_menu_available_for[:hotel_admin]) unless interfaces_menu
    AdminMenuOption.create(name: 'External Mappings', action_path: '#',
                           admin_menu_id: interfaces_menu.id,
                           icon_class: 'icon-admin-menu icon-external', action_state: 'admin.dashboard({"menu":8})')
    AdminMenuOption.create(name: 'External PMS Web Services', action_path: '/admin/get_pms_connection_config',
                           admin_menu_id: interfaces_menu.id, icon_class: 'icon-admin-menu icon-pms', action_state: 'admin.externalPmsConnectivity')
    AdminMenuOption.create(name: 'iCare Services', action_path: '#',
                           admin_menu_id: interfaces_menu.id, icon_class: 'icon-admin-menu icon-icare', action_state: 'admin.icare')
    AdminMenuOption.create(name: 'Workstations', action_path: '#',
                           admin_menu_id: interfaces_menu.id, icon_class: 'icon-admin-menu icon-device-mapping', action_state: 'admin.deviceMapping')
    AdminMenuOption.create(name: 'Key Encoders', action_path: '#',
                           admin_menu_id: interfaces_menu.id, icon_class: 'icon-admin-menu icon-key-encoders', action_state: 'admin.keyEncoders')

      # Reports Menu
    reports_menu = AdminMenu.find_by_name_and_available_for('Stats & Reports', Setting.admin_menu_available_for[:hotel_admin])
    reports_menu = AdminMenu.create(name: 'Stats & Reports', description: 'Status and Reports setup',
                                    display_order: 10, available_for: Setting.admin_menu_available_for[:hotel_admin])
    AdminMenuOption.create(name: 'General', action_path: '#',
                           admin_menu_id: reports_menu.id, icon_class: 'icon-admin-menu icon-external')
    # SNT ADMIN MENU
    # Hotels menu
    hotels_menu = AdminMenu.find_by_name_and_available_for('Hotels', Setting.admin_menu_available_for[:snt_admin])
    hotels_menu = AdminMenu.create(name: 'Hotels', description: 'Hotels setup',
                                   display_order: 1, available_for: Setting.admin_menu_available_for[:snt_admin]) unless hotels_menu
    AdminMenuOption.create(name: 'Hotels', action_path: '/admin/hotels',
                           admin_menu_id: hotels_menu.id, icon_class: 'icon-hotel', action_state: 'admin.hotels')
    AdminMenuOption.create(name: 'Chains', action_path: '/admin/hotel_chains',
                           admin_menu_id: hotels_menu.id, icon_class: 'icon-chain', action_state: 'admin.chains')
    AdminMenuOption.create(name: 'Brands', action_path: '/admin/hotel_brands/',
                           admin_menu_id: hotels_menu.id, icon_class: 'icon-brand', action_state: 'admin.brands')

    # Dashboard menu
    dashboard_menu = AdminMenu.find_by_name_and_available_for('Dashboard', Setting.admin_menu_available_for[:snt_admin])
    AdminMenu.create(name: 'Dashboard', description: 'Dashboard setup',
                     display_order: 2, available_for: Setting.admin_menu_available_for[:snt_admin])

    # Configuration menu
    configuration_menu = AdminMenu.find_by_name_and_available_for('Configuration', Setting.admin_menu_available_for[:snt_admin])
    AdminMenu.create(name: 'Configuration', description: 'Configuration setup',
                     display_order: 3, available_for: Setting.admin_menu_available_for[:snt_admin])
    AdminMenuOption.create(name: 'Template Configuration', action_path: '/admin/hotel_brands/',
                           admin_menu_id: configuration_menu.id, icon_class: 'icon-brand', action_state: 'admin.templateconfiguration')
    AdminMenuOption.create(name: 'Analytics Setup', action_path: '#',
                           admin_menu_id: configuration_menu.id, icon_class: 'icon-admin-menu icon-key-encoders', action_state: 'admin.analyticsSetup')

    I18n.locale = :de
    AdminMenuOption.find_by_name('Hotel Details').update_attribute(:name, 'Hotel Details')
    AdminMenuOption.find_by_name('User Setup').update_attribute(:name, 'Benutzer-Setup')
    AdminMenuOption.find_by_name('Departments').update_attribute(:name, 'Abteilungen')

  end
end
