# Return the checkout conversion details between the date range
class CheckoutConversionReport < ReportGenerator
  def process
    total_email_count = @hotel.actions.with_action_type(:EMAIL_CHECKOUT).search(@filter).count(:actionable_id, distinct: true)

    total_late_checkout_counts = @hotel.actions.with_action_type(:LATECHECKOUT).search(@filter).group_by_detail('index').count
    total_late_checkout_revenues = @hotel.actions.with_action_type(:LATECHECKOUT).search_all(@filter).group_by_detail('index').sum_details('charge')

    total_web_checkout_count = @hotel.actions.with_action_type(:CHECKEDOUT).with_application(:WEB).search(@filter).count

    # Paginate the months
    months = Kaminari.paginate_array(report_month_array(@filter)).page(@filter[:page]).per(@filter[:per_page])
    first_month, last_month = [months.first, months.last].sort { |a, b| a[:year] * 12 + a[:month] <=> b[:year] * 12 + b[:month] }

    unless @filter[:from_date].year == first_month[:year] && @filter[:from_date].month == first_month[:month]
      @filter[:from_date] = Date.new(first_month[:year], first_month[:month], 1)
    end

    unless @filter[:to_date].year == last_month[:year] && @filter[:to_date].month == last_month[:month]
      @filter[:to_date] = Date.new(last_month[:year], last_month[:month], 1) + 1.month - 1.day
    end

    email_counts = @hotel.actions.with_action_type(:EMAIL_CHECKOUT).search(@filter).group_by_month.count(:actionable_id, distinct: true)

    late_checkout_counts = @hotel.actions.with_action_type(:LATECHECKOUT).search_all(@filter).group_by_month.group_by_detail('index').count
    late_checkout_revenues = @hotel.actions.with_action_type(:LATECHECKOUT).search_all(@filter).group_by_month.group_by_detail('index')
      .sum_details('charge')

    web_checkout_counts = @hotel.actions.with_action_type(:CHECKEDOUT).with_application(:WEB).search(@filter).group_by_month.count

    times = @hotel.late_checkout_charges.order(:extended_checkout_time).pluck(:extended_checkout_time)

    time1 = times[0].andand.strftime('%l %p')
    time2 = times[1].andand.strftime('%l %p')
    time3 = times[2].andand.strftime('%l %p')

    headers = [
      nil,
      { value: :emails_sent },
      { value: [:late_checkout, time: time1], span: 3 },
      { value: [:late_checkout, time: time2], span: 3 },
      { value: [:late_checkout, time: time3], span: 3 },
      { value: :late_checkout_all, span: 3 },
      { value: :web_checkout_all, span: 3 }
    ]

    sub_headers = [nil, nil, :conversion_abbr, :count_abbr, :revenue_abbr, :conversion_abbr, :count_abbr, :revenue_abbr, :conversion_abbr,
                   :count_abbr, :revenue_abbr, :conversion_abbr, :count_abbr, :revenue_abbr, :total, :conversion_abbr]

    data = {
      email_counts: email_counts,
      late_checkout_counts: late_checkout_counts,
      late_checkout_revenues: late_checkout_revenues,
      web_checkout_counts: web_checkout_counts
    }

    results = map_checkout_conversion_report_data(months, data)

    total_data = {
      email_count: total_email_count,
      late_checkout_counts: total_late_checkout_counts,
      late_checkout_revenues: total_late_checkout_revenues,
      web_checkout_count: total_web_checkout_count,
      time1: time1,
      time2: time2,
      time3: time3
    }

    results_total_row = map_checkout_conversion_report_total_row(total_data)
    totals = map_checkout_conversion_report_totals(total_data)

    { headers: headers, sub_headers: sub_headers, results: results, results_total_row: results_total_row, totals: totals,
      total_count: months.total_count }
  end

 # Map checkout conversion report data for each month
  def map_checkout_conversion_report_data(months, data)
    months.map do |month|
      index = [month[:year], month[:month]]

      email_count = data[:email_counts][index] || 0

      late_checkout_count1 = data[:late_checkout_counts][index + ['0']] || 0
      late_checkout_count2 = data[:late_checkout_counts][index + ['1']] || 0
      late_checkout_count3 = data[:late_checkout_counts][index + ['2']] || 0

      late_checkout_count_all = late_checkout_count1 + late_checkout_count2 + late_checkout_count3

      late_checkout_revenue1 = data[:late_checkout_revenues][index + ['0']] || 0
      late_checkout_revenue2 = data[:late_checkout_revenues][index + ['1']] || 0
      late_checkout_revenue3 = data[:late_checkout_revenues][index + ['2']] || 0

      late_checkout_revenue_all = late_checkout_revenue1 + late_checkout_revenue2 + late_checkout_revenue3

      web_checkout_count = data[:web_checkout_counts][index] || 0

      [
        Date::MONTHNAMES[month[:month]] + ' ' + month[:year].to_s,
        email_count,
        conversion_percent(late_checkout_count1, email_count),
        late_checkout_count1,
        NumberUtility.default_amount_format(late_checkout_revenue1),
        conversion_percent(late_checkout_count2, email_count),
        late_checkout_count2,
        NumberUtility.default_amount_format(late_checkout_revenue2),
        conversion_percent(late_checkout_count3, email_count),
        late_checkout_count3,
        NumberUtility.default_amount_format(late_checkout_revenue3),
        conversion_percent(late_checkout_count_all, email_count),
        late_checkout_count_all,
        NumberUtility.default_amount_format(late_checkout_revenue_all),
        web_checkout_count,
        conversion_percent(web_checkout_count, email_count)
      ]
    end
  end

  # Map checkout conversion report totals row
  def map_checkout_conversion_report_total_row(data)
    email_count = data[:email_count] || 0

    late_checkout_count1 = data[:late_checkout_counts]['0'] || 0
    late_checkout_count2 = data[:late_checkout_counts]['1'] || 0
    late_checkout_count3 = data[:late_checkout_counts]['2'] || 0

    late_checkout_count_all = late_checkout_count1 + late_checkout_count2 + late_checkout_count3

    late_checkout_revenue1 = data[:late_checkout_revenues]['0'] || 0
    late_checkout_revenue2 = data[:late_checkout_revenues]['1'] || 0
    late_checkout_revenue3 = data[:late_checkout_revenues]['2'] || 0

    late_checkout_revenue_all = late_checkout_revenue1 + late_checkout_revenue2 + late_checkout_revenue3

    web_checkout_count = data[:web_checkout_count] || 0

    [
      email_count,
      conversion_percent(late_checkout_count1, email_count),
      late_checkout_count1,
      NumberUtility.default_amount_format(late_checkout_revenue1),
      conversion_percent(late_checkout_count2, email_count),
      late_checkout_count2,
      NumberUtility.default_amount_format(late_checkout_revenue2),
      conversion_percent(late_checkout_count3, email_count),
      late_checkout_count3,
      NumberUtility.default_amount_format(late_checkout_revenue3),
      conversion_percent(late_checkout_count_all, email_count),
      late_checkout_count_all,
      NumberUtility.default_amount_format(late_checkout_revenue_all),
      web_checkout_count,
      conversion_percent(web_checkout_count, email_count)
    ]
  end

  # Map checkout conversion report totals
  def map_checkout_conversion_report_totals(data)
    email_count = data[:email_count] || 0

    late_checkout_count1 = data[:late_checkout_counts]['0'] || 0
    late_checkout_count2 = data[:late_checkout_counts]['1'] || 0
    late_checkout_count3 = data[:late_checkout_counts]['2'] || 0

    late_checkout_count_all = late_checkout_count1 + late_checkout_count2 + late_checkout_count3

    late_checkout_revenue1 = data[:late_checkout_revenues]['0'] || 0
    late_checkout_revenue2 = data[:late_checkout_revenues]['1'] || 0
    late_checkout_revenue3 = data[:late_checkout_revenues]['2'] || 0

    late_checkout_revenue_all = late_checkout_revenue1 + late_checkout_revenue2 + late_checkout_revenue3

    web_checkout_count = data[:web_checkout_count] || 0

    [
      { label: :emails_sent, value: email_count },
      { label: :total_late_checkout_conversion, value: conversion_percent(late_checkout_count_all, email_count) },
      { label: :total_late_checkout_revenue, value: NumberUtility.default_amount_format(late_checkout_revenue_all) },
      { label: :total_web_checkout_count, value: web_checkout_count },
      { label: :total_web_checkout_conversion, value: conversion_percent(web_checkout_count, email_count) }
    ]
  end
end
