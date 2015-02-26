class RemoveChainFromExternalMapping < ActiveRecord::Migration
  def up
    remove_column :external_mappings, :hotel_chain_id
  end

  def down
    add_column :external_mappings, :hotel_chain_id
  end
end
