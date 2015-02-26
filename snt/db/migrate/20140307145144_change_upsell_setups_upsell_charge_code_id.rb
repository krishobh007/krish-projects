class ChangeUpsellSetupsUpsellChargeCodeId < ActiveRecord::Migration
  def change
    change_column :upsell_setups, :upsell_charge_code_id, :integer
  end
end
