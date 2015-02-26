class CreateProductConfigAttrs < ActiveRecord::Migration
  def change
    create_table :product_config_attrs do |t|

      t.column :name, :string
      t.column :display_name, :string
      t.column :type, :string

      t.timestamps
    end
  end
end
