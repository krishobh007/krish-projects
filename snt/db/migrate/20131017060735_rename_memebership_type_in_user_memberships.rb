class RenameMemebershipTypeInUserMemberships < ActiveRecord::Migration
  def change
    rename_column :user_memberships, :memebership_type, :membership_type
  end
end
