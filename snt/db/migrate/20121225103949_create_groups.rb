class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.references :hotel

      t.timestamps
    end
    add_index :groups, :hotel_id
  end
end
