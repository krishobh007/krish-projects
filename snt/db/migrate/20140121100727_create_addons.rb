class CreateAddons < ActiveRecord::Migration
  def change
    create_table :addons do |t|
      t.string :name
      t.string :description
      t.string :begin_date
      t.string :end_date
      t.string :package_rythm
      t.string :price_calculation
      t.decimal :amount , precision: 10, scale: 2
      t.references :hotel
      t.timestamps
    end
  end
end
