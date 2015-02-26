class CreateSmartbands < ActiveRecord::Migration
  def change
    create_table :smartbands do |t|
      t.references :reservation, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :account_number, null: false
      t.boolean :is_fixed, null: false, default: false
      t.float :amount
      t.timestamps
      t.userstamps
    end
  end
end
