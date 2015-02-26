class AddHotelImportFrequencies < ActiveRecord::Migration
  def change
    add_column :hotels, :day_import_freq, :integer
    add_column :hotels, :night_import_freq, :integer

    execute('update hotels h set day_import_freq = (select res_import_freq from hotel_chains c where h.hotel_chain_id = c.id)')
    execute('update hotels h set night_import_freq = (select res_import_freq from hotel_chains c where h.hotel_chain_id = c.id)')

    remove_column :hotel_chains, :res_import_freq
  end
end
