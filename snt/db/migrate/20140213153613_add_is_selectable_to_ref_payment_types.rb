class AddIsSelectableToRefPaymentTypes < ActiveRecord::Migration
  def change
    add_column :ref_payment_types, :is_selectable, :boolean, null: false, default: true
  end
end
