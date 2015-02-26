module SeedDefaultReports
  def create_reports_setup
    # Adding Master Table entries- Reports
    report1 = Report.create(title: 'Check In / Check Out',
                            sub_title: 'By Mobile Device',
                            description: 'Number of Check Ins and Check Outs through mobile devices by date range',
                            method: 'checkin_checkout_report')
    report2 = Report.create(title: 'Upsell',
                            sub_title: 'By Day / User',
                            description: 'Number of Upsells from one room type to the next level by day and by user',
                            method: 'upsell_report')
    report3 = Report.create(title: 'Late Check Out',
                            sub_title: 'By Day',
                            description: 'Number of Late Checkouts by day',
                            method: 'late_checkout_status_report')
    report4 = Report.create(title: 'Web Check Out Conversion',
                            sub_title: 'By Month',
                            description: 'Conversion details for late check out and web check out',
                            method: 'checkout_conversion_report')
    report5 = Report.create(title: 'Web Check In Conversion',
                            sub_title: 'By Month',
                            description: 'Conversion details for Web checkin',
                            method: 'checkin_conversion_report')
    report6 = Report.create(title: 'In-House Guests',
                            description: 'All In-House Guests',
                            method: 'in_house_guests_report')
    report7 = Report.create(title: 'Departure',
                            sub_title: 'By Date Range',
                            description: 'Departing Guests',
                            method: 'departure_report')
    report8 = Report.create(title: 'Arrival',
                            sub_title: 'By Date Range',
                            description: 'Arriving Guests',
                            method: 'arrival_report')
    report9 = Report.create(title: 'Cancellation & No Show',
                            sub_title: 'By Date Range',
                            description: 'All Cancelled & No Show Reservations',
                            method: 'cancelation_no_show_report')
    user_activity_report = Report.create(title: 'Login and out Activity',
                                         sub_title: 'By User',
                                         description: 'All user login and logout activity',
                                         method: 'user_activity_report')

    report_source_market = Report.create(title: 'Booking Source & Market Report',
                                         sub_title: 'By Date Range',
                                         description: 'Bookings by Source & Market and Date Range / Forecast & History',
                                         method: 'market_source_report')

    report_deposit_dueout = Report.create(title: 'Deposit Report',
                                         sub_title: 'By Date Range',
                                         description: 'Deposit due / paid by date',
                                         method: 'deposit_report')

    

    report_occupancy_revenue = Report.create(title: 'Occupancy & Revenue Summary',
                                             sub_title: 'By Date Range',
                                             description: 'Occupancy & Revenue Statistics by Day / Date Range by Market',
                                             method: 'occupancy_revenue_summary_report')

    # Filter for Checkin/Checkout Report
    if report1.filters.empty?
      report1.filters << Ref::ReportFilter[:DATE_RANGE]
      report1.filters << Ref::ReportFilter[:CICO]
      report1.filters << Ref::ReportFilter[:USER]
    end

    # Filter for Upsell Report
    if report2.filters.empty?
      report2.filters << Ref::ReportFilter[:DATE_RANGE]
      report2.filters << Ref::ReportFilter[:USER]
    end

    # Filter for Late Checkout Report
    if report3.filters.empty?
      report3.filters << Ref::ReportFilter[:DATE_RANGE]
      report3.filters << Ref::ReportFilter[:USER]
    end

    # Filter for Checkout Conversion Report
    report4.filters << Ref::ReportFilter[:DATE_RANGE] if report4.filters.empty?

    # Filter for Checkin Conversion Report
    report5.filters << Ref::ReportFilter[:DATE_RANGE] if report5.filters.empty?

    # Filter for In-House Guests Report
    if report6.filters.empty?
      report6.filters << Ref::ReportFilter[:INCLUDE_NOTES]
      report6.filters << Ref::ReportFilter[:VIP_ONLY]
      report6.filters << Ref::ReportFilter[:SHOW_GUESTS]
    end

    # Filter for Departure Report
    if report7.filters.empty?
      report7.filters << Ref::ReportFilter[:DATE_RANGE]
      report7.filters << Ref::ReportFilter[:INCLUDE_NOTES]
      report7.filters << Ref::ReportFilter[:VIP_ONLY]
      report7.filters << Ref::ReportFilter[:SHOW_GUESTS]
    end

    # Filter for Arrival Report
    if report8.filters.empty?
      report8.filters << Ref::ReportFilter[:DATE_RANGE]
      report8.filters << Ref::ReportFilter[:TIME_RANGE]
      report8.filters << Ref::ReportFilter[:INCLUDE_NOTES]
      report8.filters << Ref::ReportFilter[:VIP_ONLY]
      report8.filters << Ref::ReportFilter[:INCLUDE_CANCELED]
      report8.filters << Ref::ReportFilter[:SHOW_GUESTS]
    end

    # Filter for Cancelation & No Show Report
    if report9.filters.empty?
      report9.filters << Ref::ReportFilter[:DATE_RANGE]
      report9.filters << Ref::ReportFilter[:INCLUDE_CANCELED]
      report9.filters << Ref::ReportFilter[:INCLUDE_NO_SHOW]
      report9.filters << Ref::ReportFilter[:CANCELATION_DATE_RANGE]
    end

    if report_source_market.filters.empty?
      report_source_market.filters << Ref::ReportFilter[:DATE_RANGE]
      report_source_market.filters << Ref::ReportFilter[:ARRIVAL_DATE_RANGE]
      report_source_market.filters << Ref::ReportFilter[:INCLUDE_CANCELED]
      report_source_market.filters << Ref::ReportFilter[:INCLUDE_NO_SHOW]
      report_source_market.filters << Ref::ReportFilter[:INCLUDE_MARKET]
      report_source_market.filters << Ref::ReportFilter[:INCLUDE_SOURCE]
    end
    # Filter for User Activity Report
    if user_activity_report.filters.empty?
      user_activity_report.filters << Ref::ReportFilter[:ZEST]
      user_activity_report.filters << Ref::ReportFilter[:ZEST_WEB]
      user_activity_report.filters << Ref::ReportFilter[:ROVER]
      user_activity_report.filters << Ref::ReportFilter[:DATE_RANGE]
    end

    if report_deposit_dueout.filters.empty?
      report_deposit_dueout.filters << Ref::ReportFilter[:DEPOSIT_PAID]
      report_deposit_dueout.filters << Ref::ReportFilter[:DEPOSIT_DUE]
      report_deposit_dueout.filters << Ref::ReportFilter[:ARRIVAL_DATE_RANGE]
      report_deposit_dueout.filters << Ref::ReportFilter[:DEPOSIT_DATE_RANGE]
      report_deposit_dueout.filters << Ref::ReportFilter[:DEPOSIT_PAST]
    end

    # Filters for Occupancy & Revenue Report
    if report_occupancy_revenue.filters.empty?
      report_occupancy_revenue.filters << Ref::ReportFilter[:DATE_RANGE]
      report_occupancy_revenue.filters << Ref::ReportFilter[:INCLUDE_LAST_YEAR]
      report_occupancy_revenue.filters << Ref::ReportFilter[:INCLUDE_VARIANCE]
    end

    # Sortable Fields for Checkin/Checkout Report
    if report1.sortable_fields.empty?
      report1.sortable_fields << Ref::ReportSortableField[:DATE]
    end

    # Sortable Fields for Upsell Report
    if report2.sortable_fields.empty?
      report2.sortable_fields << Ref::ReportSortableField[:DATE]
      report2.sortable_fields << Ref::ReportSortableField[:USER]
    end

    # Sortable Fields for Late Checkout Report
    if report3.sortable_fields.empty?
      report3.sortable_fields << Ref::ReportSortableField[:DATE]
    end

    # Sortable Fields for Checkout Conversion Report
    report4.sortable_fields << Ref::ReportSortableField[:DATE] if report4.sortable_fields.empty?

    # Sortable Fields for Checkin Conversion Report
    report5.sortable_fields << Ref::ReportSortableField[:DATE] if report5.sortable_fields.empty?

    # Sortable fields for In-House Guests Report
    if report6.sortable_fields.empty?
      report6.sortable_fields << Ref::ReportSortableField[:ROOM]
      report6.sortable_fields << Ref::ReportSortableField[:NAME]
    end

    # Sortable fields for Departure Report
    if report7.sortable_fields.empty?
      report7.sortable_fields << Ref::ReportSortableField[:ROOM]
      report7.sortable_fields << Ref::ReportSortableField[:NAME]
      report7.sortable_fields << Ref::ReportSortableField[:DATE]
    end

    # Sortable fields for Arrival Report
    if report8.sortable_fields.empty?
      report8.sortable_fields << Ref::ReportSortableField[:ROOM]
      report8.sortable_fields << Ref::ReportSortableField[:NAME]
      report8.sortable_fields << Ref::ReportSortableField[:DATE]
    end

    # Sortable Fields for User Activity Report
    if user_activity_report.sortable_fields.empty?
      user_activity_report.sortable_fields << Ref::ReportSortableField[:DATE]
      user_activity_report.sortable_fields << Ref::ReportSortableField[:USER]
    end
    
    if report_deposit_dueout.sortable_fields.empty?
      report_deposit_dueout.sortable_fields << Ref::ReportSortableField[:NAME]
      report_deposit_dueout.sortable_fields << Ref::ReportSortableField[:DATE]
      report_deposit_dueout.sortable_fields << Ref::ReportSortableField[:RESERVATION]
      report_deposit_dueout.sortable_fields << Ref::ReportSortableField[:DUE_DATE_RANGE]
      report_deposit_dueout.sortable_fields << Ref::ReportSortableField[:PAID_DATE_RANGE]
    end

  end
end
