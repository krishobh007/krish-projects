class CreateProductConfigAttrValues < ActiveRecord::Migration
  def change
    create_table :product_config_attr_values do |t|

      t.column :value, :string
      t.column :default, :string
      t.references :product_config_attr
      t.references :hotel
      t.references :hotel_chain
      t.timestamps
    end
  end
end
