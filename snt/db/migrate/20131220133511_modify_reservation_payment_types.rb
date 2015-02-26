class ModifyReservationPaymentTypes < ActiveRecord::Migration
  def change
    remove_column :reservation_payment_types, :user_payment_type_id
    add_column :reservation_payment_types, :guest_payment_type_id, :integer
  end
end
