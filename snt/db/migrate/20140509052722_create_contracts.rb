class CreateContracts < ActiveRecord::Migration
  def change
  	create_table :contracts do |t|
      t.string :contract_name, null: false
      t.references :rate
      t.references :account
      t.date :begin_date
      t.date :end_date
      t.boolean :is_fixed_rate, default: true
      t.boolean :is_rate_shown_on_guest_bill, default: true
      t.timestamps
      t.userstamps
  	end
  end
end
