class AddUpsellChargeCodeToUpsellSetups < ActiveRecord::Migration
  def change
    add_column :upsell_setups, :upsell_charge_code_id, :string
  end
end
