class ViewMappings::GuestWeb::WebCheckoutMapping
  extend ApplicationHelper
  def self.map_web_checkout_index(reservation)
    primary_address = reservation.primary_guest.addresses.first
    {
      hotel_name: reservation.hotel.name,
      reservation_id: reservation.id.to_s,
      email_address: reservation.primary_guest.email,
      user_name: reservation.primary_guest.full_name,
      state: primary_address.andand.state.to_s,
      city: primary_address.andand.city.to_s,
      is_late_checkout_available: reservation.is_late_checkout_available? ? 'true' : 'false',
      checkout_time: !reservation.is_opted_late_checkout ?  reservation.hotel.andand.checkout_time.andand.in_time_zone(reservation.hotel.tz_info).andand.strftime('%I:%M %P') : reservation.andand.late_checkout_time.andand.strftime('%I:%M %P'),
      checkout_date: formatted_date(reservation.dep_date)
    }
  end

  def self.map_late_checkout_charges(late_checkout_data)
    checkout_charges = []
    late_checkout_data.each_with_index do |data, index|
      checkout_charge = map_checkout_charge(data, index)
      checkout_charges << checkout_charge
    end
    checkout_charges
  end

  def self.map_checkout_charge(data, index)
    {
      'id' => data['id'].to_s,
      'class' => 'checkouttime' + (index + 1).to_s,
      'time' => data['extended_checkout_time'].strftime('%I'),
      'ap' => data['extended_checkout_time'].strftime('%p'),
      'amount' => data['extended_checkout_charge']
    }
  end
end
