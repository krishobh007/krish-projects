class ChangeCurrencyCodeToId < ActiveRecord::Migration
  def change
    remove_column :reservation_daily_instances, :currency_code
    remove_column :rates, :currency_code
    remove_column :financial_transactions, :currency_code

    add_column :reservation_daily_instances, :currency_code_id, :integer
    add_column :rates, :currency_code_id, :integer
    add_column :financial_transactions, :currency_code_id, :integer
  end
end
