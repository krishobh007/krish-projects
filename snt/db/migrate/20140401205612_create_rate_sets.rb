class CreateRateSets < ActiveRecord::Migration
  def change
    create_table :rate_sets do |t|
      t.references :rate_date_range, null: false
      t.string :name, null: false
      t.boolean :sunday, null: false, default: false
      t.boolean :monday, null: false, default: false
      t.boolean :tuesday, null: false, default: false
      t.boolean :wednesday, null: false, default: false
      t.boolean :thursday, null: false, default: false
      t.boolean :friday, null: false, default: false
      t.boolean :saturday, null: false, default: false
      t.timestamps
      t.userstamps
    end
  end
end
