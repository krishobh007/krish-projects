class AddImportFrequencyColumnsToHotelChain < ActiveRecord::Migration
  def change
    add_column :hotel_chains, :res_import_freq, :integer
    add_column :hotel_chains, :room_status_import_freq, :integer
  end
end
