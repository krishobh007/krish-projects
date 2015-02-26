class AddIsSwipedToPaymentType < ActiveRecord::Migration
  def change
    add_column :guest_payment_types, :is_swiped, :boolean
  end
end
