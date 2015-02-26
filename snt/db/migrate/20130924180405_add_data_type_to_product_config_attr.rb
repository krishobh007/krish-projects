class AddDataTypeToProductConfigAttr < ActiveRecord::Migration
  def up
    add_column :product_config_attrs, :data_type, :string
  end

  def down
    remove_column :product_config_attrs, :data_type
  end
end
