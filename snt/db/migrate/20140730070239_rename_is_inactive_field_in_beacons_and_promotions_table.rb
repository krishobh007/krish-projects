class RenameIsInactiveFieldInBeaconsAndPromotionsTable < ActiveRecord::Migration
  def change
    rename_column :beacons, :is_inactive, :is_active
    rename_column :promotions, :is_inactive, :is_active
  end
end
