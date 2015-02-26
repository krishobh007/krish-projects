class AddIsPrimaryToUserMemberships < ActiveRecord::Migration
  def change
    add_column :user_memberships, :is_primary, :boolean
  end
end
