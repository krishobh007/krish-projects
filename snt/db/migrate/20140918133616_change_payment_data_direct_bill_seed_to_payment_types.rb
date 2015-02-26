class ChangePaymentDataDirectBillSeedToPaymentTypes < ActiveRecord::Migration
  def change
    execute("UPDATE payment_types SET description = 'Direct Bill' WHERE description = 'Direct Payment'")
  end
end
