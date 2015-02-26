class RemoveChainFromExternalReference < ActiveRecord::Migration
  def up
    remove_column :external_references, :chain_id
  end

  def down
    add_column :external_references, :chain_id
  end
end
