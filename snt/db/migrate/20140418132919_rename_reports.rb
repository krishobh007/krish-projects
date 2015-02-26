class RenameReports < ActiveRecord::Migration
  def change
    execute("update reports set name = 'Check In / Check Out' where name = 'Check in / check out by mobile device'")
    execute("update reports set name = 'Upsell' where name = 'Upsell by day & by user'")
    execute("update reports set name = 'Late Check Out' where name = 'Late check out by day'")

    execute("update reports set description = 'Number of Check Ins and Check Outs through mobile devices by date range'
             where name = 'Check In / Check Out'")
    execute("update reports set description = 'Number of Upsells from one room type to the next level by day and by user' where name = 'Upsell'")
    execute("update reports set description = 'Number of Late Checkouts by day' where name = 'Late Check Out'")
  end
end
