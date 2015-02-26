class UpdatePaymentTypeDesc < ActiveRecord::Migration
  def change
    execute("UPDATE payment_types SET description = 'DIRECT PAYMENT' WHERE value = 'DB' AND hotel_id IS NULL")
    execute("UPDATE payment_types SET description = 'CASH PAYMENT' WHERE value = 'CA' AND hotel_id IS NULL")
    execute("UPDATE payment_types SET description = 'CHECK PAYMENT' WHERE value = 'CK' AND hotel_id IS NULL")
  end
end
