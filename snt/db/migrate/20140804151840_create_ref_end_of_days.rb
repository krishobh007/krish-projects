class CreateRefEndOfDays < ActiveRecord::Migration
  def change
    create_table :ref_end_of_days do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end
  end
end
