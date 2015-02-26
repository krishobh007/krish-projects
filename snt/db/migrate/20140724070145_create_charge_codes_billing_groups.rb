class CreateChargeCodesBillingGroups < ActiveRecord::Migration
  def up
  create_table :charge_codes_billing_groups, :id => false do |t|
    t.references :charge_code, :null => false
    t.references :billing_group, :null => false
  end
  end
end
