class InsertShowGuestFilterInReports < ActiveRecord::Migration
  def change
    Ref::ReportFilter.enumeration_model_updates_permitted = true
    Ref::ReportFilter.create(value: 'SHOW_GUESTS', description: 'Show Guests')

    arrival_report = Report.find_by_title('Arrival')
    arrival_report.filters << Ref::ReportFilter[:SHOW_GUESTS]

    inhouse_report = Report.find_by_title('In-House Guests')
    inhouse_report.filters << Ref::ReportFilter[:SHOW_GUESTS]

    dep_report = Report.find_by_title('Departure')
    dep_report.filters << Ref::ReportFilter[:SHOW_GUESTS]
  end
end
