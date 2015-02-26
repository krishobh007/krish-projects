class AddRateTypeIdToRates < ActiveRecord::Migration
  def change
    add_column :rates, :rate_type_id, :integer
  end
end
