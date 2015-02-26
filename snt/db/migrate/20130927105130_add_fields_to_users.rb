class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :loc, :string
    add_column :users, :phone, :string
    add_column :users, :interest_match_count, :integer
  end
end
