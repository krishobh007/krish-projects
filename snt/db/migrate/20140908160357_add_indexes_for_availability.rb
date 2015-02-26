class AddIndexesForAvailability < ActiveRecord::Migration
  def change
    add_index :room_rate_restrictions, [:rate_id, :date]
    add_index :room_custom_rates, [:room_rate_id, :date]
  end
end
