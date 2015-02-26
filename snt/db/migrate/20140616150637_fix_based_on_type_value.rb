class FixBasedOnTypeValue < ActiveRecord::Migration
  def change
    execute('update rates set based_on_type = "amount" where based_on_type = "$"')
    execute('update rates set based_on_type = "percent" where based_on_type = "%"')
  end
end
