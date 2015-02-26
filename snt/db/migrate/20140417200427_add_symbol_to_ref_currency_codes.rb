class AddSymbolToRefCurrencyCodes < ActiveRecord::Migration
  def change
    add_column :ref_currency_codes, :symbol, :string
    execute "update ref_currency_codes set symbol = '$' where value = 'USD'"
    change_column :ref_currency_codes, :symbol, :string, null: false
  end
end
