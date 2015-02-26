class AddMliTokenIndex < ActiveRecord::Migration
  def change
    add_index :guest_payment_types, :mli_token
  end
end
