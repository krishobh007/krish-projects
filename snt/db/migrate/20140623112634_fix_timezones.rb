class FixTimezones < ActiveRecord::Migration
  def change
    execute("update hotels set tz_info = 'America/New_York' where tz_info = 'Eastern Time (US & Canada)'")
    execute("update hotels set tz_info = 'America/Chicago' where tz_info = 'Central Time (US & Canada)'")
    execute("update hotels set tz_info = 'America/Los_Angeles' where tz_info = 'Pacific Time (US & Canada)'")
  end
end
