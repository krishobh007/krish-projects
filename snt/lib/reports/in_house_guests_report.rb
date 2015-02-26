# Return the in house guests
class InHouseGuestsReport < GuestsReport
  def process
    reservations = reservations_query(false, true, false).with_status(:CHECKEDIN).where('reservation_daily_instances.reservation_date = ?', @hotel.active_business_date)
    output_report(reservations)
  end
end
