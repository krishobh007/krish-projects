class AddKeyDetails < ActiveRecord::Migration
  def change
    add_column :ref_key_systems, :key_card_type_id, :integer
    add_column :ref_key_systems, :sector, :integer
    add_column :ref_key_systems, :block, :integer
  end
end
