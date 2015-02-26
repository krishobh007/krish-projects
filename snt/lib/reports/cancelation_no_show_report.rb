# Return the cancelation and no show guests
class CancelationNoShowReport < GuestsReport
  def process
    # Construct the initial query for reservations
    reservations = reservations_query(false, false, true).where('reservation_daily_instances.reservation_date = arrival_date')

    if @filter[:from_date].present? && @filter[:to_date].present?
      reservations = reservations.where('? <= arrival_date and arrival_date <= ?', @filter[:from_date], @filter[:to_date])
    end

    if @filter[:cancel_from_date].present? && @filter[:cancel_to_date].present?
      reservations = reservations.where('? <= cancel_date and cancel_date <= ?', @filter[:cancel_from_date], @filter[:cancel_to_date])
    end

    # Determine whether to include the canceled or no show reservations
    if @filter[:include_canceled] && @filter[:include_no_show]
      reservations = reservations.with_status(:CANCELED, :NOSHOW)
    elsif @filter[:include_canceled]
      reservations = reservations.with_status(:CANCELED)
    elsif @filter[:include_no_show]
      reservations = reservations.with_status(:NOSHOW)
    else
      reservations = reservations.with_status(nil)
    end

    # Sort by arrival date if sort field is DATE
    reservations = reservations.order('arrival_date asc, cancel_date asc')
    sub_headers = [:cancellation_date_and_amount, :guest_name, :arrival, :departure, :rate]
    
    output_report(reservations, nil, nil, sub_headers)
  end
end
