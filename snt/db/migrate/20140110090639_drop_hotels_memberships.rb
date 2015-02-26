class DropHotelsMemberships < ActiveRecord::Migration
  def up
    drop_table :hotels_memberships
  end

  def down
    create_table :hotels_memberships do |t|
      t.references :hotel, null: false, index: true
      t.integer :membership_type_id, null: false, index: true
      t.integer :membership_class_id, null: false, index: true
    end
  end
end
