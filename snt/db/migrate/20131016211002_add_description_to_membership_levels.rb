class AddDescriptionToMembershipLevels < ActiveRecord::Migration
  def change
    add_column :membership_levels, :description, :string, limit: 80, null: false
  end
end
