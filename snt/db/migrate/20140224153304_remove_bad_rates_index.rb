class RemoveBadRatesIndex < ActiveRecord::Migration
  def change
    remove_index :rates, [:hotel_id, :rate_name]
  end
end
