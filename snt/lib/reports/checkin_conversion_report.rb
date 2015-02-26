# Return the checkin conversion details between the date range
class CheckinConversionReport < ReportGenerator
  def process
    total_email_count = @hotel.actions.with_action_type(:EMAIL_CHECKIN).search(@filter).count(:actionable_id, distinct: true)

    total_upsell_counts = @hotel.actions.with_action_type(:UPSELL).search(@filter).group_by_old_and_new('level').count
    total_upsell_revenues = @hotel.actions.with_action_type(:UPSELL).search_all(@filter).group_by_old_and_new('level').sum_details('upsell')
    total_web_checkin_count = @hotel.actions.with_action_type(:CHECKEDIN).with_application(:WEB, :ZEST).search(@filter).count

    # Paginate the months
    months = Kaminari.paginate_array(report_month_array(@filter)).page(@filter[:page]).per(@filter[:per_page])
    first_month, last_month = [months.first, months.last].sort { |a, b| a[:year] * 12 + a[:month] <=> b[:year] * 12 + b[:month] }

    unless @filter[:from_date].year == first_month[:year] && @filter[:from_date].month == first_month[:month]
      @filter[:from_date] = Date.new(first_month[:year], first_month[:month], 1)
    end

    unless @filter[:to_date].year == last_month[:year] && @filter[:to_date].month == last_month[:month]
      @filter[:to_date] = Date.new(last_month[:year], last_month[:month], 1) + 1.month - 1.day
    end

    email_counts = @hotel.actions.with_action_type(:EMAIL_CHECKIN).search(@filter).group_by_month.count(:actionable_id, distinct: true)

    upsell_counts = @hotel.actions.with_action_type(:UPSELL).search_all(@filter).group_by_month.group_by_old_and_new('level').count
    upsell_revenues = @hotel.actions.with_action_type(:UPSELL).search_all(@filter).group_by_month.group_by_old_and_new('level').sum_details('upsell')

    web_checkin_counts = @hotel.actions.with_action_type(:CHECKEDIN).with_application(:WEB, :ZEST).search(@filter).group_by_month.count

    headers = [
      nil,
      { value: :emails_sent },
      { value: :upsell_level_1_level_2, span: 3 },
      { value: :upsell_level_1_level_3, span: 3 },
      { value: :upsell_level_2_level_3, span: 3 },
      { value: :all_upsells, span: 3 },
      { value: :web_checkin_all, span: 3 }
    ]

    sub_headers = [nil, nil, :conversion_abbr, :count_abbr, :revenue_abbr, :conversion_abbr, :count_abbr, :revenue_abbr, :conversion_abbr,
                   :count_abbr, :revenue_abbr, :conversion_abbr, :count_abbr, :revenue_abbr, :total, :conversion_abbr]

    data = {
      email_counts: email_counts,
      upsell_counts: upsell_counts,
      upsell_revenues: upsell_revenues,
      web_checkin_counts: web_checkin_counts
    }

    results = map_checkin_conversion_report_data(months, data)

    total_data = {
      email_count: total_email_count,
      upsell_counts: total_upsell_counts,
      upsell_revenues: total_upsell_revenues,
      web_checkin_count: total_web_checkin_count
    }

    results_total_row = map_checkin_conversion_report_total_row(total_data)
    totals = map_checkin_conversion_report_totals(total_data)

    { headers: headers, sub_headers: sub_headers, results: results, results_total_row: results_total_row, totals: totals,
      total_count: months.total_count }
  end


  # Map checkin conversion report data for each month
  def map_checkin_conversion_report_data(months, data)
    months.map do |month|
      index = [month[:year], month[:month]]

      email_count = data[:email_counts][index] || 0

      upsell_count1 = data[:upsell_counts][index + %W(1 2)] || 0
      upsell_count2 = data[:upsell_counts][index + %W(1 3)] || 0
      upsell_count3 = data[:upsell_counts][index + %W(2 3)] || 0

      upsell_count_all = upsell_count1 + upsell_count2 + upsell_count3

      upsell_revenue1 = data[:upsell_revenues][index + %W(1 2)] || 0
      upsell_revenue2 = data[:upsell_revenues][index + %W(1 3)] || 0
      upsell_revenue3 = data[:upsell_revenues][index + %W(2 3)] || 0

      upsell_revenue_all = upsell_revenue1 + upsell_revenue2 + upsell_revenue3

      web_checkin_count = data[:web_checkin_counts][index] || 0

      [
        Date::MONTHNAMES[month[:month]] + ' ' + month[:year].to_s,
        email_count,
        conversion_percent(upsell_count1, email_count),
        upsell_count1,
        NumberUtility.default_amount_format(upsell_revenue1),
        conversion_percent(upsell_count2, email_count),
        upsell_count2,
        NumberUtility.default_amount_format(upsell_revenue2),
        conversion_percent(upsell_count3, email_count),
        upsell_count3,
        NumberUtility.default_amount_format(upsell_revenue3),
        conversion_percent(upsell_count_all, email_count),
        upsell_count_all,
        NumberUtility.default_amount_format(upsell_revenue_all),
        web_checkin_count,
        conversion_percent(web_checkin_count, email_count)
      ]
    end
  end

  # Map checkin conversion report totals row
  def map_checkin_conversion_report_total_row(data)
    email_count = data[:email_count] || 0
    upsell_count1 = data[:upsell_counts][%W(1 2)] || 0
    upsell_count2 = data[:upsell_counts][%W(1 3)] || 0
    upsell_count3 = data[:upsell_counts][%W(2 3)] || 0

    upsell_count_all = upsell_count1 + upsell_count2 + upsell_count3

    upsell_revenue1 = data[:upsell_revenues][%W(1 2)] || 0
    upsell_revenue2 = data[:upsell_revenues][%W(1 3)] || 0
    upsell_revenue3 = data[:upsell_revenues][%W(2 3)] || 0

    upsell_revenue_all = upsell_revenue1 + upsell_revenue2 + upsell_revenue3

    web_checkin_count = data[:web_checkin_count] || 0

    [
      email_count,
      conversion_percent(upsell_count1, email_count),
      upsell_count1,
      NumberUtility.default_amount_format(upsell_revenue1),
      conversion_percent(upsell_count2, email_count),
      upsell_count2,
      NumberUtility.default_amount_format(upsell_revenue2),
      conversion_percent(upsell_count3, email_count),
      upsell_count3,
      NumberUtility.default_amount_format(upsell_revenue3),
      conversion_percent(upsell_count_all, email_count),
      upsell_count_all,
      NumberUtility.default_amount_format(upsell_revenue_all),
      web_checkin_count,
      conversion_percent(web_checkin_count, email_count)
    ]
  end

  # Map checkin conversion report totals
  def map_checkin_conversion_report_totals(data)
    email_count = data[:email_count] || 0

    upsell_count1 = data[:upsell_counts][%W(1 2)] || 0
    upsell_count2 = data[:upsell_counts][%W(1 3)] || 0
    upsell_count3 = data[:upsell_counts][%W(2 3)] || 0

    upsell_count_all = upsell_count1 + upsell_count2 + upsell_count3

    upsell_revenue1 = data[:upsell_revenues][%W(1 2)] || 0
    upsell_revenue2 = data[:upsell_revenues][%W(1 3)] || 0
    upsell_revenue3 = data[:upsell_revenues][%W(2 3)] || 0

    upsell_revenue_all = upsell_revenue1 + upsell_revenue2 + upsell_revenue3

    web_checkin_count = data[:web_checkin_count] || 0

    [
      { label: :emails_sent, value: email_count },
      { label: :total_upsell_conversion, value: conversion_percent(upsell_count_all, email_count) },
      { label: :total_upsell_revenues, value: NumberUtility.default_amount_format(upsell_revenue_all) },
      { label: :total_web_checkin_count, value: web_checkin_count },
      { label: :total_web_checkin_conversion, value: conversion_percent(web_checkin_count, email_count) }
    ]
  end
end
