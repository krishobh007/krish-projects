class AddColumnsToHotelChain < ActiveRecord::Migration
  def up
    add_column :hotel_chains, :batch_process_enabled, :boolean
    add_column :hotel_chains, :code, :string
  end

  def down
    remove_column :hotel_chains, :batch_process_enabled
    remove_column :hotel_chains, :code
  end
end
