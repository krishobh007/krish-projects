class RemoveProductConfigTables < ActiveRecord::Migration
  def up
    drop_table :product_config_attr_values
    drop_table :product_config_attrs
  end

  def down
    create_table :product_config_attrs do |t|
      t.column :name, :string
      t.column :display_name, :string
      t.column :data_type, :string
      t.timestamps
    end

    create_table :product_config_attr_values do |t|
      t.column :value, :text
      t.references :product_config_attr
      t.references :hotel
      t.references :hotel_chain
      t.timestamps
    end
  end
end
