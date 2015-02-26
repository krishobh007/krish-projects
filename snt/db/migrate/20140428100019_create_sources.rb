class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :code
      t.string :description
      t.integer :hotel_id
      t.boolean :is_active
      t.timestamps
    end
  end
end
