class CreateRatesAddons < ActiveRecord::Migration
  def change
    create_table :rates_addons, id: false do |t|
      t.references :rate, null: false, index: true
      t.references :addon, null: false, index: true
    end
  end
end
