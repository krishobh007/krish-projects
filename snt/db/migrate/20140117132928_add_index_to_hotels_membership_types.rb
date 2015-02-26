class AddIndexToHotelsMembershipTypes < ActiveRecord::Migration
  def change
    add_index :hotels_membership_types, [:hotel_id, :membership_type_id], unique: true
  end
end
