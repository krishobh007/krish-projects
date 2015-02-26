# Return the upsell details between the date range and/or for the provided user name
class UpsellReport < ReportGenerator
  def process
    upsell_actions = @hotel.actions.with_action_type(:UPSELL).search(@filter).page(@filter[:page]).per(@filter[:per_page])
    total_rooms = upsell_actions.total_count.to_s
    total_revenue = NumberUtility.default_amount_format(@hotel.actions.with_action_type(:UPSELL).search_all(@filter).sum_details('upsell'))

    headers = [:date, :guest_name, :from_room_type, :from_level, :to_room_type, :to_level, :original_rate_price, :upsell_amount]

    results = upsell_actions.map do |action|
      [
        ApplicationController.helpers.formatted_date(action.business_date),
        action.actionable.primary_guest.full_name,
        action.old_value('room_type'),
        action.old_value('level'),
        action.new_value('room_type'),
        action.new_value('level'),
        NumberUtility.default_amount_format(action.old_value('amount')),
        NumberUtility.default_amount_format(action.new_value('upsell'))
      ]
    end

    totals = [
      { label: :rooms_upsold, value: total_rooms },
      { label: :upsell_revenue, value: total_revenue }
    ]

    { headers: headers, results: results, totals: totals, total_count: upsell_actions.total_count }
  end
end
