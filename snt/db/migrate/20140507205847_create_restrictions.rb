class CreateRestrictions < ActiveRecord::Migration
  def change
    create_table :restrictions do |t|
      t.references :hotel, null: false
      t.references :type, null: false
      t.date :date, null: false
      t.references :rate, null: false
      t.references :room_type, null: false
      t.integer :days
      t.timestamps
      t.userstamps
    end
  end
end
