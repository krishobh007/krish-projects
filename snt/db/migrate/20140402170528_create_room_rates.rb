class CreateRoomRates < ActiveRecord::Migration
  def change
    create_table :room_rates do |t|
      t.references :room_type, null: false
      t.references :rate_set, null: false
      t.float :single_amount, null: false
      t.float :double_amount, null: false
      t.float :extra_adult_amount, null: false
      t.float :child_amount, null: false
      t.timestamps
      t.userstamps
    end
  end
end
