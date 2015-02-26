Pms::Application.routes.draw do

  get 'room_assignment/index'

  match 'ui/show', to: 'ui#show'

  # Common Login UI
  resources :sessions
  match '/logout', to: 'sessions#logout', as: :logout
  match '/timeout', to: 'sessions#timeout', via: :get
  # Root to default staff login
  root to: 'login#new'

  resources :reservation_notes

  match 'reservation/add_newspaper_preference', to: 'reservation_preferences#add_reservation_newspaper_preference'
  match 'wakeup/wakeup_calls', to: 'wakeups#wakeup_calls', via: :post
  match 'wakeup/set_wakeup_calls', to: 'wakeups#add_or_update_wakeup_calls', via: :post

  match 'ui/wakeupCall', to: 'ui#wakeupCall'
  match 'ui/registration', to: 'ui#registration'
  match 'ui/updateAccountSettings', to: 'ui#updateAccountSettings'
  match 'ui/successModal', to: 'ui#successModal'
  match 'ui/checkoutSuccessModal', to: 'ui#checkoutSuccessModal'
  match 'ui/failureModal', to: 'ui#failureModal'
  match 'ui/bill_card', to: 'ui#bill_card'
  match 'ui/validateOptEmail', to: 'ui#validateOptEmail'
  match 'ui/earlyDeparture', to: 'ui#earlyDeparture'
  match 'ui/roomTypeChargeModal', to: 'ui#roomTypeChargeModal'
  match 'ui/country_list', to: 'ui#country_list', via: :get
  match 'ui/add_new_payment', to: 'ui#add_new_payment'
  match 'ui/terms_and_conditions', to: 'ui#terms_and_conditions'


  # search method
  match 'search_view', to: 'search#search_view', via: :get , as: :search_view
  match 'search' => 'search#search', via: :get


  mount Resque::Server.new, at: '/resque'

  wash_out :ariane

  wash_out 'api/ytl/papi_general'
  wash_out 'api/ytl/papi_booking'

  # Angular based Login URL
  match '/login' , to: 'login#new', via: :get
  match '/login/submit' , to: 'login#create', via: :post

  resources :templates, only: [] do
    get 'reports', on: :collection
  end
  mount MailPreview => 'mail_view' if Rails.env.development?
end
