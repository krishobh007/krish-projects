class CreateChargeCodeGenerates < ActiveRecord::Migration
  def change
    create_table :charge_code_generates do |t|
      t.references :charge_code
      t.integer :generate_charge_code_id
      t.timestamps
    end
  end
end
