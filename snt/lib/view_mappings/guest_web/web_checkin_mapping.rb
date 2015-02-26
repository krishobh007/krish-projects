class ViewMappings::GuestWeb::WebCheckinMapping
  def self.map_web_checkin_reservation_details(reservation)
    {
      is_rate_suppressed: reservation.is_rate_suppressed.to_s,
      is_upgrades_available: reservation.current_daily_instance.andand.room_type.andand.upsell_available?(reservation).to_s,
      reservation_id: reservation.id.to_s,
      confirm_no: reservation.confirm_no.to_s,
      departure_date: reservation.dep_date.andand.strftime('%b. %d, %Y'),
      arrival_date: reservation.arrival_date.andand.strftime('%b. %d, %Y'),
      room_type: reservation.current_daily_instance.andand.room_type.andand.room_type_name.to_s,
      room_rate: reservation.current_daily_instance.andand.rate.andand.rate_desc.to_s,
      currency: reservation.current_daily_instance.currency_code ? get_currency_symbol(reservation.current_daily_instance.currency_code.value).to_s : "",
      avg_rate: reservation.average_rate_amount.to_s
    }
  end

  def self.get_currency_symbol(currency_code)
    currency_symbol_hash = { 'USD' => '$' }
    currency_symbol = currency_symbol_hash.key?(currency_code) ? currency_symbol_hash.fetch(currency_code) : currency_code
    currency_symbol
  end

  def self.get_date_format(date_format)
    if date_format
      {
        id: date_format.andand.id,
        value: date_format.andand.value.to_s
      }
    else
      {}
    end
  end
end
