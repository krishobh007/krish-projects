class AddNotificationSectionToNotificationDetails < ActiveRecord::Migration
  def change
    add_column :notification_details, :notification_section, :string
  end
end
