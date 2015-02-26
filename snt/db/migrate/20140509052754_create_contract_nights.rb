class CreateContractNights < ActiveRecord::Migration
  def change
  	create_table :contract_nights do |t|
      t.references :contract
      t.integer :month
      t.integer :no_of_nights
      t.userstamps
      t.timestamps
  	end
  end
end
