class CreateFloors < ActiveRecord::Migration
  def up
    create_table :floors do |t|
      t.string :floor_number, limit: 40, null: false
      t.string :description, limit: 2000, null: false
      t.integer :hotel_id
      t.timestamps
    end
    
  end

end
