class AddLastSmartbandImported < ActiveRecord::Migration
  def up
    add_column :hotels ,:last_smartband_imported, :datetime
    
  end

end
