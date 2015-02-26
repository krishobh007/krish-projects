class AddChargeCodeTypeIdChargeCodes < ActiveRecord::Migration
  def change
    add_column :charge_codes, :charge_code_type_id, :integer,  references: :charge_codes
  end
end
