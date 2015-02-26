# Return the checked-in and checked-out counts for each date for all application between the date range
class CheckinCheckoutReport < ReportGenerator
  def process
    total_counts = @hotel.actions.with_action_type(:CHECKEDIN, :CHECKEDOUT).search(@filter).group_by_type_app.count

    # Paginate the dates
    dates = Kaminari.paginate_array(report_date_array(@filter)).page(@filter[:page]).per(@filter[:per_page])
    @filter[:from_date], @filter[:to_date] = [dates.first, dates.last].sort

    counts = @hotel.actions.with_action_type(:CHECKEDIN, :CHECKEDOUT).search(@filter).group_by_type_app_date.count

    headers = [:date]

    if @filter[:checked_in]
      headers += [:total_check_ins, :via_rover, :via_web, :via_zest]
    end

    if @filter[:checked_out]
      headers += [:total_check_outs, :via_rover, :via_web, :via_zest]
    end

    results = map_checkin_checkout_report_data(dates, @filter, counts)
    totals = map_checkin_checkout_report_totals(@filter, total_counts)

    { headers: headers, results: results, totals: totals, total_count: dates.total_count }
  end

  # Map checkin-checkout report data for each date between from_date and to_date
  def map_checkin_checkout_report_data(dates, filter, counts)
    dates.map do |date|
      result = [ApplicationController.helpers.formatted_date(date)]

      if filter[:checked_in]
        rover_checkedin_count = counts[[Ref::ActionType[:CHECKEDIN].id, Ref::Application[:ROVER].id, date]] || 0
        zest_checkedin_count = counts[[Ref::ActionType[:CHECKEDIN].id, Ref::Application[:ZEST].id, date]] || 0
        web_checkedin_count = counts[[Ref::ActionType[:CHECKEDIN].id, Ref::Application[:WEB].id, date]] || 0
        total_checkins = rover_checkedin_count + zest_checkedin_count + web_checkedin_count
        result += [total_checkins, rover_checkedin_count, web_checkedin_count, zest_checkedin_count]
      end

      if filter[:checked_out]
        rover_checkedout_count = counts[[Ref::ActionType[:CHECKEDOUT].id, Ref::Application[:ROVER].id, date]] || 0
        zest_checkedout_count = counts[[Ref::ActionType[:CHECKEDOUT].id, Ref::Application[:ZEST].id, date]] || 0
        web_checkedout_count = counts[[Ref::ActionType[:CHECKEDOUT].id, Ref::Application[:WEB].id, date]] || 0
        total_checkouts = rover_checkedout_count + zest_checkedout_count + web_checkedout_count
        result += [total_checkouts, rover_checkedout_count, web_checkedout_count, zest_checkedout_count]
      end

      result
    end
  end

  # Map checkin-checkout report totals
  def map_checkin_checkout_report_totals(filter, counts)
    totals = []

    if filter[:checked_in]
      rover_checkedin_count = counts[[Ref::ActionType[:CHECKEDIN].id, Ref::Application[:ROVER].id]] || 0
      zest_checkedin_count = counts[[Ref::ActionType[:CHECKEDIN].id, Ref::Application[:ZEST].id]] || 0
      web_checkedin_count = counts[[Ref::ActionType[:CHECKEDIN].id, Ref::Application[:WEB].id]] || 0
      total_checkins = rover_checkedin_count + web_checkedin_count + zest_checkedin_count

      totals += [
        { label: :total_check_ins, value: total_checkins },
        { label: :via_rover, value: rover_checkedin_count },
        { label: :via_web, value: web_checkedin_count },
        { label: :via_zest, value: zest_checkedin_count }
      ]
    end

    if filter[:checked_out]
      rover_checkedout_count = counts[[Ref::ActionType[:CHECKEDOUT].id, Ref::Application[:ROVER].id]] || 0
      zest_checkedout_count = counts[[Ref::ActionType[:CHECKEDOUT].id, Ref::Application[:ZEST].id]] || 0
      web_checkedout_count = counts[[Ref::ActionType[:CHECKEDOUT].id, Ref::Application[:WEB].id]] || 0
      total_checkouts = rover_checkedout_count + web_checkedout_count + zest_checkedout_count

      totals += [
        { label: :total_check_outs, value: total_checkouts },
        { label: :via_rover, value: rover_checkedout_count },
        { label: :via_web, value: web_checkedout_count },
        { label: :via_zest, value: zest_checkedout_count }
      ]
    end
    totals
  end
end
