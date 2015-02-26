class AddReportSubTitle < ActiveRecord::Migration
  def change
    execute("update reports set sub_title = 'By Mobile Device' where title = 'Check In / Check Out'")
    execute("update reports set sub_title = 'By Day / User' where title = 'Upsell'")
    execute("update reports set sub_title = 'By Day' where title = 'Late Check Out'")
  end
end
