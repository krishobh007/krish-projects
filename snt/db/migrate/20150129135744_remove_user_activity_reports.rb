class RemoveUserActivityReports < ActiveRecord::Migration
  def change
    execute("DELETE FROM reports WHERE reports.title = 'User Activity';")
  end
end
