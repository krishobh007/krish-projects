class RenameNotificationInfoTableToDeviceDetails < ActiveRecord::Migration
  def change
    rename_table :notification_info, :notification_device_details
  end
end
