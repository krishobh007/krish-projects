class ChangeUnitPriceInItems < ActiveRecord::Migration
  def change
    change_column :items, :unit_price, :decimal, precision: 10, scale: 2
  end
end
