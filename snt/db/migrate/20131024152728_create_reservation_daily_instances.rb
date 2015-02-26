class CreateReservationDailyInstances < ActiveRecord::Migration
  def change
    create_table :reservation_daily_instances do |t|
      t.references :reservation, null: false
      t.date :reservation_date, null: false
      t.string :reservation_status, limit: 20, null: false
      t.string :room, limit: 20
      t.integer :room_type_id, null: false
      t.integer :original_room_type_id
      t.decimal :rate_amount, precision: 10, scale: 2
      t.integer :rate_id
      t.string :currency_code, limit: 20
      t.decimal :original_rate_amount, precision: 10, scale: 2
      t.string :market_segment, limit: 20
      t.integer :adults, null: false
      t.integer :children
      t.integer :children1
      t.integer :children2
      t.integer :children3
      t.integer :children4
      t.integer :children5
      t.integer :children6
      t.integer :cribs
      t.integer :extra_beds
      t.string :turndown_status, limit: 10
      t.boolean :is_due_out
      t.integer :block_id
      t.integer :company_id
      t.integer :travel_agent_id
      t.integer :group_id

      t.timestamps
    end
  end
end
