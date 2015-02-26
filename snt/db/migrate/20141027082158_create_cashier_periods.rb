class CreateCashierPeriods < ActiveRecord::Migration
  def change
    create_table :cashier_periods do |t|
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.references :user
      t.string :status, null: false
      t.float :checks_submitted
      t.float :cash_submitted
      t.float :opening_balance_check
      t.float :opening_balance_cash
      t.timestamps
    end
  end
end
