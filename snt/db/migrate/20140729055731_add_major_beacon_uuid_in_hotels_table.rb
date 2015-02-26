class AddMajorBeaconUuidInHotelsTable < ActiveRecord::Migration
  def change
    add_column :hotels, :beacon_uuid_major, :string
  end
end
