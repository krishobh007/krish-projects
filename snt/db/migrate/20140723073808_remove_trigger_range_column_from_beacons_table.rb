class RemoveTriggerRangeColumnFromBeaconsTable < ActiveRecord::Migration
  def change
    remove_column :beacons, :trigger_range
  end
end
