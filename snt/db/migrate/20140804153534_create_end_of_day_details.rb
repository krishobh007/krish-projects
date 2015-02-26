class CreateEndOfDayDetails < ActiveRecord::Migration
  def change
    create_table :end_of_day_details do |t|
      t.references :end_of_day_process, null: false
      t.date :process_date
      t.boolean :is_process_success
      t.timestamps
      t.userstamps
    end
  end
end
