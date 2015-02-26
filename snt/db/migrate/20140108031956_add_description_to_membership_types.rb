class AddDescriptionToMembershipTypes < ActiveRecord::Migration
  def change
    add_column :membership_types, :description, :text
  end
end
