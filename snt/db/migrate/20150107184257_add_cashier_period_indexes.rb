class AddCashierPeriodIndexes < ActiveRecord::Migration
  def change
    add_index :cashier_periods, [:user_id, :status, :ends_at], name: 'idx_cashier_periods_user_status_ends_at'
  end
end
