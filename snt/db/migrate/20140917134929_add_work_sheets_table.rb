class AddWorkSheetsTable < ActiveRecord::Migration
   def change
    create_table :work_sheets do |t|
      t.references :user
      t.references :work_type
      t.references :shift
      t.date :date
    end
  end
end
