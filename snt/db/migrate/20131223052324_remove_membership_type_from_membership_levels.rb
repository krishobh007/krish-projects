class RemoveMembershipTypeFromMembershipLevels < ActiveRecord::Migration
  def up
    remove_column :membership_levels, :membership_type
  end

  def down
    add_column :membership_levels, :membership_type, :string
  end
end
