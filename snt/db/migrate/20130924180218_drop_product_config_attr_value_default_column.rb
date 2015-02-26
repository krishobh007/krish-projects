class DropProductConfigAttrValueDefaultColumn < ActiveRecord::Migration
  def up
    remove_column :product_config_attr_values, :default
  end

  def down
    add_column :product_config_attr_values, :default, :string
  end
end
