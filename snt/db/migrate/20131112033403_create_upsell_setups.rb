class CreateUpsellSetups < ActiveRecord::Migration
  def change
    create_table :upsell_setups do |t|
      t.references :hotel
      t.boolean :is_one_night_only
      t.boolean :is_force_upsell
      t.boolean :is_upsell_on
      t.float :total_upsell_target_amount
      t.integer :total_upsell_target_rooms
      t.timestamps
    end
  end
end
