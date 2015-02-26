class RenameCurrencyCodeName < ActiveRecord::Migration
  def change
    rename_column :ref_currency_codes, :name, :value
    add_column :ref_currency_codes, :description, :string
  end
end
