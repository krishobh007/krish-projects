class CreateRoomTypesTable < ActiveRecord::Migration
  def change
    create_table :room_types do |t|
      t.references :chain, null: false, index: true
      t.references :hotel, null: false, index: true
      t.string :room_type, null: false, limit: 20
      t.string :description, null: false
      t.integer :no_of_rooms, null: false
      t.integer :max_adults
      t.integer :max_children

      t.references :created_by
      t.references :updated_by
      t.timestamps
    end
  end
end
