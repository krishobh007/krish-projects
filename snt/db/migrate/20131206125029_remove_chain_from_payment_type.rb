class RemoveChainFromPaymentType < ActiveRecord::Migration
  def up
    remove_column :payment_types, :chain_id
  end

  def down
    add_column :payment_types, :chain_id
  end
end
