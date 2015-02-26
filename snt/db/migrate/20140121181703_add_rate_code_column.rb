class AddRateCodeColumn < ActiveRecord::Migration
  def change
    add_column :rates, :rate_code, :string
  end
end
