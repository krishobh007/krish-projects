class AlterChargeRoutingsToBillId < ActiveRecord::Migration
  def change
    change_column :charge_routings, :to_bill_id, :integer, null: true
  end
end
