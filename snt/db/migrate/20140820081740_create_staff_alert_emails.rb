class CreateStaffAlertEmails < ActiveRecord::Migration
  def change
    create_table :staff_alert_emails do |t|
      t.references :hotel, null: false
      t.string :email, null: false
      t.string :email_type, null: false
      t.timestamps
    end
  end
end
