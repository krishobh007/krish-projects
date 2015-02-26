class AlterHotelsPaymentTypes < ActiveRecord::Migration
  def up
    rename_column :hotels_payment_types,:ref_payment_type_id, :payment_type_id
  end

end
