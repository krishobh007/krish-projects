class ChangeBusinessDateToActivityDateTimeInUserActivities < ActiveRecord::Migration
  def change
    rename_column :user_activities, :business_date, :activity_date_time
  end
end
