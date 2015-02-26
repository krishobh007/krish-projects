class AllowNullRateBeginDate < ActiveRecord::Migration
  def change
    change_column :rates, :begin_date, :date, null: true
  end
end
