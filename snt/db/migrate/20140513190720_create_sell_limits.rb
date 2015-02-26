class CreateSellLimits < ActiveRecord::Migration
  def change
    create_table :sell_limits do |t|
      t.references :hotel, null: false
      t.date :from_date, null: false
      t.date :to_date, null: false
      t.references :rate
      t.references :room_type
      t.integer :to_sell, null: false
      t.timestamps
      t.userstamps
    end
  end
end
