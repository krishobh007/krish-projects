class CreateChargeCodes < ActiveRecord::Migration
  def change
    create_table :charge_codes do |t|
      t.string :charge_code
      t.string :charge_code_type
      t.string :description
      t.references :hotel
      t.timestamps
    end
  end
end
