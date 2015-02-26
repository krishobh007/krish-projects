class ChangeActivityDateTimeTypeToDateTimeInUserActivities < ActiveRecord::Migration
  def change
    change_column :user_activities, :activity_date_time, :datetime
  end
end
