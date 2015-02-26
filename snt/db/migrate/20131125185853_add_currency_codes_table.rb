class AddCurrencyCodesTable < ActiveRecord::Migration
  def change
    create_table :ref_currency_codes do |t|
      t.string :name, null: false
    end
  end
end
