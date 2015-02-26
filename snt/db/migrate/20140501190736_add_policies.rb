class AddPolicies < ActiveRecord::Migration
  def change
    create_table :policies do |t|
      t.string :name, null: false
      t.string :description
      t.float :amount, null: false
      t.string :amount_type, null: false
      t.references :post_type
      t.boolean :apply_to_all_bookings, default: false
      t.integer :advance_days
      t.time :advance_time
      t.references :policy_type, null: false
      t.references :hotel, null: false
      t.timestamps
      t.userstamps
    end

    execute('update ref_policy_types set value = "DEPOSIT_REQUEST", description = "Deposit Request" where value = "DEPOSITPOLICY"')
    execute('update ref_policy_types set value = "CANCELLATION_POLICY", description = "Cancellation Policy" where value = "CANCELPOLICY"')
  end
end
