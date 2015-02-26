class ChangeDescriptionMembershipLevel < ActiveRecord::Migration
  def change
    change_column :membership_levels, :description, :string, limit: 80, null: true
  end
end
