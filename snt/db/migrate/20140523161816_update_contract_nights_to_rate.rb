class UpdateContractNightsToRate < ActiveRecord::Migration
  def change
    execute('delete from contract_nights')
    remove_column :contract_nights, :contract_id
    add_column :contract_nights, :rate_id, :integer, null: false
  end
end
