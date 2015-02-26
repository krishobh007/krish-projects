class AddIsAdvanceBillToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :is_advance_bill, :boolean, default: false
  end
end
