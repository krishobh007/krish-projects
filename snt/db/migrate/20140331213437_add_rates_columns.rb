class AddRatesColumns < ActiveRecord::Migration
  def change
    add_column :rates, :based_on_rate_id, :integer
    add_column :rates, :based_on_type, :string
    add_column :rates, :based_on_value, :decimal, precision: 10, scale: 2
    add_column :rates, :is_active, :boolean
  end
end
