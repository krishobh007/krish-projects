class DropPrimaryOnUserMembership < ActiveRecord::Migration
  def change
    remove_column :user_memberships, :is_primary
  end
end
