class ChangeDataTypeForCardExpiry < ActiveRecord::Migration
  def change
    change_column 'user_payment_types', 'card_expiry', :string, null: false
  end
end
