class RenameUserPaymentTypeName < ActiveRecord::Migration
  def change
    rename_column :user_payment_types, :card_display, :card_name
  end
end
