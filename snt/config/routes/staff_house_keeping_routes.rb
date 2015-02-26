Pms::Application.routes.draw do

  namespace :staff_house_keeping, path: 'house' do
    root to: 'dashboard#index'

    resources :sessions

    match 'login', to: 'sessions#new',  as: :login, via: :get

    match '/logout', to: 'sessions#logout',  as: :logout, via: :get

    # Dashboard methods -begin
    match 'dashboard', to: 'dashboard#index', via: :get
    # Dashboard methods -end

    # Show all rooms
    # Search will support both GET  and POST methods
    # Once room filters is stable, this will be changed to POST - CICO-10222
    match 'search' => "rooms#search", via: [:get, :post]

    # Room Details screen
    match 'room/:room_id', to: 'rooms#room_details', via: :get

    # Change House Keeping Status
    match '/change_house_keeping_status', to: 'rooms#change_house_keeping_status', via: :post

  end
end
