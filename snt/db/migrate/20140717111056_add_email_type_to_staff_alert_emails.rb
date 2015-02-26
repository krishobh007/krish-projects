class AddEmailTypeToStaffAlertEmails < ActiveRecord::Migration
  def change
    add_column :web_checkout_staff_alert_emails, :email_type, :string
    execute "update web_checkout_staff_alert_emails set email_type='CHECKOUT' where email_type IS NULL"
  end
end
