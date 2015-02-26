class AddColumnBusinessDateToUserActivities < ActiveRecord::Migration
  def change
    add_column :user_activities, :business_date, :date
  end
end
