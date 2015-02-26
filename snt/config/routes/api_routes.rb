Pms::Application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :addons, except: [:new, :edit] do
      post 'activate', on: :member
      post 'bestseller', on: :collection
      post :import, on: :collection
    end

    resources :charge_codes, only: :index

    resources :charge_groups, only: :index do
      get :for_addons, on: :collection
    end

    resources :countries, only: :index

    resources :reference_values, only: :index

    resources :rate_types, except: [:new, :edit] do
      get :active, on: :collection
      post :activate, on: :member
    end

    resources :rates, except: [:new, :edit] do
      put :room_types, on: :member
      post :import, on: :collection
      resources :rate_date_ranges, only: [:index, :create]
      get :contract_rates, on: :collection
      put :enable_disable, on: :collection
      post :validate_end_date, on: :collection
      get :tax_information, on: :collection
    end

    resources :rate_date_ranges, only: [:show, :update, :destroy] do
      resources :rate_sets, only: [:create]
    end
    resources :rate_sets, only: [:show, :update, :destroy]
    resources :room_types, only: [:index]

    resources :restriction_types, only: :index do
      post 'activate', on: :member
    end

    # TODO: Once UI start working on API Guide format, will change the routes accordingly.
    match 'password_resets/:id/update' => 'password_resets#update', :as => :password_update,  :via => [:put]
    match 'password_resets/validate_token' =>  'password_resets#validate_token', :via => [:post]
    match 'password_resets/:token/activate_user' =>  'password_resets#activate_user', :via => [:get]

    resources :hotel_settings, only: :index do
      post 'change_settings', on: :collection
      post :save_hotel_reservation_settings, on: :collection
      get :show_hotel_reservation_settings, on: :collection
      get :payment_types, on: :collection
      get :credit_card_types, on: :collection
    end

    resources :sources, only: [:index, :create, :update, :destroy] do
      post :use_sources, on: :collection
    end

    resources :reports, only: [:index, :show] do
      get :search_by_company_agent_group, on: :collection
      get :search_by_guarantee, on: :collection
      get :submit, on: :member
    end
    # Filtering search in report
    # match "reports/search_by_company_agent_group", to: 'reports#search_by_company_agent_group', via: :get
    # match 'reports/search_by_guarantee', to: 'reports#search_by_guarantee', via: :get


    resources :booking_origins, only: [:index, :create, :update, :destroy] do
      post :use_origins, on: :collection
    end

    resources :users, only: [] do
      get :active, on: :collection
    end

    resources :maintenance_reasons

    resources :hotels, only: [] do
      get :get_black_listed_emails, on: :collection
      post :save_blacklisted_emails, on: :collection
      delete :delete_email, on: :member
    end


    get 'hotel_statistics', to: 'hotels#hotel_statistics'
    get 'rover_header_info', to: 'hotels#rover_header_info'
    get 'current_user_hotels', to: 'users#current_user_hotels'

    resources :reservations, only: [:show, :create, :update] do
      post :queue, on: :member
      post :email_confirmation, on: :member
      post :advance_bill, on: :member
      post :search_reservation, on: :collection
      post 'unassign_room', on: :member
      post :email_guest_bill, on: :collection
      get :bills, on: :member
      post :submit_payment, on: :member
      get 'policies', on: :member
      get :web_checkin_reservation_details, on: :member
      post :cancel, on: :member
      post :guests, on: :collection
      post :add_guest, on: :collection
      post :remove_guest, on: :collection
      post :update_stay_details, on: :member
      post :pre_checkin, on: :member
      post :pay_bill, on: :member
      get :kiosk_search, on: :collection
      post :reservation_details, on: :collection
      post :hourly_confirmation_emails, on: :collection
      get :early_checkin_details, on: :member
      get :early_checkin_offer, on: :member
      post :apply_early_checkin_offer, on: :collection
      get :bill_print_data, on: :member
      get :find_by_key_uid, on: :collection
      post :update_key_uid, on: :collection
      post :delete_addons, on: :member
      get :deposit_policy, on: :member
      resources :smartbands, only: [:index, :create] do
        get :with_balance, on: :collection
        post :cash_out, on: :collection
      end

      resources :cards, only: [], controller: :reservation_cards do
        put :replace, on: :collection
        delete :remove, on: :collection
      end
      
      resources :reservations_guest_details, only: [:index, :create]
    end

    resources :smartbands, only: [:show, :update]

    resources :hotel_settings, only: [:index] do
      get :icare, on: :collection
      post :change_settings, on: :collection
      post :queue, on: :member
    end

    resources :market_segments, except: [:new, :edit] do
      post :use_markets, on: :collection
    end

    resources :hotel_messages, except: [:new, :edit]
    resources :daily_rates, only: [:index, :show, :create]

    resources :daily_occupancies, only: [:index] do
      post :targets, on: :collection
    end

    resources :policies, except: [:new, :edit]

    resources :accounts do
      resources :contracts do
        resources :contract_nights
      end
    end

    resources :business_dates, only: [] do
      get :active, on: :collection
      post :change_business_date, on: :collection
    end

    resources :accounts, only: [:index, :show] do
      post :save, on: :collection
      get :ar_details, on: :member
      post :save_ar_details, on: :collection
      get :ar_notes, on: :member
      post :save_ar_note, on: :collection
      post :delete_ar_note, on: :collection
      delete :delete_ar_detail, on: :member
      resources :ar_transactions do
        post :pay, on: :member
        post :pay_all, on: :collection
        post :open, on: :member
      end
    end

    resources :availability, only: :index do
      get :house, on: :collection
    end

    resources :hourly_availability, only: :index do
      get :room, on: :collection
      get :room_move, on: :collection
    end

    resources :hourly_occupancy, only: :index

    resources :roles, only: [:index, :update]

    resources :floors, only: [:index, :show, :destroy] do
      post :save, on: :collection
    end

    resources :reservation_types, only: [:index] do
      post :activate, on: :collection
    end

    resources :billing_groups, only: [:index, :show, :create, :update, :destroy] do
      get :charge_codes, on: :collection
    end

    resources :beacons, except: [], controller: :beacon_details do
      post 'activate', on: :member
      get :ranges, on: :collection
      get :types, on: :collection
      get :uuid_values, on: :collection
      get :proximity, on: :collection
      post :link, on: :collection
    end

    resources :guest_details, only: [:index, :show, :create, :update]

    get :test_mli_payment_gate_way, to: 'hotel_settings#test_mli_payment_gate_way'

    resources :dashboards, only: [:index]

    resources :end_of_days do
      post :authenticate_user, on: :collection
      get :change_business_date, on: :collection
    end
    resources :bill_routings do
      get :attached_entities, on: :member
      get :attached_cards, on: :member
      get :charge_codes, on: :collection
      get :billing_groups, on: :collection
      post :save_routing, on: :collection
      post :delete_routing, on: :collection
      get :bills, on: :member
    end

    resources :financial_transactions do
      get :revenue, on: :collection
      get :payments, on: :collection
    end
    resources :bills, only: [] do
      post :create_bill, on: :collection
      post :transfer_transaction, on: :collection
    end

    resources :work_types
    resources :tasks do
      get :hk_applicable_statuses, on: :collection
    end
    resources :shifts
    resources :work_statistics do
      get :employees_list, on: :collection
      get :employee, on: :collection
    end
    resources :work_sheets do
      get :active, on: :collection
    end

    resources :work_logs, only: [:create, :update]

    resources :reservation_hk_statuses, only: [:index]
    resources :front_office_statuses, only: [:index]
    resources :house_keeping_statuses, only: [:index]

    match 'work_assignments' =>  'work_assignments#index', :via => [:post]
    match 'work_assignments/assign' =>  'work_assignments#assign', :via => [:post]
    match 'work_assignments/record_time' => 'work_assignments#update_work_time', :via => [:post]
    match 'work_assignments/unassigned_rooms' => 'work_assignments#unassigned_rooms', :via => [:get]

    resources :groups, only: [:index]
    resources :cashier_periods do
      post :close, on: :member
      post :reopen, on: :member
      post :history, on: :collection
    end
    
    # ================== Ipage routes ===========================

    resources :room_services do
      get :status_list, on: :collection
      get :inactive_rooms, on: :collection
      put :in_service, on: :member
      get :service_info, on: :collection
    end


    get 'ipage/index'           => 'ipage#index'
    # ======================= Ends =============================

    resources :workstations, only: [:index, :show, :create, :update, :destroy]

    #================= Credit card transaction routes ===============
    resources :credit_card_transactions, only: [], path: '/cc/' do
      post :authorize, on: :collection
      post :refund, on: :collection
      post :cancel, on: :collection
      post :check_status, on: :collection
      post :settle, on: :collection
      post :auth_settle, on: :collection
      match :get_token, on: :collection
      post :reverse, on: :collection
    end
    # ======================= Ends =============================

    resources :rooms

    resources :async_callbacks, only: [:show]

    resources :cms_components, only: [:update, :index, :show, :destroy] do
      post :save, on: :collection
      get :tree_view, on: :collection
    end

    resources :hotel_current_time
    match 'cms_components/:parent_id/sub_categories', to: 'cms_components#sub_categories', via: :get
    match 'hourly_availability_count', to: 'hourly_availability#availability_count'
    resources :room_types_task_completion_time, only: [:index]
    resources :hourly_rate_min_hours
    resources :stationary, only: [:index] do
      post :save, on: :collection
    end

    resources :default_account_routings, only: [:show] do
      post :save, on: :collection
      post :attach_reservation, on: :collection
      post :routings_count, on: :collection
    end

    resources :key_encoders, except: [:new, :edit] do
      get :active, on: :collection
      put :activate, on: :member
    end
    # get 'email_templates/:hotel_id', to: 'email_templates#load_templates'
    resources :email_template_themes do
      post :get_email_templates, on: :collection
      get :list_themes, on: :collection
    end

    resources :early_checkin_setups, only: [] do
      get :get_setup, on: :collection
      post :save_setup, on: :collection
    end

    resources :email_templates do
      get :list, on: :collection
      post :assign_to_hotel, on: :collection
      get :email_templates, on: :collection
    end

    resources :analytics_setups, only: :index do
      post :save_setup, on: :collection
    end
    
    resources :campaigns do
      post :start_campaign, on: :collection
      get :alert_length, on: :collection
    end

    resources :campaign_messages, only: [:index, :show, :destroy] do

    end
  end
end
