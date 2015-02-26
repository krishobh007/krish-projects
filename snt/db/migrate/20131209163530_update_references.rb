class UpdateReferences < ActiveRecord::Migration
  def up
    remove_column :user_contacts, :contact_type
    add_column :user_contacts, :contact_type_id, :integer, index: true

    remove_column :user_contacts, :label
    add_column :user_contacts, :label_id, :integer, index: true

    remove_column :user_addresses, :label
    add_column :user_addresses, :label_id, :integer, index: true

    remove_column :user_payment_types, :payment_type
    add_column :user_payment_types, :payment_type_id, :integer, index: true

    remove_column :payment_types, :payment_type
    add_column :payment_types, :payment_type_id, :integer, index: true

    remove_column :user_payment_types, :card_type
    add_column :user_payment_types, :credit_card_type_id, :integer, index: true

    remove_column :payment_types, :card_type
    add_column :payment_types, :credit_card_type_id, :integer, index: true

    remove_column :user_memberships, :membership_class
    add_column :user_memberships, :membership_class_id, :integer, index: true

    remove_column :membership_types, :membership_class
    add_column :membership_types, :membership_class_id, :integer, index: true

    remove_column :user_memberships, :membership_type
    add_column :user_memberships, :membership_type_id, :integer, index: true

    remove_column :membership_types, :membership_type
    add_column :membership_types, :membership_type_id, :integer, index: true

    remove_column :reservation_notes, :note_type
    add_column :reservation_notes, :note_type_id, :integer, index: true

    remove_column :reservations, :status
    add_column :reservations, :status_id, :integer, index: true

    remove_column :reservation_daily_instances, :reservation_status
    add_column :reservation_daily_instances, :status_id, :integer, index: true

    remove_column :rooms, :hk_status
    add_column :rooms, :hk_status_id, :integer, index: true

    remove_column :users, :language
    add_column :users, :language_id, :integer, index: true

    remove_column :wakeups, :status
    add_column :wakeups, :status_id, :integer, index: true

    remove_column :reservations, :discount_type
    add_column :reservations, :discount_type_id, :integer, index: true

    remove_column :accounts, :account_type
    add_column :accounts, :account_type_id, :integer, index: true
  end

  def down
    add_column :user_contacts, :contact_type, :string
    remove_column :user_contacts, :contact_type_id

    add_column :user_contacts, :label, :string
    remove_column :user_contacts, :label_id

    add_column :user_addresses, :label, :string
    remove_column :user_addresses, :label_id

    add_column :user_payment_types, :payment_type, :string
    remove_column :user_payment_types, :payment_type_id

    add_column :payment_types, :payment_type, :string
    remove_column :payment_types, :payment_type_id

    add_column :user_payment_types, :card_type, :string
    remove_column :user_payment_types, :credit_card_type_id

    add_column :payment_types, :card_type, :string
    remove_column :payment_types, :credit_card_type_id

    add_column :user_memberships, :membership_class, :string
    remove_column :user_memberships, :membership_class_id

    add_column :membership_types, :membership_class, :string
    remove_column :membership_types, :membership_class_id

    add_column :user_memberships, :membership_type, :string
    remove_column :user_memberships, :membership_type_id

    add_column :membership_types, :membership_type, :string
    remove_column :membership_types, :membership_type_id

    add_column :reservation_notes, :note_type, :string
    remove_column :reservation_notes, :note_type_id

    add_column :reservations, :status, :string
    remove_column :reservations, :status_id

    add_column :reservation_daily_instances, :reservation_status, :string
    remove_column :reservation_daily_instances, :status_id

    add_column :rooms, :hk_status, :string
    remove_column :rooms, :hk_status_id

    add_column :users, :language, :string
    remove_column :users, :language_id

    add_column :wakeups, :status, :string
    remove_column :wakeups, :status_id

    add_column :reservations, :discount_type, :string
    remove_column :reservations, :discount_type_id

    add_column :accounts, :account_type, :string
    remove_column :accounts, :account_type_id
  end
end
