class MakeRateIsActiveNotNull < ActiveRecord::Migration
  def change
    execute("update rates set is_active = true")
    change_column :rates, :is_active, :boolean, null: false
  end
end
