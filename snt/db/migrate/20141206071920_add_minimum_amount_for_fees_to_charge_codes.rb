class AddMinimumAmountForFeesToChargeCodes < ActiveRecord::Migration
  def change
    add_column :charge_codes, :minimum_amount_for_fees, :float
  end
end
