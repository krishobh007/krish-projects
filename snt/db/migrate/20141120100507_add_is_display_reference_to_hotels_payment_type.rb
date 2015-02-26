class AddIsDisplayReferenceToHotelsPaymentType < ActiveRecord::Migration
  def change
    add_column :hotels_payment_types, :is_display_reference, :boolean, :default => false
  end
end
