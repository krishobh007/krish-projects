class RenameHouseKeepingDashboard < ActiveRecord::Migration
  def change
    execute('update ref_dashboards set value="HOUSEKEEPING", description="Housekeeping" where value="HOUSE_KEEPING"')
  end
end
