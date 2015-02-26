# Return the departure guests
class DepartureReport < GuestsReport
  def process
    reservations = reservations_query.with_status(:RESERVED, :CHECKEDIN)
      .where('? <= dep_date and dep_date <= ?', @filter[:from_date], @filter[:to_date])
      .where('reservation_daily_instances.reservation_date = dep_date')

    # Sort by departure date if sort field is DATE
    reservations = reservations.order("dep_date #{@sort_order}, departure_time #{@sort_order}") if @filter[:sort_field] == 'DATE'

    output_report(reservations)
  end
end
