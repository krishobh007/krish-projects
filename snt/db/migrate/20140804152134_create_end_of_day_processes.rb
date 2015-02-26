class CreateEndOfDayProcesses < ActiveRecord::Migration
  def change
    create_table :end_of_day_processes do |t|
      t.references :hotel, null: false
      t.references :ref_end_of_day, null: false
      t.boolean :is_active
      t.integer :process_sequence
      t.timestamps
      t.userstamps
    end
  end
end
