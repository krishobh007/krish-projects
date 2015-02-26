class RemoveCreatedUpdatedAtChargeGroupsCodes < ActiveRecord::Migration
  def up
    remove_column :charge_groups_codes, :created_at
    remove_column :charge_groups_codes, :updated_at
    remove_column :charge_groups_codes, :id
  end

  def down
    remove_column :charge_groups_codes, :created_at, :datetime
    remove_column :charge_groups_codes, :updated_at, :datetime
    remove_column :charge_groups_codes, :id, :integer
  end
end
