class RemoveGroupFromReservations < ActiveRecord::Migration
  def up
    remove_column :reservations, :group_code
    remove_column :reservations, :group_id
  end

  def down
    add_column :reservations, :group_id, :string
    add_column :reservations, :group_code, :string
  end
end
