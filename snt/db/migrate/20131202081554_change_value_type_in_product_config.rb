class ChangeValueTypeInProductConfig < ActiveRecord::Migration
  def up
    change_column :product_config_attr_values, :value, :text
  end

  def down
    change_column :product_config_attr_values, :value, :string
  end
end
