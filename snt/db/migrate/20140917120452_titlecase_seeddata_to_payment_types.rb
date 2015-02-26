class TitlecaseSeeddataToPaymentTypes < ActiveRecord::Migration
   def change
    execute("UPDATE payment_types SET description = 'Direct Payment' WHERE description = 'DIRECT PAYMENT'")
    execute("UPDATE payment_types SET description = 'Cash Payment' WHERE description = 'CASH PAYMENT'")
    execute("UPDATE payment_types SET description = 'Check Payment' WHERE description = 'CHECK PAYMENT'")
  end
end
