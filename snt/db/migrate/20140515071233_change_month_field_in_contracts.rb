class ChangeMonthFieldInContracts < ActiveRecord::Migration
  def change
  	rename_column :contract_nights, :month, :month_year
    change_column :contract_nights, :month_year, :date
  end
end
