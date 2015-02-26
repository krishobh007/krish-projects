class RemoveConfirmNoFromPreReservations < ActiveRecord::Migration
  def up
    remove_column :pre_reservations, :confirm_no
  end

  def down
    add_column :pre_reservations, :confirm_no, :string
  end
end
