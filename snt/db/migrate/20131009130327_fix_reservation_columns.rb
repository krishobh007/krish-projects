class FixReservationColumns < ActiveRecord::Migration
  def change
    change_column :reservations, :confirm_no, :string
    change_column :reservations, :room_no, :string
  end
end
