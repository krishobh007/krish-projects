class CreateRateTypes < ActiveRecord::Migration
  def change
    create_table :rate_types do |t|
      t.string :name
      t.text :description
      t.integer :hotel_id

      t.timestamps
    end
  end
end
