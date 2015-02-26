class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :chain_id, null: false
      t.integer :hotel_id, null: false
      t.string :room_no, limit: 20, null: false
      t.integer :room_type_id, null: false
      t.string :floor, limit: 20
      t.string :hk_status, limit: 20
      t.boolean :is_occupied
      t.boolean :is_out_of_order
      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps
    end

    add_index(:rooms, [:chain_id, :hotel_id, :room_no], name: 'idx_rooms_room_no_uk', unique: true, order: { chain_id: :asc, hotel_id: :asc, room_no: :asc })
  end
end
