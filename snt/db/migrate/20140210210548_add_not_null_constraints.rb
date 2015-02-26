class AddNotNullConstraints < ActiveRecord::Migration
  def change
    change_column :accounts, :account_name, :string, null: false
    change_column :accounts, :account_number, :string, null: false
    change_column :accounts, :account_type_id, :integer, null: false
    change_column :accounts, :hotel_id, :integer, null: false
    add_index :accounts, [:account_number, :account_type_id, :hotel_id], unique: true, name: 'index_accounts_uniq'

    execute 'delete a from addons a, addons b where a.id < b.id and a.name = b.name and a.hotel_id = b.hotel_id'
    change_column :addons, :name, :string, null: false
    add_index :addons, [:name, :hotel_id], unique: true

    execute 'delete a from admin_menu_options a, admin_menu_options b where a.id < b.id and a.name = b.name and a.admin_menu_id = b.admin_menu_id'
    change_column :admin_menu_options, :name, :string, null: false
    change_column :admin_menu_options, :action_path, :string, null: false
    change_column :admin_menu_options, :admin_menu_id, :integer, null: false
    add_index :admin_menu_options, [:name, :admin_menu_id], unique: true

    change_column :admin_menus, :name, :string, null: false
    change_column :admin_menus, :available_for, :string, null: false
    add_index :admin_menus, :name, unique: true

    change_column :admin_reviews_setups, :hotel_id, :integer, null: false
    add_index :admin_reviews_setups, :hotel_id, unique: true

    change_column :api_keys, :email, :string, null: false
    change_column :api_keys, :key, :string, null: false
    add_index :api_keys, :email, unique: true

    drop_table :authorizations

    execute 'delete a from bills a, bills b where a.id < b.id and a.reservation_id = b.reservation_id and a.bill_number = b.bill_number'
    change_column :bills, :reservation_id, :integer, null: false
    change_column :bills, :bill_number, :integer, null: false
    add_index :bills, [:reservation_id, :bill_number], unique: true

    change_column :charge_code_generates, :charge_code_id, :integer, null: false
    change_column :charge_code_generates, :generate_charge_code_id, :integer, null: false
    add_index :charge_code_generates, [:charge_code_id, :generate_charge_code_id], unique: true, name: 'index_charge_code_generates_uniq'

    execute 'delete a from charge_codes a, charge_codes b where a.id < b.id and a.charge_code = b.charge_code and a.hotel_id = b.hotel_id'
    change_column :charge_codes, :charge_code, :string, null: false
    change_column :charge_codes, :hotel_id, :integer, null: false
    change_column :charge_codes, :charge_code_type_id, :integer, null: false
    add_index :charge_codes, [:charge_code, :hotel_id], unique: true

    execute 'delete a from charge_groups a, charge_groups b where a.id < b.id and a.charge_group = b.charge_group and a.hotel_id = b.hotel_id'
    change_column :charge_groups, :charge_group, :string, null: false
    change_column :charge_groups, :hotel_id, :integer, null: false
    add_index :charge_groups, [:charge_group, :hotel_id], unique: true

    change_column :charge_groups_codes, :charge_group_id, :integer, null: false
    change_column :charge_groups_codes, :charge_code_id, :integer, null: false
    add_index :charge_groups_codes, [:charge_group_id, :charge_code_id], unique: true

    change_column :comments, :commentable_id, :integer, null: false
    change_column :comments, :commentable_type, :string, null: false
    change_column :comments, :user_id, :integer, null: false
    change_column :comments, :comment, :text, null: false

    change_column :countries, :name, :string, null: false
    change_column :countries, :code, :string, null: false
    add_index :countries, :name, unique: true
    add_index :countries, :code, unique: true

    execute 'delete from departments where hotel_id is null'
    change_column :departments, :name, :string, null: false
    change_column :departments, :hotel_id, :integer, null: false
    add_index :departments, [:name, :hotel_id], unique: true

    change_column :email_templates, :body, :text, null: false
    change_column :email_templates, :subject, :text, null: false
    change_column :email_templates, :title, :string, null: false
    add_index :email_templates, [:title, :hotel_id], unique: true

    change_column :entities, :name, :string, null: false
    add_index :entities, :name, unique: true

    execute "delete from external_mappings where value is null or value = ''"
    change_column :external_mappings, :external_value, :string, null: false, limit: 80
    change_column :external_mappings, :value, :string, null: false, limit: 80
    change_column :external_mappings, :mapping_type, :string, null: false, limit: 55
    change_column :external_mappings, :pms_type_id, :integer, null: false

    change_column :external_references, :pms_type_id, :integer, null: false

    change_column :feature_types, :value, :string, null: false
    change_column :feature_types, :selection_type, :string, null: false

    change_column :features, :value, :string, null: false
    change_column :features, :feature_type_id, :integer, null: false

    change_column :financial_transactions, :date, :date, null: false
    change_column :financial_transactions, :amount, :float, null: false
    change_column :financial_transactions, :currency_code_id, :integer, null: false
    change_column :financial_transactions, :bill_id, :integer, null: false

    drop_table :forums

    change_column :groups, :name, :string, null: false
    change_column :groups, :hotel_id, :integer, null: false
    add_index :groups, [:name, :hotel_id], unique: true

    execute "delete from guest_additional_contacts where value is null or value = ''"
    change_column :guest_additional_contacts, :value, :string, null: false
    change_column :guest_additional_contacts, :contact_type_id, :integer, null: false
    change_column :guest_additional_contacts, :label_id, :integer, null: false

    remove_column :guest_addresses, :address_type
    change_column :guest_addresses, :label_id, :integer, null: false

    change_column :guest_details, :last_name, :string, null: false
    change_column :guest_details, :hotel_chain_id, :integer, null: false

    add_index :guest_features, [:guest_detail_id, :feature_id], unique: true

    change_column :guest_memberships, :membership_type_id, :integer, null: false
    change_column :guest_memberships, :membership_card_number, :string, null: false
    add_index :guest_memberships, [:membership_type_id, :guest_detail_id], unique: true, name: 'index_guest_memberships_uniq'

    change_column :guest_payment_types, :guest_detail_id, :integer, null: false
    change_column :guest_payment_types, :payment_type_id, :integer, null: false

    change_column :hotel_brands, :name, :string, null: false
    change_column :hotel_brands, :hotel_chain_id, :integer, null: false
    add_index :hotel_brands, :name, unique: true

    execute 'delete from hotel_business_dates where hotel_id is null or business_date is null'
    execute 'delete a from hotel_business_dates a, hotel_business_dates b where a.id < b.id and a.business_date = b.business_date and a.hotel_id = b.hotel_id'
    change_column :hotel_business_dates, :business_date, :date, null: false
    change_column :hotel_business_dates, :hotel_id, :integer, null: false
    add_index :hotel_business_dates, [:business_date, :hotel_id], unique: true

    change_column :hotel_chains, :name, :string, null: false
    change_column :hotel_chains, :code, :string, null: false
    add_index :hotel_chains, :name, unique: true
    add_index :hotel_chains, :code, unique: true

    change_column :hotel_checkin_setups, :hotel_id, :integer, null: false
    add_index :hotel_checkin_setups, :hotel_id, unique: true

    change_column :hotel_review_categories, :hotel_id, :integer, null: false
    change_column :hotel_review_categories, :ref_review_category_id, :integer, null: false
    add_index :hotel_review_categories, [:hotel_id, :ref_review_category_id], unique: true, name: 'index_hotel_review_categories_uniq'

    execute 'update hotels set tz_offset = -18000 where tz_offset is null'
    execute "update hotels set main_contact_last_name = 'Unknown', main_contact_first_name = 'Unknown', main_contact_email = 'unknown@hotel.com', main_contact_phone = '5555555555' where main_contact_last_name is null"
    change_column :hotels, :name, :string, null: false
    change_column :hotels, :code, :string, null: false
    change_column :hotels, :street, :string, null: false
    change_column :hotels, :zipcode, :string, null: false
    change_column :hotels, :city, :string, null: false
    change_column :hotels, :state, :string, null: false
    change_column :hotels, :country_id, :string, null: false
    change_column :hotels, :latitude, :float, null: false
    change_column :hotels, :longitude, :float, null: false
    change_column :hotels, :hotel_chain_id, :integer, null: false
    change_column :hotels, :default_currency_id, :integer, null: false
    change_column :hotels, :hotel_phone, :string, null: false
    change_column :hotels, :tz_info, :string, null: false
    change_column :hotels, :auto_logout_delay, :integer, null: false
    change_column :hotels, :tz_offset, :integer, null: false
    change_column :hotels, :main_contact_first_name, :string, null: false
    change_column :hotels, :main_contact_last_name, :string, null: false
    change_column :hotels, :main_contact_email, :string, null: false
    change_column :hotels, :main_contact_phone, :string, null: false
    add_index :hotels, [:name, :hotel_chain_id], unique: true
    add_index :hotels, [:code, :hotel_chain_id], unique: true

    change_column :hotels_credit_card_types, :hotel_id, :integer, null: false
    change_column :hotels_credit_card_types, :ref_credit_card_type_id, :integer, null: false
    add_index :hotels_credit_card_types, [:hotel_id, :ref_credit_card_type_id], unique: true, name: 'index_hotels_credit_card_types_uniq'

    remove_column :hotels_features, :is_active

    create_table :hotels_features_temp, id: false do |t|
      t.references :hotel, null: false
      t.references :feature, null: false
    end

    execute 'INSERT INTO hotels_features_temp SELECT DISTINCT * FROM hotels_features'
    drop_table :hotels_features
    rename_table :hotels_features_temp, :hotels_features
    add_index :hotels_features, [:hotel_id, :feature_id], unique: true

    change_column :hotels_membership_types, :hotel_id, :integer, null: false
    change_column :hotels_membership_types, :membership_type_id, :integer, null: false

    change_column :hotels_payment_types, :hotel_id, :integer, null: false
    change_column :hotels_payment_types, :ref_payment_type_id, :integer, null: false
    add_index :hotels_payment_types, [:hotel_id, :ref_payment_type_id], unique: true

    remove_column :hotels_rate_types, :id
    change_column :hotels_rate_types, :hotel_id, :integer, null: false
    change_column :hotels_rate_types, :rate_type_id, :integer, null: false
    add_index :hotels_rate_types, [:hotel_id, :rate_type_id], unique: true

    create_table :hotels_users_temp, id: false do |t|
      t.references :hotel, null: false
      t.references :user, null: false
    end

    execute 'INSERT INTO hotels_users_temp SELECT DISTINCT * FROM hotels_users'
    drop_table :hotels_users
    rename_table :hotels_users_temp, :hotels_users
    add_index :hotels_users, [:hotel_id, :user_id], unique: true

    change_column :items, :hotel_id, :integer, null: false
    change_column :items, :charge_code_id, :integer, null: false
    change_column :items, :unit_price, :decimal, null: false, precision: 10, scale: 2
    change_column :items, :description, :string, null: false
    add_index :items, [:hotel_id, :description], unique: true

    change_column :late_checkout_charges, :late_checkout_setup_id, :integer, null: false
    change_column :late_checkout_charges, :extended_checkout_time, :time, null: false
    change_column :late_checkout_charges, :extended_checkout_charge, :float, null: false
    add_index :late_checkout_charges, [:late_checkout_setup_id, :extended_checkout_time], unique: true, name: 'index_late_checkout_charges_uniq'

    change_column :late_checkout_setups, :hotel_id, :integer, null: false
    add_index :late_checkout_setups, :hotel_id, unique: true

    drop_table :members

    execute 'update guest_memberships set membership_level_id = null where membership_level_id in (select id from membership_levels where membership_type_id is null)'
    execute 'delete from membership_levels where membership_type_id is null'
    change_column :membership_levels, :membership_type_id, :integer, null: false
    add_index :membership_levels, [:membership_level, :membership_type_id], unique: true, name: 'index_membership_levels_uniq'

    execute "update membership_types set membership_class_id = (select id from ref_membership_classes where value = 'HLP') where membership_class_id is null"
    change_column :membership_types, :value, :string, null: false
    change_column :membership_types, :membership_class_id, :integer, null: false

    drop_table :moderatorships

    drop_table :monitorships

    change_column :notification_details, :notification_id, :integer, null: false
    change_column :notification_details, :notification_type, :string, null: false
    change_column :notification_details, :message, :string, null: false
    change_column :notification_details, :notification_section, :string, null: false

    change_column :notification_device_details, :user_id, :integer, null: false
    change_column :notification_device_details, :unique_id, :string, null: false
    change_column :notification_device_details, :device_type, :string, null: false
    add_index :notification_device_details, :unique_id, unique: true

    drop_table :payment_types

    change_column :permissions, :name, :string, null: false

    drop_table :photos

    change_column :rate_types, :name, :string, null: false

    change_column :rates, :rate_name, :string, null: false
    change_column :rates, :rate_code, :string, null: false
    change_column :rates, :rate_desc, :string, null: true
    execute 'delete a from rates a, rates b where a.id < b.id and a.rate_name = b.rate_name and a.hotel_id = b.hotel_id'
    execute 'delete a from rates a, rates b where a.id < b.id and a.rate_code = b.rate_code and a.hotel_id = b.hotel_id'
    add_index :rates, [:hotel_id, :rate_name], unique: true
    add_index :rates, [:hotel_id, :rate_code], unique: true

    add_index :rates_addons, [:rate_id, :addon_id], unique: true

    change_column :ref_credit_card_types, :validator_code, :string, null: true

    change_column :reservation_daily_instances, :status_id, :integer, null: false

    change_column :reservation_keys, :reservation_id, :integer, null: false
    change_column :reservation_keys, :number_of_keys, :integer, null: false

    change_column :reservation_notes, :note_type_id, :integer, null: false

    change_column :reservations, :confirm_no, :string, null: false
    change_column :reservations, :arrival_date, :date, null: false
    change_column :reservations, :dep_date, :date, null: false
    change_column :reservations, :hotel_id, :integer, null: false
    change_column :reservations, :status_id, :integer, null: false

    change_column :reservations_addons, :price, :float, null: false

    add_index :reservations_features, [:reservation_id, :feature_id], unique: true

    execute 'update reservations_guest_details set is_primary = 0 where is_primary is null'
    change_column :reservations_guest_details, :reservation_id, :integer, null: false
    change_column :reservations_guest_details, :guest_detail_id, :integer, null: false
    change_column :reservations_guest_details, :is_primary, :boolean, null: false
    add_index :reservations_guest_details, [:reservation_id, :guest_detail_id], unique: true, name: 'index_reservations_guest_details_uniq'

    create_table :reservations_memberships_temp, id: false do |t|
      t.references :membership, null: false
      t.references :reservation, null: false
    end

    execute 'INSERT INTO reservations_memberships_temp SELECT DISTINCT * FROM reservations_memberships'
    drop_table :reservations_memberships
    rename_table :reservations_memberships_temp, :reservations_memberships
    add_index :reservations_memberships, [:reservation_id, :membership_id], unique: true, name: 'index_reservations_memberships_uniq'

    remove_column :review_ratings, :like
    remove_column :review_ratings, :dislike
    change_column :review_ratings, :review_category_id, :integer, null: false
    change_column :review_ratings, :rating, :integer, null: false
    change_column :review_ratings, :review_id, :integer, null: false
    add_index :review_ratings, [:review_id, :review_category_id], unique: true

    change_column :reviews, :title, :string, null: false
    change_column :reviews, :reservation_id, :integer, null: false

    change_column :roles, :name, :string, null: false

    change_column :room_types, :room_type_name, :string, null: false
    change_column :room_types, :no_of_rooms, :integer, null: false
    change_column :room_types, :description, :string, null: true
    add_index :room_types, [:hotel_id, :room_type], unique: true

    add_index :rooms, [:hotel_id, :room_no], unique: true

    add_index :rooms_features, [:room_id, :feature_id], unique: true

    remove_column :sb_posts, :topic_id
    remove_column :sb_posts, :forum_id
    change_column :sb_posts, :user_id, :integer, null: false
    change_column :sb_posts, :hotel_id, :integer, null: false
    change_column :sb_posts, :body, :text, null: false

    change_column :sessions, :user_id, :integer, null: false
    change_column :sessions, :session_id, :string, null: false

    execute "update staff_details set first_name = 'Unknown' where first_name is null"
    change_column :staff_details, :user_id, :integer, null: false
    change_column :staff_details, :last_name, :string, null: false
    change_column :staff_details, :first_name, :string, null: false
    add_index :staff_details, :user_id, unique: true

    change_column :states, :name, :string, null: false
    add_index :states, :name, unique: true

    drop_table :topics

    change_column :upsell_amounts, :level_from, :integer, null: false
    change_column :upsell_amounts, :level_to, :integer, null: false
    change_column :upsell_amounts, :amount, :float, null: false
    change_column :upsell_amounts, :hotel_id, :integer, null: false

    change_column :upsell_room_levels, :room_type_id, :integer, null: false
    change_column :upsell_room_levels, :level, :integer, null: false

    change_column :upsell_setups, :hotel_id, :integer, null: false
    add_index :upsell_setups, :hotel_id, unique: true

    change_column :url_mappings, :url, :string, null: false
    add_index :url_mappings, :url, unique: true

    change_column :user_admin_bookmarks, :user_id, :integer, null: false
    change_column :user_admin_bookmarks, :admin_menu_option_id, :integer, null: false
    add_index :user_admin_bookmarks, [:user_id, :admin_menu_option_id], unique: true

    change_column :user_admin_bookmarks, :user_id, :integer, null: false
    change_column :user_admin_bookmarks, :admin_menu_option_id, :integer, null: false

    change_column :user_notification_preferences, :user_id, :integer, null: false
    add_index :user_notification_preferences, :user_id, unique: true

    change_column :users, :login, :string, null: false
    change_column :users, :email, :string, null: false
    change_column :users, :created_at, :datetime, null: false
    change_column :users, :updated_at, :datetime, null: false

    change_column :users_notification_details, :user_id, :integer, null: false
    change_column :users_notification_details, :notification_detail_id, :integer, null: false
    add_index :users_notification_details, [:user_id, :notification_detail_id], unique: true, name: 'index_users_notification_details_uniq'

    create_table :users_roles_temp, id: false do |t|
      t.references :user, null: false, index: true
      t.references :role, null: false, index: true
    end

    execute 'INSERT INTO users_roles_temp SELECT DISTINCT * FROM users_roles'
    drop_table :users_roles
    rename_table :users_roles_temp, :users_roles
    add_index :users_roles, [:user_id, :role_id], unique: true

    change_column :wakeups, :status_id, :integer, null: false
  end
end
