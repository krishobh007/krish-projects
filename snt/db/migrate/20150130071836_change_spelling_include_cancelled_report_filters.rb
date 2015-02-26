class ChangeSpellingIncludeCancelledReportFilters < ActiveRecord::Migration
  def change
    execute("update ref_report_filters set description = 'Include Cancelled' where value = 'INCLUDE_CANCELED'")
  end
end
