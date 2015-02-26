class AddShiftsTable < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.string :name
      t.time :time
      t.references :hotel
    end
  end
end
