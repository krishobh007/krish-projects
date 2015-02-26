class AddBasedOnRateIdToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :based_on_rate_id, :integer
  end
end
