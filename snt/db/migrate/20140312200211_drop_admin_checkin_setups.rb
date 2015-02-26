class DropAdminCheckinSetups < ActiveRecord::Migration
  def change
    drop_table :hotel_checkin_setups
  end
end
