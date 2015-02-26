class RenameBlockCodeInReservations < ActiveRecord::Migration
  def change
    rename_column :reservations, :block_code, :group_code
  end
end
