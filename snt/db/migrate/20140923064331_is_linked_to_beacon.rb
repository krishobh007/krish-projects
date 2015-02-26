class IsLinkedToBeacon < ActiveRecord::Migration
  def change
    add_column :beacons, :is_linked, :boolean, default: false
  end

end
