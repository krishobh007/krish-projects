class AddPaymentTypeToChargeCodes < ActiveRecord::Migration
  def change
    add_column :charge_codes, :associated_payment_id , :integer
    add_column :charge_codes, :associated_payment_type , :string
  end
end
