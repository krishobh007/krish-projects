class DropRatesIndex < ActiveRecord::Migration
  def change
    remove_index :rates, [:hotel_id, :rate_code]
  end
end
