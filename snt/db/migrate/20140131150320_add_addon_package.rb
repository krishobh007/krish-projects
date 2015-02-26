class AddAddonPackage < ActiveRecord::Migration
  def change
    add_column :addons, :package_code, :string
  end
end
