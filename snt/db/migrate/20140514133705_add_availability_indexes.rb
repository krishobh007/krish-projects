class AddAvailabilityIndexes < ActiveRecord::Migration
  def change
    add_index :inventory_details, [:hotel_id, :rate_id, :room_type_id, :date], unique: true, name: 'index_inventory_details_uniq'
    add_index :sell_limits, [:hotel_id, :from_date, :to_date, :rate_id, :room_type_id], name: 'index_sell_limits'
    add_index :restrictions, [:hotel_id, :rate_id, :room_type_id, :date], unique: true, name: 'index_restrictions_uniq'
    add_index :room_rates, [:rate_set_id, :room_type_id], unique: true, name: 'index_room_rates_uniq'
    add_index :rate_sets, [:rate_date_range_id, :name], unique: true, name: 'index_rate_sets_uniq'
    add_index :rate_date_ranges, [:rate_id, :begin_date, :end_date], name: 'index_rate_date_ranges'
  end
end
