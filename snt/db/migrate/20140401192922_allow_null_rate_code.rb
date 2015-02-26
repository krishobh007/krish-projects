class AllowNullRateCode < ActiveRecord::Migration
  def change
    change_column :rates, :rate_code, :string, null: true
  end
end
