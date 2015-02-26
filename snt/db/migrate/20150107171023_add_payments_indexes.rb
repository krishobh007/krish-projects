class AddPaymentsIndexes < ActiveRecord::Migration
  def change
    add_index :charge_codes, [:associated_payment_id, :associated_payment_type], name: 'idx_charge_codes_assoc_pay'
    add_index :actions, [:actionable_id, :actionable_type], name: 'idx_actions_actionable'
    add_index :roles, [:hotel_id, :name]
  end
end
