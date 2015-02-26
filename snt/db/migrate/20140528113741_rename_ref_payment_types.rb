class RenameRefPaymentTypes < ActiveRecord::Migration
  def change
    rename_table :ref_payment_types,:payment_types
  end
end
