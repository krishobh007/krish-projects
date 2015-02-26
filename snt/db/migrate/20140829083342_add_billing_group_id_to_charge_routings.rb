class AddBillingGroupIdToChargeRoutings < ActiveRecord::Migration
  def change
    add_column :charge_routings, :billing_group_id, :integer
  end
end
