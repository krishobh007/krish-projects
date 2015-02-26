class AddMoreSearchIndexes < ActiveRecord::Migration
  def change
    add_index :reservations, :confirm_no
    add_index :groups, :name
  end
end
