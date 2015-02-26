class AddContractColumnsToRates < ActiveRecord::Migration
  def change
    add_column :rates, :account_id, :integer
    add_column :rates, :is_fixed_rate, :boolean
    add_column :rates, :is_rate_shown_on_guest_bill, :boolean
  end
end
