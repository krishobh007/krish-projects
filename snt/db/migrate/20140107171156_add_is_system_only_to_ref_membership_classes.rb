class AddIsSystemOnlyToRefMembershipClasses < ActiveRecord::Migration
  def change
    add_column :ref_membership_classes, :is_system_only, :boolean
  end
end
