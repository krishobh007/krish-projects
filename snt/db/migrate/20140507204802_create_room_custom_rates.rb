class CreateRoomCustomRates < ActiveRecord::Migration
  def change
    create_table :room_custom_rates do |t|
      t.references :room_rate, null: false
      t.date :date, null: false
      t.float :single_amount, null: false
      t.float :double_amount, null: false
      t.float :extra_adult_amount, null: false
      t.float :child_amount, null: false
      t.timestamps
      t.userstamps
    end
  end
end
