# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150217070614) do

  create_table "accounts", :force => true do |t|
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "account_type_id",            :null => false
    t.string   "account_name"
    t.string   "contact_first_name"
    t.string   "contact_last_name"
    t.string   "contact_job_title"
    t.string   "contact_email"
    t.string   "account_number"
    t.string   "contact_phone"
    t.integer  "ar_number"
    t.string   "web_page"
    t.string   "billing_information"
    t.integer  "accounts_receivable_number"
    t.integer  "hotel_chain_id"
  end

  create_table "action_details", :force => true do |t|
    t.integer "action_id", :null => false
    t.string  "key",       :null => false
    t.string  "old_value"
    t.string  "new_value"
  end

  add_index "action_details", ["action_id", "key"], :name => "index_action_details_on_action_id_and_key", :unique => true

  create_table "actions", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "hotel_id",        :null => false
    t.integer  "action_type_id",  :null => false
    t.integer  "application_id",  :null => false
    t.integer  "actionable_id",   :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "actionable_type", :null => false
    t.date     "business_date",   :null => false
  end

  add_index "actions", ["actionable_id", "actionable_type"], :name => "idx_actions_actionable"
  add_index "actions", ["hotel_id", "action_type_id"], :name => "index_actions_on_hotel_id_and_action_type_id"

  create_table "additional_contacts", :force => true do |t|
    t.string   "value",                   :null => false
    t.string   "external_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "contact_type_id",         :null => false
    t.integer  "label_id",                :null => false
    t.boolean  "is_primary"
    t.integer  "associated_address_id"
    t.string   "associated_address_type"
  end

  add_index "additional_contacts", ["associated_address_id", "associated_address_type"], :name => "idx_additional_contacts_association"
  add_index "additional_contacts", ["external_id"], :name => "idx_additional_contacts_external_id"
  add_index "additional_contacts", ["value"], :name => "idx_additional_contacts_value"

  create_table "addons", :force => true do |t|
    t.string   "name",                                                                  :null => false
    t.string   "description"
    t.date     "begin_date"
    t.date     "end_date"
    t.string   "package_rythm"
    t.string   "price_calculation"
    t.decimal  "amount",              :precision => 10, :scale => 2
    t.integer  "hotel_id"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.integer  "posting_rythm_id"
    t.integer  "calculation_rule_id"
    t.boolean  "is_included_in_rate"
    t.string   "package_code"
    t.boolean  "bestseller",                                         :default => false, :null => false
    t.integer  "charge_group_id"
    t.integer  "charge_code_id"
    t.integer  "amount_type_id"
    t.integer  "post_type_id"
    t.boolean  "rate_code_only",                                     :default => false, :null => false
    t.boolean  "is_active",                                          :default => true,  :null => false
    t.boolean  "is_reservation_only",                                :default => false
  end

  create_table "addresses", :force => true do |t|
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.boolean  "is_primary"
    t.string   "external_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "country_id"
    t.integer  "label_id",                :null => false
    t.integer  "associated_address_id"
    t.string   "associated_address_type"
    t.string   "street3"
  end

  add_index "addresses", ["associated_address_id", "associated_address_type"], :name => "idx_addresses_association"

  create_table "admin_menu_option_translations", :force => true do |t|
    t.integer  "admin_menu_option_id"
    t.string   "locale",               :null => false
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "name"
  end

  add_index "admin_menu_option_translations", ["admin_menu_option_id"], :name => "index_admin_menu_option_translations_on_admin_menu_option_id"
  add_index "admin_menu_option_translations", ["locale"], :name => "index_admin_menu_option_translations_on_locale"

  create_table "admin_menu_options", :force => true do |t|
    t.boolean  "is_group",               :default => false
    t.string   "icon_class"
    t.string   "action_path",                               :null => false
    t.integer  "admin_menu_id",                             :null => false
    t.integer  "parent_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "action_state"
    t.boolean  "require_standalone_pms", :default => false
    t.boolean  "require_external_pms",   :default => false
  end

  create_table "admin_menu_translations", :force => true do |t|
    t.integer  "admin_menu_id"
    t.string   "locale",        :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "name"
    t.string   "description"
  end

  add_index "admin_menu_translations", ["admin_menu_id"], :name => "index_admin_menu_translations_on_admin_menu_id"
  add_index "admin_menu_translations", ["locale"], :name => "index_admin_menu_translations_on_locale"

  create_table "admin_menus", :force => true do |t|
    t.integer  "display_order"
    t.string   "available_for", :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "analytics_setups", :force => true do |t|
    t.string   "analytics_type", :null => false
    t.string   "product_type",   :null => false
    t.string   "tracking_id",    :null => false
    t.integer  "hotel_id"
    t.integer  "service_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "api_keys", :force => true do |t|
    t.string   "email",       :null => false
    t.string   "key",         :null => false
    t.datetime "expiry_date"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "api_keys", ["email"], :name => "index_api_keys_on_email", :unique => true

  create_table "ar_details", :force => true do |t|
    t.integer  "account_id"
    t.string   "contact_first_name"
    t.string   "ar_number"
    t.string   "contact_last_name"
    t.string   "job_title"
    t.boolean  "is_use_main_contact"
    t.boolean  "is_use_main_address"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "ar_transactions", :force => true do |t|
    t.integer  "hotel_id"
    t.integer  "bill_id"
    t.integer  "account_id"
    t.integer  "reservation_id"
    t.float    "credit"
    t.float    "debit"
    t.date     "paid_on"
    t.date     "date"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "async_callbacks", :force => true do |t|
    t.text     "request"
    t.text     "response"
    t.integer  "origin_id"
    t.string   "origin_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "beacons", :force => true do |t|
    t.string   "location"
    t.string   "uuid"
    t.boolean  "is_active",         :default => false, :null => false
    t.text     "notification_text"
    t.integer  "hotel_id",                             :null => false
    t.integer  "promotion_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "type_id",                              :null => false
    t.integer  "trigger_range_id",                     :null => false
    t.boolean  "is_linked",         :default => false
  end

  create_table "billing_groups", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "hotel_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "bills", :force => true do |t|
    t.integer  "reservation_id", :null => false
    t.integer  "account_id"
    t.integer  "bill_number",    :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "bills", ["reservation_id", "bill_number"], :name => "index_bills_on_reservation_id_and_bill_number", :unique => true

  create_table "black_listed_emails", :force => true do |t|
    t.string   "email"
    t.integer  "hotel_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "booking_origins", :force => true do |t|
    t.string   "code"
    t.string   "description"
    t.boolean  "is_active"
    t.integer  "hotel_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.string   "subject"
    t.text     "body"
    t.string   "call_to_action_label"
    t.string   "call_to_action_target"
    t.text     "alert_ios7"
    t.text     "alert_ios8"
    t.boolean  "is_recurring"
    t.date     "date_to_send"
    t.string   "time_to_send"
    t.boolean  "is_scheduled"
    t.date     "recurrence_end_date"
    t.datetime "last_sent_at"
    t.string   "status"
    t.integer  "audience_type_id"
    t.integer  "campaign_type_id"
    t.integer  "hotel_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "day_of_week"
  end

  create_table "campaigns_recepients", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "guest_detail_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "cashier_periods", :force => true do |t|
    t.datetime "starts_at",             :null => false
    t.datetime "ends_at"
    t.integer  "user_id"
    t.string   "status",                :null => false
    t.float    "checks_submitted"
    t.float    "cash_submitted"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.float    "closing_balance_cash"
    t.float    "closing_balance_check"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "cashier_periods", ["user_id", "status", "ends_at"], :name => "idx_cashier_periods_user_status_ends_at"

  create_table "charge_code_generates", :force => true do |t|
    t.integer  "charge_code_id",                             :null => false
    t.integer  "generate_charge_code_id",                    :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.boolean  "is_inclusive",            :default => false
  end

  add_index "charge_code_generates", ["charge_code_id", "generate_charge_code_id"], :name => "index_charge_code_generates_uniq", :unique => true

  create_table "charge_codes", :force => true do |t|
    t.string   "charge_code",                                            :null => false
    t.string   "description"
    t.integer  "hotel_id",                                               :null => false
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.integer  "charge_code_type_id",                                    :null => false
    t.decimal  "amount",                  :precision => 10, :scale => 2
    t.integer  "post_type_id"
    t.integer  "amount_type_id"
    t.string   "amount_symbol"
    t.integer  "associated_payment_id"
    t.string   "associated_payment_type"
    t.float    "minimum_amount_for_fees"
  end

  add_index "charge_codes", ["associated_payment_id", "associated_payment_type"], :name => "idx_charge_codes_assoc_pay"
  add_index "charge_codes", ["charge_code", "hotel_id"], :name => "index_charge_codes_on_charge_code_and_hotel_id", :unique => true

  create_table "charge_codes_billing_groups", :id => false, :force => true do |t|
    t.integer "charge_code_id",   :null => false
    t.integer "billing_group_id", :null => false
  end

  create_table "charge_groups", :force => true do |t|
    t.string   "charge_group", :null => false
    t.string   "description"
    t.integer  "hotel_id",     :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "charge_groups", ["charge_group", "hotel_id"], :name => "index_charge_groups_on_charge_group_and_hotel_id", :unique => true
  add_index "charge_groups", ["hotel_id"], :name => "index_charge_groups_on_hotel_id"

  create_table "charge_groups_codes", :id => false, :force => true do |t|
    t.integer "charge_group_id", :null => false
    t.integer "charge_code_id",  :null => false
  end

  add_index "charge_groups_codes", ["charge_group_id", "charge_code_id"], :name => "index_charge_groups_codes_on_charge_group_id_and_charge_code_id", :unique => true

  create_table "charge_routings", :force => true do |t|
    t.integer  "bill_id",                                       :null => false
    t.integer  "to_bill_id"
    t.integer  "room_id"
    t.integer  "charge_code_id"
    t.string   "external_routing_instructions", :limit => 2000
    t.string   "owner_name"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "billing_group_id"
    t.integer  "owner_id"
  end

  create_table "cms_components", :force => true do |t|
    t.string   "name"
    t.integer  "hotel_id"
    t.string   "component_type"
    t.text     "description"
    t.string   "address"
    t.string   "website_url"
    t.string   "phone"
    t.string   "page_template"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "status",             :default => true
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "valid_branch_count", :default => 0
  end

  create_table "cms_section_components", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "child_component_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "comments", :force => true do |t|
    t.string   "title"
    t.integer  "commentable_id",                     :null => false
    t.string   "commentable_type",                   :null => false
    t.integer  "user_id",                            :null => false
    t.integer  "recipient_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.text     "comment",                            :null => false
    t.string   "author_name"
    t.string   "author_email"
    t.string   "author_url"
    t.string   "author_ip"
    t.boolean  "notify_by_email",  :default => true
    t.integer  "hotel_id"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["created_at"], :name => "index_comments_on_created_at"
  add_index "comments", ["hotel_id"], :name => "index_comments_on_hotel_id"
  add_index "comments", ["recipient_id"], :name => "index_comments_on_recipient_id"
  add_index "comments", ["user_id"], :name => "fk_comments_user"

  create_table "contract_nights", :force => true do |t|
    t.date     "month_year"
    t.integer  "no_of_nights"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "rate_id",      :null => false
  end

  create_table "conversations", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.boolean  "is_group_conversation", :default => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "countries", :force => true do |t|
    t.string "name", :null => false
    t.string "code", :null => false
  end

  add_index "countries", ["code"], :name => "index_countries_on_code", :unique => true
  add_index "countries", ["name"], :name => "index_countries_on_name", :unique => true

  create_table "credit_card_transactions", :force => true do |t|
    t.integer  "payment_method_id"
    t.integer  "credit_card_transaction_type_id"
    t.float    "amount"
    t.string   "req_reference_no"
    t.string   "external_transaction_ref"
    t.string   "authorization_code"
    t.integer  "currency_code_id"
    t.integer  "workstation_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "status"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.integer  "hotel_id"
    t.text     "external_print_data"
    t.string   "external_failure_reason"
    t.string   "emv_terminal_id"
    t.boolean  "is_swiped"
    t.boolean  "is_emv_pin_verified"
    t.boolean  "is_emv_authorized"
    t.string   "external_message"
    t.boolean  "is_dcc"
    t.string   "issue_number"
    t.string   "merchant_id"
    t.integer  "sequence_number"
  end

  add_index "credit_card_transactions", ["payment_method_id"], :name => "index_credit_card_transactions_on_payment_method_id"

  create_table "default_account_routings", :force => true do |t|
    t.integer  "account_id"
    t.integer  "charge_code_id"
    t.integer  "billing_group_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "hotel_id"
  end

  create_table "departments", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "hotel_id",    :null => false
  end

  add_index "departments", ["name", "hotel_id"], :name => "index_departments_on_name_and_hotel_id", :unique => true

  create_table "early_checkin_setups", :force => true do |t|
    t.float    "charge"
    t.datetime "start_time"
    t.integer  "hotel_id"
    t.integer  "addon_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "email_template_themes", :force => true do |t|
    t.boolean  "is_system_specific", :default => false, :null => false
    t.string   "name"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "code",                                  :null => false
  end

  add_index "email_template_themes", ["name"], :name => "index_email_template_themes_on_name", :unique => true

  create_table "email_templates", :force => true do |t|
    t.string   "title",                   :null => false
    t.text     "subject",                 :null => false
    t.text     "body",                    :null => false
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.text     "signature"
    t.integer  "email_template_theme_id"
  end

  create_table "entities", :force => true do |t|
    t.string   "name",         :null => false
    t.string   "display_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "entities", ["name"], :name => "index_entities_on_name", :unique => true

  create_table "external_mappings", :force => true do |t|
    t.string   "external_value", :limit => 80,                    :null => false
    t.string   "value",          :limit => 80,                    :null => false
    t.integer  "hotel_id"
    t.string   "mapping_type",   :limit => 55,                    :null => false
    t.boolean  "is_inactive",                  :default => false
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.integer  "pms_type_id",                                     :null => false
  end

  add_index "external_mappings", ["hotel_id", "mapping_type", "external_value"], :name => "idx_ext_mapping_ext_value"
  add_index "external_mappings", ["hotel_id", "mapping_type", "value"], :name => "idx_ext_mapping_value"

  create_table "external_references", :force => true do |t|
    t.string   "value",             :limit => 45, :null => false
    t.string   "description",       :limit => 45, :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "associated_id",                   :null => false
    t.string   "associated_type",                 :null => false
    t.integer  "reference_type_id",               :null => false
  end

  create_table "feature_types", :force => true do |t|
    t.string   "value",                                      :null => false
    t.string   "selection_type",                             :null => false
    t.integer  "hotel_id"
    t.boolean  "hide_on_room_assignment"
    t.string   "description"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.boolean  "is_system_features_only", :default => false, :null => false
  end

  create_table "features", :force => true do |t|
    t.string   "value",           :null => false
    t.string   "description"
    t.integer  "hotel_id"
    t.integer  "feature_type_id", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "financial_transactions", :force => true do |t|
    t.date     "date",                                          :null => false
    t.float    "amount",                                        :null => false
    t.integer  "charge_code_id"
    t.integer  "bill_id",                                       :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "external_id"
    t.string   "reference_number"
    t.integer  "currency_code_id",                              :null => false
    t.integer  "article_id"
    t.boolean  "is_active",                  :default => true
    t.integer  "parent_transaction_id"
    t.integer  "credit_card_transaction_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.time     "time"
    t.string   "transaction_type"
    t.boolean  "is_eod_transaction",         :default => false
    t.text     "comments"
    t.integer  "original_transaction_id"
    t.integer  "cashier_period_id"
    t.string   "reference_text"
  end

  add_index "financial_transactions", ["charge_code_id", "date"], :name => "idx_financial_trans_charge_code_date"

  create_table "floors", :force => true do |t|
    t.string   "floor_number", :limit => 40,   :null => false
    t.string   "description",  :limit => 2000, :null => false
    t.integer  "hotel_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "front_office_statuses_tasks", :force => true do |t|
    t.integer "task_id"
    t.integer "front_office_status_id"
  end

  create_table "groups", :force => true do |t|
    t.string   "name",                     :null => false
    t.integer  "hotel_id",                 :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "members_count"
    t.string   "group_code"
    t.boolean  "is_early_checkin_allowed"
  end

  add_index "groups", ["group_code", "hotel_id"], :name => "index_groups_on_group_code_and_hotel_id"
  add_index "groups", ["hotel_id"], :name => "index_groups_on_hotel_id"
  add_index "groups", ["name"], :name => "index_groups_on_name"

  create_table "guest_bill_print_settings", :force => true do |t|
    t.string   "logo_type"
    t.boolean  "show_hotel_address"
    t.text     "custom_text_header"
    t.text     "custom_text_footer"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "hotel_id"
  end

  create_table "guest_details", :force => true do |t|
    t.integer  "user_id"
    t.date     "birthday"
    t.string   "gender"
    t.boolean  "is_vip"
    t.string   "title"
    t.string   "company"
    t.string   "works_at"
    t.string   "external_id"
    t.string   "passport_no"
    t.date     "passport_expiry"
    t.string   "image_url"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "first_name"
    t.string   "last_name",                                   :null => false
    t.integer  "hotel_chain_id",                              :null => false
    t.string   "job_title"
    t.string   "nationality"
    t.integer  "language_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "is_opted_promotion_email", :default => false, :null => false
  end

  add_index "guest_details", ["hotel_chain_id", "external_id"], :name => "index_guest_details_on_hotel_chain_id_and_external_id"
  add_index "guest_details", ["hotel_chain_id", "last_name", "first_name"], :name => "idx_guest_details_first_last"

  create_table "guest_features", :force => true do |t|
    t.integer "guest_detail_id", :null => false
    t.integer "feature_id",      :null => false
  end

  add_index "guest_features", ["guest_detail_id", "feature_id"], :name => "index_guest_features_on_guest_detail_id_and_feature_id", :unique => true

  create_table "guest_memberships", :force => true do |t|
    t.integer  "guest_detail_id",        :null => false
    t.string   "membership_card_number", :null => false
    t.date     "membership_expiry_date"
    t.string   "name_on_card"
    t.date     "membership_start_date"
    t.string   "external_id"
    t.integer  "membership_level_id"
    t.integer  "membership_type_id",     :null => false
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "guest_memberships", ["guest_detail_id"], :name => "index_guest_memberships_on_guest_detail_id"
  add_index "guest_memberships", ["membership_type_id", "guest_detail_id"], :name => "index_guest_memberships_uniq", :unique => true

  create_table "guest_web_tokens", :force => true do |t|
    t.integer  "guest_detail_id"
    t.string   "access_token"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "is_active",       :default => true
    t.integer  "reservation_id"
    t.string   "email_type"
  end

  create_table "hotel_brands", :force => true do |t|
    t.string   "name",                                 :null => false
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "hotel_chain_id",                       :null => false
    t.boolean  "is_inactive",       :default => false
  end

  add_index "hotel_brands", ["name"], :name => "index_hotel_brands_on_name", :unique => true

  create_table "hotel_business_dates", :force => true do |t|
    t.integer  "hotel_id",                          :null => false
    t.date     "business_date",                     :null => false
    t.string   "status",        :default => "OPEN", :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "hotel_business_dates", ["business_date", "hotel_id"], :name => "index_hotel_business_dates_on_business_date_and_hotel_id", :unique => true
  add_index "hotel_business_dates", ["status"], :name => "index_hotel_business_dates_on_status"

  create_table "hotel_chains", :force => true do |t|
    t.string   "name",                                       :null => false
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.string   "welcome_msg"
    t.string   "splash_file_name"
    t.string   "splash_content_type"
    t.integer  "splash_file_size"
    t.datetime "splash_updated_at"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.boolean  "batch_process_enabled",   :default => true,  :null => false
    t.string   "code",                                       :null => false
    t.boolean  "is_inactive",             :default => false
    t.integer  "room_status_import_freq"
    t.string   "domain_name"
    t.string   "beacon_uuid_proximity"
  end

  add_index "hotel_chains", ["code"], :name => "index_hotel_chains_on_code", :unique => true
  add_index "hotel_chains", ["name"], :name => "index_hotel_chains_on_name", :unique => true

  create_table "hotel_email_templates", :force => true do |t|
    t.integer  "hotel_id"
    t.integer  "email_template_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "hotel_message_translations", :force => true do |t|
    t.integer  "hotel_message_id"
    t.string   "locale",           :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.text     "message"
  end

  add_index "hotel_message_translations", ["hotel_message_id"], :name => "index_hotel_message_translations_on_hotel_message_id"
  add_index "hotel_message_translations", ["locale"], :name => "index_hotel_message_translations_on_locale"

  create_table "hotel_messages", :force => true do |t|
    t.integer  "hotel_id"
    t.string   "module",               :null => false
    t.integer  "hotel_message_key_id", :null => false
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "hotel_review_categories", :id => false, :force => true do |t|
    t.integer "hotel_id",               :null => false
    t.integer "ref_review_category_id", :null => false
  end

  add_index "hotel_review_categories", ["hotel_id", "ref_review_category_id"], :name => "index_hotel_review_categories_uniq", :unique => true
  add_index "hotel_review_categories", ["hotel_id"], :name => "index_hotel_review_categories_on_hotel_id"

  create_table "hotels", :force => true do |t|
    t.string   "name",                                                              :null => false
    t.integer  "staffs_count"
    t.integer  "guests_count"
    t.integer  "posts_today_count"
    t.integer  "posts_month_count"
    t.integer  "number_of_rooms"
    t.string   "code",                                                              :null => false
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.string   "zipcode",                                                           :null => false
    t.string   "hotel_phone",                                                       :null => false
    t.string   "short_name"
    t.datetime "checkout_time"
    t.integer  "arr_grace_period"
    t.integer  "dep_grace_period"
    t.integer  "groups_count"
    t.integer  "checkin_bypass",                    :limit => 1
    t.float    "latitude",                                                          :null => false
    t.float    "longitude",                                                         :null => false
    t.string   "city",                                                              :null => false
    t.string   "state",                                                             :null => false
    t.integer  "country_id",                                                        :null => false
    t.time     "checkin_time"
    t.string   "welcome_msg"
    t.string   "welcome_msg_detail"
    t.string   "sl_checkin_msg"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.integer  "hotel_chain_id",                                                    :null => false
    t.integer  "hotel_brand_id"
    t.datetime "last_reservation_update"
    t.string   "street",                                                            :null => false
    t.boolean  "is_inactive",                                    :default => false
    t.string   "last_reservation_filename"
    t.integer  "default_currency_id",                                               :null => false
    t.string   "main_contact_first_name",                                           :null => false
    t.string   "main_contact_last_name",                                            :null => false
    t.string   "main_contact_email",                                                :null => false
    t.string   "main_contact_phone",                                                :null => false
    t.string   "tz_info",                                                           :null => false
    t.integer  "pms_type_id"
    t.string   "domain_name"
    t.boolean  "is_res_import_on",                               :default => true,  :null => false
    t.integer  "key_system_id"
    t.integer  "auto_logout_delay",                                                 :null => false
    t.string   "hotel_from_address"
    t.integer  "late_checkout_charge_code_id"
    t.integer  "upsell_charge_code_id"
    t.string   "template_logo_file_name"
    t.string   "template_logo_content_type"
    t.integer  "template_logo_file_size"
    t.datetime "template_logo_updated_at"
    t.integer  "day_import_freq",                                :default => 5
    t.integer  "night_import_freq",                              :default => 5
    t.datetime "last_smartband_imported"
    t.boolean  "is_market_segments_on"
    t.integer  "language_id",                                                       :null => false
    t.string   "beacon_uuid_major"
    t.integer  "default_date_format_id"
    t.boolean  "is_eod_in_progress",                             :default => false
    t.boolean  "is_eod_manual_started",                          :default => false
    t.date     "pms_start_date"
    t.boolean  "is_external_references_import_on",               :default => false, :null => false
    t.integer  "external_references_import_freq"
    t.datetime "last_external_references_update"
    t.string   "last_external_references_filename"
    t.boolean  "is_reservation_export_on",                       :default => false, :null => false
  end

  add_index "hotels", ["code", "hotel_chain_id"], :name => "index_hotels_on_code_and_hotel_chain_id", :unique => true
  add_index "hotels", ["last_reservation_update"], :name => "index_hotels_on_last_reservation_update"
  add_index "hotels", ["name", "hotel_chain_id"], :name => "index_hotels_on_name_and_hotel_chain_id", :unique => true
  add_index "hotels", ["tz_info"], :name => "index_hotels_on_tz_info"

  create_table "hotels_credit_card_types", :force => true do |t|
    t.integer "hotel_id",                                   :null => false
    t.integer "ref_credit_card_type_id",                    :null => false
    t.boolean "is_cc",                   :default => true
    t.boolean "is_offline",              :default => false
    t.boolean "is_rover_only",           :default => false
    t.boolean "is_web_only",             :default => false
    t.boolean "active",                  :default => true
    t.boolean "is_display_reference",    :default => false
  end

  add_index "hotels_credit_card_types", ["hotel_id", "ref_credit_card_type_id"], :name => "index_hotels_credit_card_types_uniq", :unique => true

  create_table "hotels_early_checkin_groups", :force => true do |t|
    t.integer "hotel_id"
    t.integer "group_id"
  end

  create_table "hotels_early_checkin_rates", :force => true do |t|
    t.integer "hotel_id"
    t.integer "rate_id"
  end

  create_table "hotels_feature_types", :id => false, :force => true do |t|
    t.integer "hotel_id",        :null => false
    t.integer "feature_type_id", :null => false
  end

  add_index "hotels_feature_types", ["hotel_id", "feature_type_id"], :name => "index_hotels_feature_types_on_hotel_id_and_feature_type_id", :unique => true

  create_table "hotels_features", :id => false, :force => true do |t|
    t.integer "hotel_id",   :null => false
    t.integer "feature_id", :null => false
  end

  add_index "hotels_features", ["hotel_id", "feature_id"], :name => "index_hotels_features_on_hotel_id_and_feature_id", :unique => true

  create_table "hotels_membership_types", :id => false, :force => true do |t|
    t.integer "membership_type_id", :null => false
    t.integer "hotel_id",           :null => false
  end

  add_index "hotels_membership_types", ["hotel_id", "membership_type_id"], :name => "index_hotels_membership_types_on_hotel_id_and_membership_type_id", :unique => true

  create_table "hotels_payment_types", :force => true do |t|
    t.integer "hotel_id",                                :null => false
    t.integer "payment_type_id",                         :null => false
    t.boolean "is_cc",                :default => false
    t.boolean "is_offline",           :default => false
    t.boolean "is_rover_only",        :default => false
    t.boolean "is_web_only",          :default => false
    t.boolean "active",               :default => true
    t.boolean "is_display_reference", :default => false
  end

  add_index "hotels_payment_types", ["hotel_id", "payment_type_id"], :name => "index_hotels_payment_types_on_hotel_id_and_ref_payment_type_id", :unique => true
  add_index "hotels_payment_types", ["hotel_id"], :name => "index_hotels_payment_types_on_hotel_id"

  create_table "hotels_rate_types", :id => false, :force => true do |t|
    t.integer "hotel_id",     :null => false
    t.integer "rate_type_id", :null => false
  end

  add_index "hotels_rate_types", ["hotel_id", "rate_type_id"], :name => "index_hotels_rate_types_on_hotel_id_and_rate_type_id", :unique => true

  create_table "hotels_reservation_types", :force => true do |t|
    t.integer "hotel_id",                :null => false
    t.integer "ref_reservation_type_id", :null => false
  end

  create_table "hotels_restriction_types", :force => true do |t|
    t.integer "hotel_id"
    t.integer "restriction_type_id"
  end

  create_table "hotels_roles", :force => true do |t|
    t.integer "hotel_id",                                :null => false
    t.integer "role_id",                                 :null => false
    t.integer "default_dashboard_id",                    :null => false
    t.boolean "is_active",            :default => false, :null => false
  end

  create_table "hotels_users", :id => false, :force => true do |t|
    t.integer "hotel_id", :null => false
    t.integer "user_id",  :null => false
  end

  add_index "hotels_users", ["hotel_id", "user_id"], :name => "index_hotels_users_on_hotel_id_and_user_id", :unique => true

  create_table "hourly_inventory_details", :force => true do |t|
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "hour"
    t.integer  "sold"
    t.integer  "inventory_detail_id"
    t.integer  "hotel_id"
    t.integer  "rate_id"
    t.integer  "room_type_id"
    t.date     "date"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "hourly_room_rates", :force => true do |t|
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "hour"
    t.float    "amount"
    t.integer  "room_rate_id"
  end

  create_table "images", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_file_size"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "image_attachable_id"
    t.string   "image_attachable_type"
  end

  create_table "inactive_rooms", :force => true do |t|
    t.integer  "room_id"
    t.integer  "ref_service_status_id"
    t.integer  "maintenance_reason_id"
    t.text     "comments"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "inactive_rooms", ["room_id"], :name => "index_inactive_rooms_on_room_id"

  create_table "inventory_details", :force => true do |t|
    t.integer  "hotel_id",     :null => false
    t.date     "date",         :null => false
    t.integer  "rate_id",      :null => false
    t.integer  "room_type_id", :null => false
    t.integer  "sold",         :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "inventory_details", ["hotel_id", "rate_id", "room_type_id", "date"], :name => "index_inventory_details_uniq", :unique => true

  create_table "items", :force => true do |t|
    t.integer  "hotel_id",                                                         :null => false
    t.integer  "charge_code_id",                                                   :null => false
    t.decimal  "unit_price",     :precision => 10, :scale => 2,                    :null => false
    t.string   "description",                                                      :null => false
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.boolean  "is_favorite",                                   :default => false
  end

  add_index "items", ["hotel_id", "description"], :name => "index_items_on_hotel_id_and_description", :unique => true

  create_table "key_encoders", :force => true do |t|
    t.integer  "hotel_id",                      :null => false
    t.string   "description",                   :null => false
    t.string   "location"
    t.string   "encoder_id",                    :null => false
    t.boolean  "enabled",     :default => true, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "late_checkout_charges", :force => true do |t|
    t.time     "extended_checkout_time",   :null => false
    t.float    "extended_checkout_charge", :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "hotel_id",                 :null => false
  end

  add_index "late_checkout_charges", ["hotel_id", "extended_checkout_time"], :name => "index_late_checkout_charges_uniq", :unique => true

  create_table "maintenance_reasons", :force => true do |t|
    t.integer  "hotel_id"
    t.string   "maintenance_reason"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "market_segments", :force => true do |t|
    t.string   "name"
    t.integer  "hotel_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "is_active"
  end

  create_table "membership_levels", :force => true do |t|
    t.string  "membership_level",   :limit => 40, :null => false
    t.boolean "is_inactive"
    t.string  "description",        :limit => 80
    t.integer "membership_type_id",               :null => false
  end

  add_index "membership_levels", ["membership_level", "membership_type_id"], :name => "index_membership_levels_uniq", :unique => true

  create_table "membership_types", :force => true do |t|
    t.string   "value",               :null => false
    t.integer  "membership_class_id", :null => false
    t.integer  "property_id"
    t.string   "property_type"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "description",         :null => false
  end

  add_index "membership_types", ["property_id", "property_type", "value"], :name => "idx_membership_types_prop_value"

  create_table "messages", :force => true do |t|
    t.string   "message"
    t.integer  "conversation_id"
    t.integer  "sender_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "messages_recipients", :force => true do |t|
    t.integer "message_id"
    t.integer "recipient_id"
    t.boolean "is_read",      :default => false
    t.boolean "is_pushed"
  end

  create_table "neighbourhoods", :id => false, :force => true do |t|
    t.integer "beacon_id",    :null => false
    t.integer "neighbour_id", :null => false
  end

  create_table "notes", :force => true do |t|
    t.integer  "associated_id",                           :null => false
    t.string   "description",             :limit => 2000, :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "note_type_id",                            :null => false
    t.string   "external_id"
    t.boolean  "is_guest_viewable"
    t.boolean  "is_from_external_system"
    t.string   "associated_type"
  end

  add_index "notes", ["associated_id"], :name => "index_reservation_notes_on_reservation_id"

  create_table "notification_details", :force => true do |t|
    t.integer  "notification_id",      :null => false
    t.string   "notification_type",    :null => false
    t.string   "message",              :null => false
    t.string   "additional_data"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "notification_section", :null => false
  end

  create_table "notification_device_details", :force => true do |t|
    t.integer  "user_id",         :null => false
    t.string   "unique_id",       :null => false
    t.string   "registration_id"
    t.string   "device_type",     :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "notification_device_details", ["unique_id"], :name => "index_notification_device_details_on_unique_id", :unique => true

  create_table "occupancy_targets", :force => true do |t|
    t.integer  "hotel_id",   :null => false
    t.date     "date",       :null => false
    t.integer  "target",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "payment_methods", :force => true do |t|
    t.string   "mli_token"
    t.string   "card_expiry"
    t.string   "card_cvv",            :limit => 20
    t.string   "card_name"
    t.string   "bank_routing_no",     :limit => 80
    t.string   "account_no",          :limit => 80
    t.boolean  "is_primary"
    t.string   "external_id",         :limit => 80
    t.integer  "payment_type_id",                   :null => false
    t.integer  "credit_card_type_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "mli_transaction_id"
    t.boolean  "is_swiped"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "bill_number"
  end

  add_index "payment_methods", ["associated_id", "associated_type"], :name => "index_payment_methods_on_associated_id_and_associated_type"
  add_index "payment_methods", ["mli_token"], :name => "index_guest_payment_types_on_mli_token"

  create_table "payment_types", :force => true do |t|
    t.string   "value",                           :null => false
    t.string   "description"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "is_selectable", :default => true, :null => false
    t.integer  "hotel_id"
  end

  add_index "payment_types", ["hotel_id", "value"], :name => "index_payment_types_on_hotel_id_and_value"

  create_table "permissions", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "policies", :force => true do |t|
    t.string   "name",                                     :null => false
    t.string   "description"
    t.float    "amount",                                   :null => false
    t.string   "amount_type",                              :null => false
    t.integer  "post_type_id"
    t.boolean  "apply_to_all_bookings", :default => false
    t.integer  "advance_days"
    t.time     "advance_time"
    t.integer  "policy_type_id",                           :null => false
    t.integer  "hotel_id",                                 :null => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.integer  "charge_code_id"
    t.boolean  "allow_deposit_edit"
  end

  create_table "pre_checkin_excluded_block_codes", :force => true do |t|
    t.integer  "hotel_id",   :null => false
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pre_checkin_excluded_rate_codes", :force => true do |t|
    t.integer  "hotel_id",   :null => false
    t.integer  "rate_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pre_reservations", :force => true do |t|
    t.integer  "room_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "from_time",  :null => false
    t.datetime "to_time",    :null => false
    t.integer  "rate_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "printer_templates", :force => true do |t|
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.text     "template",      :null => false
    t.integer  "hotel_id",      :null => false
    t.string   "template_type", :null => false
  end

  create_table "promotions", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "is_active"
    t.integer  "hotel_id",    :null => false
    t.integer  "image_id"
  end

  create_table "rate_date_ranges", :force => true do |t|
    t.integer  "rate_id"
    t.date     "begin_date", :null => false
    t.date     "end_date",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "rate_date_ranges", ["rate_id", "begin_date", "end_date"], :name => "index_rate_date_ranges"

  create_table "rate_restrictions", :force => true do |t|
    t.integer  "hotel_id",   :null => false
    t.integer  "rate_id",    :null => false
    t.integer  "type_id",    :null => false
    t.integer  "days"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "rate_sets", :force => true do |t|
    t.integer  "rate_date_range_id",                             :null => false
    t.string   "name",                                           :null => false
    t.boolean  "sunday",                      :default => false, :null => false
    t.boolean  "monday",                      :default => false, :null => false
    t.boolean  "tuesday",                     :default => false, :null => false
    t.boolean  "wednesday",                   :default => false, :null => false
    t.boolean  "thursday",                    :default => false, :null => false
    t.boolean  "friday",                      :default => false, :null => false
    t.boolean  "saturday",                    :default => false, :null => false
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.integer  "day_min_hours"
    t.integer  "day_max_hours"
    t.datetime "day_checkout_cut_off_time"
    t.datetime "night_start_time"
    t.datetime "night_end_time"
    t.datetime "night_checkout_cut_off_time"
  end

  add_index "rate_sets", ["rate_date_range_id", "name"], :name => "index_rate_sets_uniq", :unique => true

  create_table "rate_types", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "hotel_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rates", :force => true do |t|
    t.integer  "hotel_id",                                                                                    :null => false
    t.string   "rate_desc"
    t.date     "begin_date"
    t.date     "end_date"
    t.date     "sell_begin_date"
    t.date     "sell_end_date"
    t.integer  "parent_rate_id"
    t.string   "market_code",                 :limit => 20
    t.integer  "external_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",                                                                                  :null => false
    t.datetime "updated_at",                                                                                  :null => false
    t.string   "rate_name",                                                                                   :null => false
    t.integer  "currency_code_id"
    t.integer  "rate_type_id"
    t.string   "rate_code"
    t.integer  "based_on_rate_id"
    t.string   "based_on_type"
    t.decimal  "based_on_value",                            :precision => 10, :scale => 2
    t.boolean  "is_active",                                                                :default => true,  :null => false
    t.string   "promotion_code"
    t.integer  "charge_code_id"
    t.integer  "market_segment_id"
    t.integer  "source_id"
    t.boolean  "is_commission_on",                                                         :default => false
    t.boolean  "is_suppress_rate_on",                                                      :default => false
    t.boolean  "is_discount_allowed_on",                                                   :default => false
    t.integer  "deposit_policy_id"
    t.integer  "cancellation_policy_id"
    t.boolean  "use_rate_levels",                                                          :default => false
    t.integer  "account_id"
    t.boolean  "is_fixed_rate",                                                            :default => false, :null => false
    t.boolean  "is_rate_shown_on_guest_bill",                                              :default => false, :null => false
    t.boolean  "is_hourly_rate",                                                           :default => false
    t.boolean  "is_early_checkin_allowed"
  end

  create_table "rates_addons", :force => true do |t|
    t.integer "rate_id",                                :null => false
    t.integer "addon_id",                               :null => false
    t.boolean "is_inclusive_in_rate", :default => true, :null => false
  end

  add_index "rates_addons", ["rate_id", "addon_id"], :name => "index_rates_addons_on_rate_id_and_addon_id", :unique => true

  create_table "rates_room_types", :force => true do |t|
    t.integer "rate_id",      :null => false
    t.integer "room_type_id", :null => false
  end

  create_table "ref_account_types", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_action_types", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_activity_types", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ref_addons", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_amount_types", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_analytics_services", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "ref_applications", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_beacon_ranges", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_beacon_types", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_calculation_rules", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_campaign_audience_types", :force => true do |t|
    t.string   "value"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_campaign_types", :force => true do |t|
    t.string   "value"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_cancel_codes", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_charge_code_types", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_contact_labels", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_contact_types", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_credit_card_transaction_types", :force => true do |t|
    t.string   "value"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_credit_card_types", :force => true do |t|
    t.string   "value",          :null => false
    t.string   "description"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "validator_code"
  end

  create_table "ref_currency_codes", :force => true do |t|
    t.string "value",       :null => false
    t.string "description"
    t.string "symbol",      :null => false
  end

  create_table "ref_dashboards", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_date_formats", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_discount_types", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_external_reference_types", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_front_office_statuses", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_hotel_message_keys", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_housekeeping_statuses", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_key_card_types", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_key_systems", :force => true do |t|
    t.string   "value",                               :null => false
    t.string   "description"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "key_card_type_id"
    t.boolean  "retrieve_uid",     :default => false, :null => false
    t.string   "aid"
    t.string   "keyb"
    t.boolean  "encoder_enabled",  :default => false, :null => false
  end

  create_table "ref_languages", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_membership_classes", :force => true do |t|
    t.string   "value",          :null => false
    t.string   "description"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.boolean  "is_system_only"
  end

  create_table "ref_note_types", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_pms_types", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_policy_types", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_post_types", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_posting_rythms", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_report_filters", :force => true do |t|
    t.string   "value"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_report_sortable_fields", :force => true do |t|
    t.string   "value"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_reservation_hk_statuses", :force => true do |t|
    t.string   "value"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_reservation_status_translations", :force => true do |t|
    t.integer  "reservation_status_id"
    t.string   "locale",                :null => false
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "description"
  end

  add_index "ref_reservation_status_translations", ["locale"], :name => "index_ref_reservation_status_translations_on_locale"
  add_index "ref_reservation_status_translations", ["reservation_status_id"], :name => "index_3222b6be4ddd4ff11bb49e79e7db8d7b9e2a9f88"

  create_table "ref_reservation_statuses", :force => true do |t|
    t.string   "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ref_reservation_types", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_restriction_types", :force => true do |t|
    t.string   "value",                          :null => false
    t.string   "description"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "editable",    :default => false, :null => false
  end

  create_table "ref_review_categories", :force => true do |t|
    t.string   "value"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "description"
  end

  create_table "ref_service_statuses", :force => true do |t|
    t.string   "value"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_titles", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_wakeup_statuses", :force => true do |t|
    t.string   "value",       :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ref_work_statuses", :force => true do |t|
    t.string   "value"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "report_filters", :force => true do |t|
    t.integer "report_id"
    t.integer "filter_id"
  end

  create_table "report_sortable_fields", :force => true do |t|
    t.integer "report_id"
    t.integer "sortable_field_id"
  end

  create_table "reports", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "method"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "sub_title"
  end

  create_table "reservation_daily_instances", :force => true do |t|
    t.integer  "reservation_id",                                                     :null => false
    t.date     "reservation_date",                                                   :null => false
    t.integer  "room_type_id",                                                       :null => false
    t.integer  "original_room_type_id"
    t.decimal  "rate_amount",                         :precision => 10, :scale => 2
    t.integer  "rate_id"
    t.decimal  "original_rate_amount",                :precision => 10, :scale => 2
    t.string   "market_segment",        :limit => 20
    t.integer  "adults",                                                             :null => false
    t.integer  "children"
    t.integer  "children1"
    t.integer  "children2"
    t.integer  "children3"
    t.integer  "children4"
    t.integer  "children5"
    t.integer  "children6"
    t.integer  "cribs"
    t.integer  "extra_beds"
    t.string   "turndown_status",       :limit => 10
    t.boolean  "is_due_out"
    t.integer  "block_id"
    t.integer  "group_id"
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
    t.integer  "room_id"
    t.integer  "currency_code_id"
    t.integer  "status_id",                                                          :null => false
    t.integer  "infants"
  end

  add_index "reservation_daily_instances", ["reservation_id", "reservation_date"], :name => "index_res_daily_instances_on_res_id_and_res_date", :unique => true
  add_index "reservation_daily_instances", ["room_id"], :name => "index_reservation_daily_instances_on_room_id"

  create_table "reservation_keys", :force => true do |t|
    t.integer  "number_of_keys",                    :null => false
    t.string   "room_number"
    t.integer  "reservation_id",                    :null => false
    t.binary   "qr_data"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "uid"
    t.boolean  "is_inactive",    :default => false
  end

  create_table "reservation_signatures", :force => true do |t|
    t.integer  "reservation_id",                     :null => false
    t.binary   "data",           :limit => 16777215, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reservations", :force => true do |t|
    t.string   "confirm_no",                                                                                :null => false
    t.date     "arrival_date",                                                                              :null => false
    t.date     "dep_date",                                                                                  :null => false
    t.integer  "hotel_id",                                                                                  :null => false
    t.datetime "created_at",                                                                                :null => false
    t.datetime "updated_at",                                                                                :null => false
    t.decimal  "upsell_amount",                           :precision => 10, :scale => 2
    t.datetime "arrival_time"
    t.string   "cancellation_no"
    t.date     "cancel_date"
    t.string   "cancel_reason"
    t.string   "company_id"
    t.boolean  "no_room_move",                                                           :default => false, :null => false
    t.boolean  "fixed_rate"
    t.decimal  "total_amount",                            :precision => 10, :scale => 2
    t.string   "guarantee_type"
    t.string   "last_stay_room"
    t.string   "market_segment"
    t.string   "total_rooms"
    t.string   "party_code"
    t.string   "preferred_room_type"
    t.boolean  "print_rate"
    t.string   "source_code"
    t.string   "travel_agent_id"
    t.boolean  "is_walkin"
    t.string   "external_id"
    t.boolean  "lobby_status",                                                           :default => false
    t.date     "original_arrival_date"
    t.date     "original_departure_date"
    t.time     "checkin_time"
    t.time     "checkout_time"
    t.string   "waitlist_reason",         :limit => 2000
    t.decimal  "discount_amount",                         :precision => 10, :scale => 2
    t.string   "discount_reason",         :limit => 2000
    t.boolean  "is_posting_restricted"
    t.boolean  "is_remote_co_allowed"
    t.boolean  "is_day_use"
    t.boolean  "is_upsell_applied",                                                      :default => false
    t.boolean  "is_first_time_checkin",                                                  :default => true
    t.integer  "status_id",                                                                                 :null => false
    t.integer  "discount_type_id"
    t.boolean  "is_opted_late_checkout",                                                 :default => false
    t.time     "late_checkout_time"
    t.boolean  "is_rate_suppressed"
    t.string   "promotion_code"
    t.date     "last_upsell_posted_date"
    t.datetime "departure_time"
    t.boolean  "is_queued",                                                              :default => false
    t.datetime "last_imported"
    t.boolean  "no_post"
    t.integer  "reservation_type_id"
    t.integer  "source_id"
    t.integer  "market_segment_id"
    t.integer  "booking_origin_id"
    t.boolean  "is_advance_bill",                                                        :default => false
    t.text     "comments"
    t.boolean  "is_pre_checkin",                                                         :default => false
    t.boolean  "is_hourly",                                                              :default => false
    t.datetime "put_in_queue_updated_at"
    t.integer  "creator_id"
    t.integer  "updator_id"
  end

  add_index "reservations", ["confirm_no"], :name => "index_reservations_on_confirm_no"
  add_index "reservations", ["hotel_id", "confirm_no"], :name => "index_reservations_on_hotel_id_and_confirm_no", :unique => true
  add_index "reservations", ["hotel_id", "status_id", "arrival_date"], :name => "index_reservations_on_hotel_id_and_status_id_and_arrival_date"
  add_index "reservations", ["hotel_id", "status_id", "dep_date"], :name => "index_reservations_on_hotel_id_and_status_id_and_dep_date"

  create_table "reservations_addons", :force => true do |t|
    t.integer "reservation_id",                      :null => false
    t.integer "addon_id",                            :null => false
    t.float   "price"
    t.boolean "is_inclusive_in_rate"
    t.integer "quantity",             :default => 1, :null => false
  end

  create_table "reservations_features", :id => false, :force => true do |t|
    t.integer "reservation_id", :null => false
    t.integer "feature_id",     :null => false
  end

  add_index "reservations_features", ["feature_id"], :name => "index_reservations_preferences_on_preference_id"
  add_index "reservations_features", ["reservation_id", "feature_id"], :name => "index_reservations_features_on_reservation_id_and_feature_id", :unique => true
  add_index "reservations_features", ["reservation_id"], :name => "index_reservations_preferences_on_reservation_id"

  create_table "reservations_guest_details", :force => true do |t|
    t.boolean "is_primary",            :default => false, :null => false
    t.integer "reservation_id",                           :null => false
    t.integer "guest_detail_id",                          :null => false
    t.boolean "is_accompanying_guest", :default => false
    t.boolean "is_added_from_kiosk",   :default => false
  end

  add_index "reservations_guest_details", ["reservation_id", "guest_detail_id"], :name => "index_reservations_guest_details_uniq", :unique => true

  create_table "reservations_memberships", :id => false, :force => true do |t|
    t.integer "membership_id",  :null => false
    t.integer "reservation_id", :null => false
  end

  add_index "reservations_memberships", ["reservation_id", "membership_id"], :name => "index_reservations_memberships_uniq", :unique => true

  create_table "review_ratings", :force => true do |t|
    t.integer  "review_category_id", :null => false
    t.integer  "rating",             :null => false
    t.boolean  "published"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "review_id",          :null => false
  end

  add_index "review_ratings", ["review_id", "review_category_id"], :name => "index_review_ratings_on_review_id_and_review_category_id", :unique => true

  create_table "reviews", :force => true do |t|
    t.integer  "reservation_id",                :null => false
    t.string   "title",                         :null => false
    t.string   "description",    :limit => 500
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "roles", :force => true do |t|
    t.string  "name",     :null => false
    t.integer "hotel_id"
  end

  add_index "roles", ["hotel_id", "name"], :name => "index_roles_on_hotel_id_and_name"

  create_table "roles_permissions", :force => true do |t|
    t.integer  "entity_id"
    t.integer  "role_id"
    t.integer  "permission_id"
    t.boolean  "value"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "hotel_id"
  end

  add_index "roles_permissions", ["entity_id"], :name => "index_roles_permissions_on_entity_id"
  add_index "roles_permissions", ["permission_id"], :name => "index_roles_permissions_on_permission_id"
  add_index "roles_permissions", ["role_id"], :name => "index_roles_permissions_on_role_id"

  create_table "room_custom_rates", :force => true do |t|
    t.integer  "room_rate_id",       :null => false
    t.date     "date",               :null => false
    t.float    "single_amount"
    t.float    "double_amount"
    t.float    "extra_adult_amount"
    t.float    "child_amount"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "room_custom_rates", ["room_rate_id", "date"], :name => "index_room_custom_rates_on_room_rate_id_and_date"

  create_table "room_rate_restrictions", :force => true do |t|
    t.integer  "hotel_id",     :null => false
    t.integer  "type_id",      :null => false
    t.date     "date",         :null => false
    t.integer  "rate_id",      :null => false
    t.integer  "room_type_id", :null => false
    t.integer  "days"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "room_rate_restrictions", ["rate_id", "date"], :name => "index_room_rate_restrictions_on_rate_id_and_date"
  add_index "room_rate_restrictions", ["type_id", "rate_id", "room_type_id", "date"], :name => "index_restrictions_uniq", :unique => true

  create_table "room_rates", :force => true do |t|
    t.integer  "room_type_id",             :null => false
    t.integer  "rate_set_id",              :null => false
    t.float    "single_amount"
    t.float    "double_amount"
    t.float    "extra_adult_amount"
    t.float    "child_amount"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.float    "nightly_rate"
    t.float    "day_hourly_incr_amount"
    t.float    "night_hourly_incr_amount"
  end

  add_index "room_rates", ["rate_set_id", "room_type_id"], :name => "index_room_rates_uniq", :unique => true

  create_table "room_type_tasks", :force => true do |t|
    t.integer  "task_id"
    t.integer  "room_type_id"
    t.datetime "completion_time"
  end

  add_index "room_type_tasks", ["task_id", "room_type_id"], :name => "index_room_type_tasks_on_task_id_and_room_type_id", :unique => true

  create_table "room_types", :force => true do |t|
    t.integer  "hotel_id",                                            :null => false
    t.string   "room_type",          :limit => 20,                    :null => false
    t.text     "description"
    t.integer  "no_of_rooms",                                         :null => false
    t.integer  "max_adults"
    t.integer  "max_children"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "room_type_name",                                      :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "is_pseudo",                        :default => false, :null => false
    t.integer  "max_occupancy"
    t.integer  "max_late_checkouts"
    t.boolean  "is_suite",                         :default => false, :null => false
  end

  add_index "room_types", ["hotel_id", "room_type"], :name => "index_room_types_on_hotel_id_and_room_type", :unique => true

  create_table "rooms", :force => true do |t|
    t.integer  "hotel_id",                                            :null => false
    t.string   "room_no",            :limit => 20,                    :null => false
    t.integer  "room_type_id",                                        :null => false
    t.boolean  "is_occupied",                      :default => false, :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.integer  "hk_status_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "floor_id"
    t.integer  "max_occupancy"
  end

  add_index "rooms", ["hotel_id", "room_no"], :name => "idx_rooms_room_no_uk", :unique => true
  add_index "rooms", ["hotel_id", "room_no"], :name => "index_rooms_on_hotel_id_and_room_no", :unique => true
  add_index "rooms", ["room_type_id"], :name => "index_rooms_on_room_type_id"

  create_table "rooms_features", :id => false, :force => true do |t|
    t.integer "room_id",    :null => false
    t.integer "feature_id", :null => false
  end

  add_index "rooms_features", ["room_id", "feature_id"], :name => "idx_room_features_rooms_id_uk", :unique => true
  add_index "rooms_features", ["room_id", "feature_id"], :name => "index_rooms_features_on_room_id_and_feature_id", :unique => true

  create_table "sb_posts", :force => true do |t|
    t.integer  "user_id",                      :null => false
    t.text     "body",                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "body_html"
    t.string   "author_name"
    t.string   "author_email"
    t.string   "author_url"
    t.string   "author_ip"
    t.integer  "comment_count", :default => 0
    t.integer  "hotel_id",                     :null => false
    t.integer  "group_id"
    t.integer  "ad_id"
  end

  add_index "sb_posts", ["ad_id"], :name => "index_sb_posts_on_ad_id"
  add_index "sb_posts", ["created_at"], :name => "index_sb_posts_on_forum_id"
  add_index "sb_posts", ["user_id", "created_at"], :name => "index_sb_posts_on_user_id"

  create_table "sell_limits", :force => true do |t|
    t.integer  "hotel_id",     :null => false
    t.date     "from_date",    :null => false
    t.date     "to_date",      :null => false
    t.integer  "rate_id"
    t.integer  "room_type_id"
    t.integer  "to_sell",      :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "sell_limits", ["hotel_id", "from_date", "to_date", "rate_id", "room_type_id"], :name => "index_sell_limits"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "user_id",    :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_sessid"

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "shifts", :force => true do |t|
    t.string  "name"
    t.time    "time"
    t.integer "hotel_id"
    t.boolean "is_system", :default => false
  end

  create_table "smartbands", :force => true do |t|
    t.integer  "reservation_id",                    :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "account_number",                    :null => false
    t.boolean  "is_fixed",       :default => false, :null => false
    t.float    "amount"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  create_table "sources", :force => true do |t|
    t.string   "code"
    t.string   "description"
    t.integer  "hotel_id"
    t.boolean  "is_active"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "staff_alert_emails", :force => true do |t|
    t.integer  "hotel_id",   :null => false
    t.string   "email",      :null => false
    t.string   "email_type", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "staff_details", :force => true do |t|
    t.integer  "user_id",             :null => false
    t.string   "first_name",          :null => false
    t.string   "last_name",           :null => false
    t.string   "job_title"
    t.string   "title"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "staff_details", ["user_id"], :name => "index_staff_details_on_user_id", :unique => true

  create_table "states", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "states", ["name"], :name => "index_states_on_name", :unique => true

  create_table "task_reservation_statuses", :force => true do |t|
    t.integer "task_id"
    t.integer "ref_reservation_hk_status_id"
  end

  add_index "task_reservation_statuses", ["task_id", "ref_reservation_hk_status_id"], :name => "idx_task_res_status_uniq", :unique => true

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.integer  "work_type_id"
    t.integer  "room_type_id"
    t.integer  "ref_housekeeping_status_id"
    t.boolean  "is_occupied"
    t.boolean  "is_vacant"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.datetime "completion_time"
    t.boolean  "is_system",                  :default => false
  end

  add_index "tasks", ["work_type_id"], :name => "index_tasks_on_work_type_id"

  create_table "tax_calculation_rules", :force => true do |t|
    t.integer "charge_code_generate_id"
    t.integer "linked_charge_code_generate_id"
  end

  create_table "upsell_amounts", :force => true do |t|
    t.integer "level_from", :null => false
    t.integer "level_to",   :null => false
    t.float   "amount",     :null => false
    t.integer "hotel_id",   :null => false
  end

  create_table "upsell_room_levels", :force => true do |t|
    t.integer  "room_type_id", :null => false
    t.integer  "level",        :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "url_mappings", :force => true do |t|
    t.string   "url",            :null => false
    t.integer  "hotel_chain_id"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "url_mappings", ["url"], :name => "index_url_mappings_on_url", :unique => true

  create_table "user_activities", :force => true do |t|
    t.integer  "hotel_id",                 :null => false
    t.integer  "associated_activity_id",   :null => false
    t.integer  "application_id"
    t.integer  "action_type_id"
    t.string   "activity_status",          :null => false
    t.string   "message"
    t.string   "user_ip_address",          :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.datetime "activity_date_time"
    t.string   "associated_activity_type"
  end

  add_index "user_activities", ["associated_activity_id", "associated_activity_type"], :name => "index_user_activities_on_associated_activity"
  add_index "user_activities", ["hotel_id", "application_id"], :name => "index_user_activities_on_hotel_id_and_application_id"
  add_index "user_activities", ["hotel_id", "associated_activity_id"], :name => "index_user_activities_on_hotel_id_and_associated_activity_id"

  create_table "user_admin_bookmarks", :force => true do |t|
    t.integer  "user_id",              :null => false
    t.integer  "admin_menu_option_id", :null => false
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "user_admin_bookmarks", ["user_id", "admin_menu_option_id"], :name => "index_user_admin_bookmarks_on_user_id_and_admin_menu_option_id", :unique => true

  create_table "user_notification_preferences", :force => true do |t|
    t.integer "user_id",                               :null => false
    t.boolean "new_post",            :default => true
    t.boolean "response_to_post",    :default => true
    t.boolean "response_to_review",  :default => true
    t.boolean "alert_text_to_staff", :default => true
    t.boolean "is_alert_promotions"
  end

  add_index "user_notification_preferences", ["user_id"], :name => "index_user_notification_preferences_on_user_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login",                                                    :null => false
    t.string   "email",                                                    :null => false
    t.text     "description"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.string   "persistence_token"
    t.text     "stylesheet"
    t.integer  "view_count",                            :default => 0
    t.boolean  "vendor",                                :default => false
    t.string   "activation_code",         :limit => 40
    t.datetime "activated_at"
    t.string   "login_slug"
    t.boolean  "profile_public",                        :default => true
    t.integer  "activities_count",                      :default => 0
    t.integer  "sb_posts_count",                        :default => 0
    t.datetime "sb_last_seen_at"
    t.integer  "role_id"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",                           :default => 0
    t.integer  "failed_login_count",                    :default => 0
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "default_hotel_id"
    t.integer  "interest_match_count"
    t.integer  "hotel_chain_id"
    t.integer  "department_id"
    t.datetime "last_login_at"
    t.string   "phone"
    t.text     "old_passwords"
    t.boolean  "is_housekeeping_only",                  :default => false
    t.integer  "default_dashboard_id"
    t.datetime "last_password_update_at"
    t.boolean  "is_email_verified",                     :default => false
  end

  add_index "users", ["activated_at"], :name => "index_users_on_activated_at"
  add_index "users", ["created_at"], :name => "index_users_on_created_at"
  add_index "users", ["hotel_chain_id"], :name => "index_users_on_hotel_chain_id"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["login_slug"], :name => "index_users_on_login_slug"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["vendor"], :name => "index_users_on_vendor"

  create_table "users_notification_details", :force => true do |t|
    t.integer  "user_id",                :null => false
    t.integer  "notification_detail_id", :null => false
    t.boolean  "is_read"
    t.boolean  "is_pushed"
    t.boolean  "should_notify"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.datetime "alert_time"
    t.string   "notification_channel"
  end

  add_index "users_notification_details", ["user_id", "notification_detail_id"], :name => "index_users_notification_details_uniq", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id", :null => false
    t.integer "role_id", :null => false
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id", :unique => true

  create_table "wakeups", :force => true do |t|
    t.integer  "reservation_id", :null => false
    t.integer  "hotel_id",       :null => false
    t.string   "room_no"
    t.date     "start_date",     :null => false
    t.date     "end_date",       :null => false
    t.time     "time",           :null => false
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "status_id",      :null => false
  end

  add_index "wakeups", ["reservation_id"], :name => "index_wakeups_on_reservation_id"

  create_table "web_checkin_staff_alert_emails", :force => true do |t|
    t.integer  "hotel_id",   :null => false
    t.string   "email",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "web_checkout_staff_alert_emails", :force => true do |t|
    t.integer  "hotel_id",   :null => false
    t.string   "email",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "email_type"
  end

  create_table "work_assignments", :force => true do |t|
    t.integer  "work_sheet_id"
    t.integer  "task_id"
    t.integer  "room_id"
    t.integer  "work_status_id"
    t.integer  "order"
    t.datetime "begin_time"
    t.datetime "end_time"
  end

  add_index "work_assignments", ["room_id"], :name => "index_work_assignments_on_room_id"
  add_index "work_assignments", ["work_sheet_id"], :name => "index_work_assignments_on_work_sheet_id"

  create_table "work_logs", :force => true do |t|
    t.integer  "room_id"
    t.datetime "begin_time"
    t.datetime "end_time"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "work_sheets", :force => true do |t|
    t.integer "user_id"
    t.integer "work_type_id"
    t.integer "shift_id"
    t.date    "date"
    t.integer "sheet_number"
  end

  add_index "work_sheets", ["user_id"], :name => "index_work_sheets_on_user_id"
  add_index "work_sheets", ["work_type_id", "date"], :name => "index_work_sheets_on_work_type_id_and_date"

  create_table "work_types", :force => true do |t|
    t.string   "name"
    t.integer  "hotel_id"
    t.boolean  "is_active",  :default => true
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "is_system",  :default => false
  end

  create_table "workstations", :force => true do |t|
    t.string   "name"
    t.integer  "hotel_id"
    t.string   "station_identifier"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "workstations", ["hotel_id"], :name => "index_work_stations_on_hotel_id"

end
