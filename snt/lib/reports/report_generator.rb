class ReportGenerator
  def initialize(hotel, filter)
    @hotel = hotel
    @filter = filter
    @sort_order = @filter[:sort_dir] ? 'asc' : 'desc'
  end

  # Returns an array of sorted dates
  def report_date_array(filter)
    date_range_array = (filter[:from_date]..filter[:to_date]).to_a
    date_range_array = date_range_array.reverse unless filter[:sort_dir]
    date_range_array
  end

  # Returns an array of sorted months
  def report_month_array(filter)
    months = (filter[:from_date]..filter[:to_date]).map { |date| { year: date.year, month: date.month } }.uniq
    months = months.reverse unless filter[:sort_dir]
    months
  end

  def conversion_percent(numerator, denominator)
    if !denominator || denominator == 0
      'N/A'
    else
      format('%.2f', numerator / denominator.to_f * 100) + '%'
    end
  end
end
