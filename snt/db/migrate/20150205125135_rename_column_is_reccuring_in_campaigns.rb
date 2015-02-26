class RenameColumnIsReccuringInCampaigns < ActiveRecord::Migration
  def change
    rename_column :campaigns, :is_reccuring, :is_recurring
  end
end
