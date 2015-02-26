class AddDefaultCurrencyCodeToHotel < ActiveRecord::Migration
  def change
    add_column :hotels, :default_currency_code, :string
  end
end
