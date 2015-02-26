class MoveUpsellSetup < ActiveRecord::Migration
  def change
    add_column :hotels, :upsell_charge_code_id, :integer

    execute 'update upsell_setups s, hotels h set h.upsell_charge_code_id = s.upsell_charge_code_id where s.hotel_id = h.id'

    drop_table :upsell_setups
  end
end
