class AddAlertTimeToCheckinSetup < ActiveRecord::Migration
  def change
    add_column :hotel_checkin_setups, :alert_time, :time
  end
end
