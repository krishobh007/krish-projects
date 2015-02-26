class RemoveChargeCodeTypeChargeCodes < ActiveRecord::Migration
  def change
    remove_column :charge_codes, :charge_code_type
  end
end
