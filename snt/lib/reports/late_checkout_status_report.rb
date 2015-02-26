# Return the late checkout details between the date range
class LateCheckoutStatusReport < ReportGenerator
  def process
    late_checkout_actions = @hotel.actions.with_action_type(:LATECHECKOUT).search(@filter).page(@filter[:page]).per(@filter[:per_page])
    total_rooms = late_checkout_actions.total_count.to_s
    total_revenue = NumberUtility.default_amount_format(@hotel.actions.with_action_type(:LATECHECKOUT).search_all(@filter).sum_details('charge'))

    headers = [:date, :guest_name, :late_check_out_time, :late_check_out_charge]

    results = late_checkout_actions.map do |action|
      [
        ApplicationController.helpers.formatted_date(action.business_date),
        action.actionable.primary_guest.full_name,
        action.new_value('time'),
        NumberUtility.default_amount_format(action.new_value('charge'))
      ]
    end

    totals = [
      { label: :late_check_out_rooms, value: total_rooms },
      { label: :late_check_out_revenue, value: total_revenue }
    ]

    { headers: headers, results: results, totals: totals, total_count: late_checkout_actions.total_count }
  end
end
