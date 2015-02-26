class CreateLateCheckoutSetups < ActiveRecord::Migration
  def change
    create_table :late_checkout_setups do |t|
      t.boolean :is_latecheckout_on
      t.integer :upsell_charge_code_id
      t.time :upsell_alert_time
      t.decimal :num_late_co_allowed
      t.boolean :is_pre_assigned_rooms_excluded
      t.integer :hotel_id , references: :hotels
      t.timestamps
    end
  end
end
