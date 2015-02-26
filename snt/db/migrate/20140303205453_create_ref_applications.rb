class CreateRefApplications < ActiveRecord::Migration
  def change
    create_table :ref_applications do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end
  end
end
