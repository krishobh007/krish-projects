class AddAddonColumns < ActiveRecord::Migration
  def change
    create_table :ref_amount_types do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    create_table :ref_post_types do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end

    add_column :addons, :bestseller, :boolean, null: false, default: false
    add_column :addons, :charge_group_id, :integer
    add_column :addons, :charge_code_id, :integer
    add_column :addons, :amount_type_id, :integer
    add_column :addons, :post_type_id, :integer
    add_column :addons, :rate_code_only, :boolean, null: false, default: false
  end
end
