class AddReferenceTables < ActiveRecord::Migration
  def change
    create_table :ref_contact_types do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_contact_labels do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_payment_types do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_credit_card_types do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_membership_classes do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_membership_types do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_note_types do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_reservation_statuses do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_front_office_statuses do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_housekeeping_statuses do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_addons do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_cancel_codes do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_languages do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_titles do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_wakeup_statuses do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_discount_types do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_policy_types do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_account_types do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end
  end
end
