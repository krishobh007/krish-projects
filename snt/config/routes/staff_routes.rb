Pms::Application.routes.draw do

  namespace :staff do
    root to: 'dashboard#rover'
    get 'dashboard', to: 'dashboard#index'
    get 'header_info', to: 'dashboard#header_info'
    get 'login', to: 'sessions#new'
    match '/logout', to: 'sessions#logout', as: :logout
    match 'users/:code/activate', to: 'users#activate'
    resources :sessions

    # Dashboard methods -begin

    match 'dashboard', to: 'dashboard#index'
    match 'dashboard/:hotel_code/due_in_status_list', to: 'dashboard#due_in_status_list', via: :get
    match 'dashboard/:hotel_code/inhouse_status_list', to: 'dashboard#inhouse_status_list', via: :get
    match 'dashboard/:hotel_code/due_out_status_list', to: 'dashboard#due_out_status_list', via: :get
    match 'dashboard/dashboard', to: 'dashboard#dashboard',  as: :dashboard
    match 'dashboard/dashboard', to: 'dashboard#index', via: :get , as: :dashboard
    match 'dashboard/settings', to: 'dashboard#settings', as: :settings , via: :get
    match 'dashboard/update_guest', to: 'dashboard#update_guest'
    match 'dashboard/late_checkout_count', to: 'dashboard#late_checkout_count', via: :get

    # Dashboard methods -end

    # staycard methods - begin

    match 'staycards/staycard', to: 'staycards#staycard'
    match 'staycards/reservation_details', to: 'staycards#reservation_details'
    match 'staycards/validate_email_phone', to: 'staycards#validate_email_phone'
    match 'staycards/get_credit_cards', to: 'staycards#get_credit_cards', via: :get
    match 'staycards/unlink_credit_card', to: 'staycards#unlink_credit_card', via: :post
    match 'staycards/reservation_addons', to: 'staycards#reservation_addons', via: :get
    # staycard methods - end

    # payment methods -begin

    match 'payments/payment', to: 'payments#payment'
    match 'payments/addNewPayment', to: 'payments#addNewPayment'
    match 'payments/save_new_payment', to: 'payments#save_new_payment'
    match 'payments/showCreditModal', to: 'payments#showCreditModal'
    match 'payments/setCreditAsPrimary', to: 'payments#setCreditAsPrimary'
    match 'payments/deleteCreditCard', to: 'payments#deleteCreditCard'
    match 'payments/tokenize', to: 'payments#tokenize', via: :post
    match 'payments/search_by_cc', to: 'payments#search_by_cc', via: :post

    # payment methods -end

    # preferences methods -begin

    match 'preferences/likes', to: 'preferences#likes', as: :guest_likes , via: :get
    match 'preferences/add_reservation_newspaper_preference', to: 'preferences#add_reservation_newspaper_preference'
    match 'preferences/room_assignment', to: 'preferences#room_assignment'

    # preferences methods -end

    # Membership routes - Begin

    match 'user_memberships/get_available_ffps', to: 'user_memberships#get_available_ffps', via: :get
    match 'user_memberships/get_available_hlps', to: 'user_memberships#get_available_hlps', via: :get
    match 'user_memberships/new_ffp', to: 'user_memberships#new_ffp', via: :get
    match 'user_memberships/new_hlp', to: 'user_memberships#new_hlp', via: :get
    match 'user_memberships/delete_membership', to: 'user_memberships#delete_membership', via: :get
    match 'user_memberships/link_to_reservation', to: 'user_memberships#link_to_reservation', via: :post
    match 'user_memberships/new_loyalty', to: 'user_memberships#new_loyalty', via: :get

    resources :user_memberships
    resources :user_memberships, only: [:create, :destroy]

    # Membership routes - End

    match 'reservation/save_payment', to: 'reservations#save_payment', via: :post
    match 'reservation/link_payment', to: 'reservations#link_payment', via: :post
    match 'reservations/:id/deposit_and_balance', to: 'reservations#deposit_and_balance', via: :get

    # Rooms routes - START
    match 'rooms/get_rooms', to: 'rooms#available', via: :post
    # Rooms routes - END

    # GuestCard routes - Begin

    resources :guest_cards, only: [:show, :update]
    match 'guest_cards/:id/update_preferences', to: 'guest_cards#update_preferences', via: [:post]
    match 'guestcard/show', to: 'guest_cards#show', via: [:get]

    # GuestCard routes - END

    # Upsell routes - Begin

    match 'reservations/room_upsell_options', to: 'reservations#reservation_room_upsell_options', via: :get
    match 'reservations/upgrade_room', to: 'reservations#upgrade_room', via: :post

    # Upsel Routes - End

    # Room keys - Begin
    match 'reservations/:id/get_key_setup_popup', to: 'reservations#get_key_setup_popup', via: :get

    match 'reservation/print_key', to: 'reservations#print_key', via: :post
    match '/reservation/qr_code_image', to: 'reservations#qr_code_image'
    # Room keys - End

    # Modify reservations - START
    match 'reservation/modify_reservation', to: 'reservations#modify_reservation', via: :post
    # Modify reservations - END

    # CheckIn API Begin
    match 'checkin', to: 'reservations#checkin', via: :post
    match 'checkout' , to: 'reservations#checkout', via: :post
    # CheckIn API End

    match 'reservation/bill_card', to: 'reservations#bill_card', via: :get
    match 'reservation/:id/get_pay_bill_details', to: 'reservations#get_pay_bill_details', via: :get
    match 'reservation/post_payment', to: 'reservations#post_payment', via: :post

    # For validating checkout e-mail in Checkout
    match 'staycards/validate_email', to: 'staycards#validate_email'
    match 'items/get_items', to: 'items#get_items', via: :get
    match 'items/post_items_to_bill', to: 'items#post_items_to_bill', via: :post

    # Change stay routing -begin
    #match "reservations/:id/get_key_on_tablet", to: "reservations#get_key_on_tablet",  via: :get
    #match "reservations/:id/show_key_delivery", to: "reservations#show_key_delivery",  via: :get

    match 'change_stay_dates/:reservation_id/calendar', to: 'change_stay_dates#show', via: :get
    match 'change_stay_dates/:reservation_id/', to: 'change_stay_dates#show_page', via: :get
    match 'change_stay_dates/:reservation_id/update', to: 'change_stay_dates#update', via: :get
    match 'change_stay_dates/:reservation_id/confirm', to: 'change_stay_dates#confirm', via: :post
    match 'bills/transfer_transaction', to: 'bills#transfer_transaction',  via: :post
    match 'bills/print_guest_bill', to: 'bills#print_guest_bill',  via: :post
    match 'reservations/:id/get_key_on_tablet', to: 'reservations#get_key_on_tablet',  via: :get
    match 'reservations/:id/show_key_delivery', to: 'reservations#show_key_delivery',  via: :get

  end

end
