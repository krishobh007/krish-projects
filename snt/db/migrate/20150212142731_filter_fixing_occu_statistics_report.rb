class FilterFixingOccuStatisticsReport < ActiveRecord::Migration
  def change

    Ref::ReportFilter.enumeration_model_updates_permitted = true

    Ref::ReportFilter.create(value: 'INCLUDE_LAST_YEAR', description: 'Include Last Year')
    Ref::ReportFilter.create(value: 'INCLUDE_VARIANCE', description: 'Include Variance')

    report_occupancy = Report.find_by_title('Occupancy & Revenue Summary')

    report_occupancy = Report.create(title: 'Occupancy & Revenue Summary',
                                             sub_title: 'By Date Range',
                                             description: 'Occupancy & Revenue Statistics by Day / Date Range by Market',
                                             method: 'occupancy_revenue_summary_report') if !report_occupancy

    if report_occupancy
      report_occupancy.filters = []
      report_occupancy.sortable_fields = []
      report_occupancy.filters << Ref::ReportFilter[:DATE_RANGE]
      report_occupancy.filters << Ref::ReportFilter[:INCLUDE_LAST_YEAR]
      report_occupancy.filters << Ref::ReportFilter[:INCLUDE_VARIANCE]
    end

  end
end
