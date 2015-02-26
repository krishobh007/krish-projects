class DeleteWrongEmailTemplate < ActiveRecord::Migration
  def change
  	execute('DELETE from email_templates where title="STAFF_SUCCESS_LATE_CHECKOUT_ALERT_EMAIL"')
  end
end
