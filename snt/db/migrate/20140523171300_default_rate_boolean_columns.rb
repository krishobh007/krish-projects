class DefaultRateBooleanColumns < ActiveRecord::Migration
  def change
    execute('update rates set is_fixed_rate = false where is_fixed_rate is null')
    execute('update rates set is_rate_shown_on_guest_bill = false where is_rate_shown_on_guest_bill is null')

    change_column :rates, :is_fixed_rate, :boolean, null: false, default: false
    change_column :rates, :is_rate_shown_on_guest_bill, :boolean, null: false, default: false
  end
end
