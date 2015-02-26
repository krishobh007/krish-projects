class InsertFilterNoShowInArrivalReport < ActiveRecord::Migration
  def change
    Ref::ReportFilter.enumeration_model_updates_permitted = true

    arrival_report = Report.find_by_title('Arrival')
    arrival_report.filters << Ref::ReportFilter[:INCLUDE_NO_SHOW]
  end
end
