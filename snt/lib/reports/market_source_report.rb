# Return the arrival guests
class MarketSourceReport < ReportGenerator
  def process

    # Construct the initial query for reservations
    reservations_query =  @hotel.reservations.page(@filter[:page]).per(@filter[:per_page])

    # Booked Date
    if @filter[:from_date].present? && @filter[:to_date].present?
      reservations = reservations_query.where('? <= DATE(reservations.created_at) and DATE(reservations.created_at) <= ?', @filter[:from_date], @filter[:to_date])
    end

    # Arrival Date
    if @filter[:arrival_from_date].present? && @filter[:arrival_to_date].present?
      reservations = reservations_query.where('? <= arrival_date and arrival_date <= ?', @filter[:arrival_from_date], @filter[:arrival_to_date])
    end

    # Determine whether to include the canceled reservations or not
    # Nicole Comment  Friday, 30 January 2015:
    # if user doesn't select any filter we show all reservations that do not have status CANCELLED or NO SHOW
    # [21:06:43] Nicki Dehler: if user opts INCLUDE NO SHOW
    # [21:06:54] Nicki Dehler: we show all reservations of all statuses less CANCELLED
    # [21:07:01] Nicki Dehler: and if user opts include Canclled
    # [21:07:10] Nicki Dehler: we show all reservations of all statuses less NO SHOW
    # [21:07:20] Nicki Dehler: and if user selects both, we will show everything
    if @filter[:include_canceled] && @filter[:include_no_show]
      reservations = reservations
    elsif @filter[:include_no_show]
      reservations = reservations.exclude_status(:CANCELED)
    elsif @filter[:include_canceled]
      reservations = reservations.exclude_status(:NOSHOW)
    else
      reservations = reservations.exclude_status(:CANCELED, :NOSHOW)
    end
    # Determine & Group By whether to include Market Segment or Source or both
    reservations_market_segment_hash = reservations.includes(:market_segment).group('market_segments.name').count if @filter[:include_market]
    reservations_sources_hash = reservations.includes(:source).group('sources.code').count if @filter[:include_source]
    total_count = reservations.total_count
    # Sort by arrival date if sort field is DATE
    # reservations = reservations.order("arrival_date #{@sort_order}, arrival_time #{@sort_order}") if @filter[:sort_field] == 'DATE'
    # output_report(reservations)
    output_report(reservations_market_segment_hash, reservations_sources_hash, total_count)
  end

  def output_report(market_segments_hash, sources_hash, total_count)
    { headers: [], results: construct_results(market_segments_hash, sources_hash), totals: [], total_count: total_count }
  end

  # Construct the results using the provided list of reservations
  def construct_results(market_segments_hash, sources_hash)
    result = {}
    market_segments_hash['Not Defined'] = market_segments_hash.delete(nil) if market_segments_hash && @filter[:include_market]
    sources_hash['Not Defined'] = sources_hash.delete(nil) if sources_hash && @filter[:include_source]
    result[:market] =  market_segments_hash
    result[:source] =  sources_hash


    result
  end
end
