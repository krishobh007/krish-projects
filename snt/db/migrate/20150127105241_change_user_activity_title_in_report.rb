class ChangeUserActivityTitleInReport < ActiveRecord::Migration
  def change
    execute("UPDATE reports set title = 'Login and out Activity' WHERE reports.method = 'user_activity_report';")
    execute("UPDATE reports set description = 'All user login and logout activity' WHERE reports.method = 'user_activity_report';")
    execute("UPDATE reports set sub_title = 'By User' WHERE reports.method = 'user_activity_report';")
  end
end
