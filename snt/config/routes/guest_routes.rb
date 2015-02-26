Pms::Application.routes.draw do
  namespace :guest do
    match '/login' , to: 'sessions#login', via: [:post]
    match '/sign_up', to: 'sessions#sign_up', via: [:post]
    match '/logout' , to: 'sessions#logout', via: [:post]
    match '/facebook_login' , to: 'sessions#facebook_login', via: [:post]
    match '/linkedin_login' , to: 'sessions#linkedin_login', via: [:post]
    match 'users/activate', to: 'users#activate'
    match 'users/:id/send_verification_email', to: 'users#send_verification_email'
    match 'users/send_password_reset_email', to: 'users#send_password_reset_email', via: [:post]
    match 'users/update_password', to: 'users#update_password', via: [:post]

    # To get all bookings
    match '/get_all_bookings' , to: 'reservations#get_all_bookings', via: [:post]
    match '/get_booking_details' , to: 'reservations#get_booking_details', via: [:post]

    # To set lobby status
    match '/set_lobby_status/:id', to: 'reservations#set_lobby_status', via: :post

    # To manage the Posts in the Mobile device
    match '/hotels/:hotel_id/posts' => 'posts#index', :via => :get
    match '/hotels/:hotel_id/posts' => 'posts#create', :via => :post

    # To comments URLS
    match '/hotels/:hotel_id/posts/:commentable_id/comments' => 'comments#index', :via => [:get], :defaults => { commentable_type: 'SbPost' }
    match '/hotels/:hotel_id/posts/:commentable_id/comments' => 'comments#create', :via => [:post], :defaults => { commentable_type: 'SbPost' }

    # TODO Dummy place holder, this comes when comments code picked from SL, once code change, this will replaced.
    match '/footer_content' => 'base#footer_content'

    # Lobby status
    match '/hotels/:hotel_id/posts/:group_id' => 'posts#index', :via => :get
    match '/reservations/:id/room_upsell_options', to: 'reservations#reservation_room_upsell_options', via: :get
    match 'reservations/upgrade_room', to: 'reservations#upgrade_room', via: :post
    match '/reservations/:id/create_reservation_key', to: 'reservations#create_reservation_key', via: :get
    match '/reservation/qr_code_image', to: 'reservations#qr_code_image'

    match '/users/update_user_details', to: 'users#update_user_details' , via: :put
    match '/users/:id/get_user_details' , to: 'users#get_user_details', via: [:get]
    match '/users/:id/my_profile' , to: 'users#my_profile', via: [:get]

    # Device Registration For Push Notification
    match 'notifications/device_register', to: 'notifications#device_register', via: :post

    # Checkin / Checkout
    match '/checkin/:reservation_id' => 'reservations#checkin', via: :post
    match '/checkout' => 'reservations#checkout', via: :post

    # List Terms & conditions based on Hotel/Hotel Chain
    match '/get_terms_conditions' => 'terms_conditions#get_terms_conditions', via: :post

    # Routes to guest bills
    match '/get_bill_items' => 'bills#get_bill_items', via: :post

    # Routes to hotel upsell late checkout
    match '/hotels/:hotel_id/late_checkout_settings' => 'hotels#late_checkout_settings', via: :get
    match '/reservations/apply_late_checkout' => 'reservations#apply_late_checkout', via: :post

    # Routes to hotel reviews
    match '/hotels/:hotel_id/review_list' => 'reviews#review_list', via: :get
    match '/reviews/:review_id/review_details' => 'reviews#review_details', via: :get
    match '/hotels/:hotel_id/review_categories' => 'hotels#hotel_review_categories', via: :get
    match '/reviews/review_hotel' => 'reviews#review_hotel', via: :post

    match 'reservations/:reservation_id/auto_assign_room'  => 'reservations#auto_assign_room', via: :get

    match 'wakeups/:reservation_id/wakeup_calls'  => 'wakeups#wakeup_calls', via: :get
    match 'wakeups/set_wakeup_calls'  => 'wakeups#add_or_update_wakeup_calls', via: :post

    match 'reservation/add_newspaper_preference', to: 'reservation_preferences#add_reservation_newspaper_preference', via: :post
    match 'reservation_notes/add_reservation_note', to: 'reservation_notes#create', via: :post
    match 'reservations/search', to: 'reservations#search', via: :post
    match 'users/link_reservation', to: 'users#link_reservation', via: :post

    resources :notification_details, controller: 'notifications'
    match 'notification_preferences', to: 'notification_preferences#show', via: :get
    match 'save_notification_preferences', to: 'notification_preferences#save', via: :post
    match 'notifications/:id/mark_as_read', to: 'notifications#mark_as_read', via: :get

    match 'hotels/get_message_count' , to: 'hotels#get_message_count', via: :post
    match 'reservations/get_recent_reservation' , to: 'reservations#get_recent_reservation', via: :get

    #Routes to text-to-staff
    match 'conversations/list', to: 'conversations#list', via: :post
    match 'conversations/:conversation_id/details', to: 'conversations#details', via: :get
    match 'hotels/:hotel_id/staff_directory', to: 'hotels#staff_directory', via: :get
    match 'conversations/create', to: 'conversations#create', via: :post

    #--------- ROUTES FOR CMS COMPONENTS ----------#
    match 'cms_components/sub_categories', to: 'cms_components#sub_categories', via: :post
    match 'cms_components/:parent_id/sub_categories', to: 'cms_components#sub_categories', via: :get
    
  end
end
