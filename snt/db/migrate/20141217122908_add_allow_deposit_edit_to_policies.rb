class AddAllowDepositEditToPolicies < ActiveRecord::Migration
  def change
    add_column :policies, :allow_deposit_edit, :boolean
  end
end
