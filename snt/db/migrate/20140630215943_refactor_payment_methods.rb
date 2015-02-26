class RefactorPaymentMethods < ActiveRecord::Migration
  def change
    rename_table :guest_payment_types, :payment_methods

    add_column :payment_methods, :associated_id, :integer
    add_column :payment_methods, :associated_type, :string
    add_column :payment_methods, :bill_number, :integer

    execute('update payment_methods set associated_id = guest_detail_id, associated_type = "GuestDetail" where is_on_guest_card = true')

    change_column :payment_methods, :guest_detail_id, :integer, null: true

    execute('insert into payment_methods (associated_id, associated_type, mli_token, card_name, card_expiry, card_cvv, mli_transaction_id, ' \
            '  credit_card_type_id, external_id, payment_type_id, is_swiped, bill_number, created_at, updated_at, creator_id, updater_id) ' \
            'select reservation_id, "Reservation", mli_token, card_name, card_expiry, card_cvv, mli_transaction_id, credit_card_type_id, ' \
            '  external_id, payment_type_id, is_swiped, rp.bill_number, created_at, updated_at, creator_id, updater_id ' \
            'from reservations_guest_payment_types rp, payment_methods p ' \
            'where rp.guest_payment_type_id = p.id')

    execute('delete from payment_methods where associated_id is null')

    change_column :payment_methods, :associated_id, :integer, null: false
    change_column :payment_methods, :associated_type, :string, null: false

    remove_column :payment_methods, :is_on_guest_card
    remove_column :payment_methods, :guest_detail_id

    drop_table :reservations_guest_payment_types

    add_index :payment_methods, [:associated_id, :associated_type]
  end
end
