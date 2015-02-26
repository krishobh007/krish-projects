class DropAddressInfoFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :state_id
    remove_column :users, :zip
    remove_column :users, :country_id
  end

  def down
    add_column :users, :state_id, :integer
    add_column :users, :zip, :string
    add_column :users, :country_id, :integer
  end
end
