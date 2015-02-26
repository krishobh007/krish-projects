Pms::Application.routes.draw do

  namespace :guest_web do
    match 'home/index' , to: 'home#index', via: [:get]
    match 'home/user_activation' , to: 'home#user_activation', via: [:get]
    match 'home/password_rest', to: 'home#password_reset', via: [:get]
    match 'home/bill_details' , to: 'home#bill_details', via: [:get]
    match 'get_late_checkout_charges', to: 'late_checkout#get_late_checkout_charges', via: :get
    match 'apply_late_checkout', to: 'late_checkout#apply_late_checkout', via: :post
    match 'home/checkout_guest', to: 'home#checkout_guest', via: :post
    match 'verify_room', to: 'home#verify_room', via: :post


    # Checkin urls

    match 'search', to: 'checkins#get_checkin_reservation', via: :post
    match 'upgrade_options', to: 'checkins#upgrade_options', via: :get
    match 'checkin', to: 'checkins#checkin', via: :post
    match 'upgrade_room', to: 'checkins#upgrade_room', via: :post

  end

end
