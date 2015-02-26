class ExpandPaymentTypeCardName < ActiveRecord::Migration
  def change
    change_column :user_payment_types, :card_name, :string, limit: 255
  end
end
