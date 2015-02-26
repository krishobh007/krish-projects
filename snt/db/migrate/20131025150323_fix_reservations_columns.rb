class FixReservationsColumns < ActiveRecord::Migration
  def change
    change_column :reservations, :membership_no, :string
    change_column :reservations, :membership_type, :string
  end
end
