class DropTypeFromProductConfigAttr < ActiveRecord::Migration
  def up
    remove_column(:product_config_attrs, :type)
  end

  def down
    add_column(:product_config_attrs, :type, :string)
  end
end
