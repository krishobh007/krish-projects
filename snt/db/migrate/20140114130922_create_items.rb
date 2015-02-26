class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :hotel
      t.references :charge_code
      t.decimal :unit_price
      t.string :description
      t.references :created_by, null: true
      t.references :updated_by, null: true
      t.timestamps
    end
  end
end
