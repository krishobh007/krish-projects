class AddRateNameColumnToRates < ActiveRecord::Migration
  def change
    add_column :rates, :name, :string
  end
end
