class AddRetrieveUidToKeySystems < ActiveRecord::Migration
  def change
    add_column :ref_key_systems, :retrieve_uid, :boolean, null: false, default: false
    add_column :ref_key_systems, :aid, :string
    add_column :ref_key_systems, :keyb, :string
    remove_column :ref_key_systems, :sector
    remove_column :ref_key_systems, :block
  end
end
