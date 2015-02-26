class RemoveMembershipClassIdFromGuestMemberships < ActiveRecord::Migration
  def up
    remove_column :guest_memberships, :membership_class_id
  end

  def down
    add_column :guest_memberships, :membership_class_id, :integer
  end
end
