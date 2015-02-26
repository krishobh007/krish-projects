class CreateHotelsMembershipTypes < ActiveRecord::Migration
  def change
    create_table :hotels_membership_types do |t|
      t.integer :membership_type_id
      t.integer :hotel_id
    end
  end
end
