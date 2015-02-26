class AddMliTransactionId < ActiveRecord::Migration
  def change
    add_column :guest_payment_types, :mli_transaction_id, :string
    rename_column :guest_payment_types, :card_token, :mli_token
  end
end
