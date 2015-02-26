class CreateRateDateRanges < ActiveRecord::Migration
  def change
    create_table :rate_date_ranges do |t|
      t.references :rate
      t.date :begin_date, null: false
      t.date :end_date, null: false
      t.timestamps
      t.userstamps
    end
  end
end
