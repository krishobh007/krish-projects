class RemoveIdFromHotelsMembershipTypes < ActiveRecord::Migration
  def up
    remove_column :hotels_membership_types, :id
  end

  def down
    add_column :hotels_membership_types, :id, :integer
  end
end
