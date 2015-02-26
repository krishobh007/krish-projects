class AddColumnDayOfWeekInCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :day_of_week, :string
  end
end
