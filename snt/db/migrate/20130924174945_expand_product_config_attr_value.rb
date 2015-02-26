class ExpandProductConfigAttrValue < ActiveRecord::Migration
  def up
    change_column :product_config_attr_values, :value, :string, limit: 1000
  end

  def down
    change_column :product_config_attr_values, :value, :string, limit: 255
  end
end
