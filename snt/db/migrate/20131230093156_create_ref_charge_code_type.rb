class CreateRefChargeCodeType < ActiveRecord::Migration
  def change
    create_table :ref_charge_code_types do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end
  end
end
