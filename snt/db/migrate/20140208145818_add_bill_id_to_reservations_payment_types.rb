class AddBillIdToReservationsPaymentTypes < ActiveRecord::Migration
  def change
    add_column :reservations_guest_payment_types, :id, :primary_key
    add_column :reservations_guest_payment_types, :bill_number, :integer, null: false, default: 1
  end
end
