class AddGuestCardColumnToUserPaymentTypes < ActiveRecord::Migration
  def change
    add_column :user_payment_types, :is_on_guest_card, :boolean
  end
end
