Pms::Application.routes.draw do

  namespace :admin do
    root to: "settings#settings"
    match 'login', to: 'sessions#new', via: :get
    match 'logout', to: 'sessions#logout', as: :logout


    match 'settings', to: 'settings#settings', as: :admin_settings
    match 'settings/menu_items', to: 'settings#menu_items', as: :menu_items
    match 'password_resets/:id/admin_edit' =>  'password_resets#admin_edit', :as => :password_reset, :via => [:get]
    
   match 'password_resets/validate_token' =>  'password_resets#validate_token', :via => [:post]
    
    match 'password_resets/:id/admin_update' => 'password_resets#admin_update', :as => :password_update,  :via => [:put]

    match 'hotels/edit', to: 'hotels#edit', via: :get

    resources :sessions, :hotel_chains, :hotel_brands, :hotels, :user_admin_bookmark, :roles_permissions,
              :departments, :roles, :hotel_rate_types, :hotel_rooms, :hotel_chains
     
    resources  :hotel_payment_types, only: [:index, :show, :create, :destroy] do
      post :activate_credit_card, on: :collection
      post :update_credit_card, on: :collection
    end
    
    resources :users do
      get 'find_existing', on: :collection
      post 'link_existing', on: :collection
    end

    resources :hotels do
      post 'test_mli_settings', on: :collection
    end


    resources :rates, except: [:show]
    
    resources :maintenance_reasons

    match 'roles_permissions/add_permission', to: 'roles_permissions#add_permission', via: :post
    match 'roles_permissions/remove_permission', to: 'roles_permissions#remove_permission', via: :post
    match 'roles_permissions/get_permissions', to: 'roles_permissions#get_permissions', via: :get
    match 'roles_permissions/save_permissions', to: 'roles_permissions#save_permissions', via: :post

    match 'rooms/import', to: 'room_types#import_rooms', via: :get

    match 'user/send_invitation', to: 'users#send_invitation', via: :post

    # Fetch current user name(First name Last Name) and email
    match 'user/get_user_name_and_email', to: 'users#get_curent_user_name_and_email', via: :get
    # Change user password
    match 'user/change_password', to: 'users#change_password', via: :post

    # Hotel Admin Links List Menus and List hotels for the Current User
    match 'hotel_admin/dashboard', to: 'hotel_admin_dashboard#dashboard', via: :get
    match 'hotel_admin/update_current_hotel', to: 'hotel_admin_dashboard#update_current_hotel', via: :post

    match 'room_upsells/room_upsell_options', to: 'room_upsells#room_upsell_options', via: :get
    match 'room_upsells/update_upsell_options', to: 'room_upsells#update_upsell_options', via: :post

    match 'users/toggle_activation', to: 'users#toggle_activation', via: :post

    # Late check out upsell - Begin
    match 'hotel/update_late_checkout_setup', to: 'late_checkout_charge#update_late_checkout_setup', via: :post
    match 'hotel/get_late_checkout_setup', to: 'late_checkout_charge#get_late_checkout_setup', via: :get
    # Late checkout upsell - End

    match 'get_review_settings', to: 'reviews_setups#index', via: :get
    match '/update_review_settings', to: 'reviews_setups#update', via: :post

    match 'get_room_key_delivery_settings', to: 'room_key_delivery_settings#index', via: :get
    match '/update_room_key_delivery_settings', to: 'room_key_delivery_settings#update', via: :post

    match 'rates/import', to: 'rates#import', via: :get

    match 'hotel_rate_types/save', to: 'hotel_rate_types#toggle_activation', via: :post

    # Announcements Settings - Begin
    match 'hotel/save_announcements_settings', to: 'hotel_announcements_settings#save', via: :post
    match 'hotel/get_announcements_settings', to: 'hotel_announcements_settings#index', via: :get
    # Announcements Settings - End

    # Social Lobby Settings - Begin
    match 'hotel/save_social_lobby_settings', to: 'hotel_social_lobby_settings#save', via: :post
    match 'hotel/get_social_lobby_settings', to: 'hotel_social_lobby_settings#index', via: :get
    # Social Lobby Settings - End

    match 'charge_codes/import', to: 'charge_codes#import', via: :get

    resources :room_types

    match 'hotel/create_membership/', to: 'hotel_memberships#create', via: :post

    # FFPs API begin
    match 'hotel/list_ffps/', to: 'hotel_memberships#list_ffp', via: :get
    match 'hotel/toggle_ffp_activation/', to: 'hotel_memberships#toggle_ffp_activation', via: :post
    # FFPs API endmy_array.find { |e| e.satisfies_condition? }

    # HLPs API begin

    match 'hotel/list_hlps/', to: 'hotel_memberships#list_hlp', via: :get
    match 'hotel/add_hlp/', to: 'hotel_memberships#add_hlp', via: :get
    match 'hotel/edit_hlp/:id', to: 'hotel_memberships#edit_hlp', via: :get
    match 'hotel/save_hlp/', to: 'hotel_memberships#save_hlp', via: :post
    match 'hotel/update_hlp/', to: 'hotel_memberships#update_hlp' , via: :put
    match 'hotel/toggle_hlp_activation/', to: 'hotel_memberships#toggle_hlp_activation' , via: :post

    # HLPs API end
    # Hotel Likes Category
    match 'hotel_likes/get_hotel_likes', to: 'hotel_likes#get_hotel_likes', via: :get
    match 'hotel_likes/:id/edit_hotel_likes', to: 'hotel_likes#edit_hotel_likes', via: :get
    match 'hotel_likes/add_feature_type', to: 'hotel_likes#add_feature_type', via: [:post, :put]
    match 'hotel_likes/activate_feature', to: 'hotel_likes#activate_feature_type', via: :post
    match 'hotel_likes/save_custom_likes', to: 'hotel_likes#save_custom_likes', via: :post
    match 'hotel_likes/delete_feature', to: 'hotel_likes#delete_custom_feature', via: :post

    resources :charge_groups

    match 'external_mappings/:hotel_id/list_mappings', to: 'external_mappings#list_mappings', via: :get
    match 'external_mappings/:hotel_id/new_mappings', to: 'external_mappings#new_mappings', via: :get
    match 'external_mappings/save_mapping', to: 'external_mappings#save_mapping', via: :post
    match 'external_mappings/:id/edit_mapping', to: 'external_mappings#edit_mapping', via: :get
    match 'external_mappings/:id/delete_mapping', to: 'external_mappings#delete_mapping', via: :delete

    match 'checkin_setups/list_setup', to: 'checkin_setups#list_setup', via: :get
    match 'checkin_setups/save_setup', to: 'checkin_setups#save_setup', via: :post
    match 'checkin_setups/notify_all_checkin_guests', to: 'checkin_setups#send_checkin_notification', via: :post

    match 'charge_codes/list', to: 'charge_codes#list_charge_codes', via: :get
    match 'charge_codes/minimal_list', to: 'charge_codes#charge_codes_minimal_list', via: :get
    match 'charge_codes/new', to: 'charge_codes#new_charge_code', via: :get
    match 'charge_codes/save', to: 'charge_codes#save_charge_code', via: :post
    match 'charge_codes/:id/edit', to: 'charge_codes#edit_charge_code', via: :get
    match 'charge_codes/:id/delete', to: 'charge_codes#delete_charge_code', via: :get
    match 'charge_codes/import', to: 'charge_codes#import', via: :get
    match 'charge_codes/:id/delete_tax', to: 'charge_codes#delete_tax', via: :delete

    match 'get_pms_connection_config', to: 'pms_connection#get_pms_connection_config', via: :get
    match 'save_pms_connection_config', to: 'pms_connection#save_pms_connection_config', via: :post
    match 'test_pms_connection', to: 'pms_connection#test_pms_connection', via: :post

    match 'items/get_items', to: 'items#get_items', via: :get
    match 'items/new_item', to: 'items#new_item', via: :get
    match 'items/save_item', to: 'items#save_item', via: :post
    match 'items/:id/edit_item', to: 'items#edit_item', via: :get
    match 'items/:id/delete_item', to: 'items#delete_item', via: :get
    match 'items/toggle_favorite', to: 'items#toggle_favorite', via: :post

    match 'hotels/:hotel_id/toggle_res_import_on', to: 'hotels#toggle_res_import_on', via: :post

    match 'hotel_business_dates', to: 'hotel_business_dates#index', via: :get
    match 'hotel_business_dates/sync', to: 'hotel_business_dates#sync', via: :post

    match 'hotel_payment_types/activate_credit_card', to: 'hotel_payment_types#activate_credit_card', via: :post

    match 'save_checkout_settings', to: 'hotel_checkout_settings#save', via: :post
    match 'get_checkout_settings', to: 'hotel_checkout_settings#index', via: :get
    match 'send_checkout_alert' , to: 'hotel_checkout_settings#send_checkout_notification', via: :post
    match 'get_due_out_guests', to: 'hotel_checkout_settings#get_due_out_guests', via: :get
    match 'get_due_in_guests', to: 'checkin_setups#get_due_in_guests', via: :get

    resources :house_keeping_settings, only: [:index, :create]
 
  end

end
