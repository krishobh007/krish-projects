class DefaultChainBatchProcess < ActiveRecord::Migration
  def up
    execute 'update hotel_chains set batch_process_enabled = 1 where batch_process_enabled is null'
    change_column :hotel_chains, :batch_process_enabled, :boolean, default: true, null: false
  end

  def down
    change_column :hotel_chains, :batch_process_enabled, :boolean, null: true
  end
end
