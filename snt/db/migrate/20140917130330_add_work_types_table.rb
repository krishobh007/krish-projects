class AddWorkTypesTable < ActiveRecord::Migration
  def change
    create_table :work_types do |t|
      t.string :name
      t.references :hotel
      t.boolean :is_active, default: true
      t.timestamps
    end
  end
end
