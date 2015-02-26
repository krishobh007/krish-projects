class CreateRefDateFormats < ActiveRecord::Migration
  def change
  	create_table :ref_date_formats do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end
  end
end
