class AddChargeCodeIdToPolicies < ActiveRecord::Migration
  def change
    add_column :policies, :charge_code_id, :integer
  end
end
