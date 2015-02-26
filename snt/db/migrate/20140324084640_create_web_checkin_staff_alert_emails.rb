class CreateWebCheckinStaffAlertEmails < ActiveRecord::Migration
  def change
    create_table :web_checkin_staff_alert_emails do |t|
      t.references :hotel, null: false
      t.string :email, null: false
      t.timestamps
    end
  end
end
