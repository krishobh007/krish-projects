class ViewMappings::Kiosk::BillDetailsMapping
  
  def self.map_kiosk_bill_details(print_template, reservation)
    guest_detail = reservation.primary_guest
    primary_address = guest_detail.addresses.primary.first
    template = print_template.template
    current_daily_instance = reservation.current_daily_instance
    hotel = reservation.hotel
  	business_date_time = DateTime.strptime(hotel.active_business_date.strftime("%Y %m %d ") + Time.now.utc.in_time_zone(reservation.hotel.tz_info).strftime("%H %M %S %:z"),'%Y %m %d %H %M %S %z')
  	room = reservation.current_daily_instance.andand.room
    if print_template.template_type == Setting.printer_template_types[:checkin]
    	template = template.gsub("$bill_date_time$",business_date_time.strftime("%d-%b %Y %H:%M").to_s)
				.gsub("$room_number$", room.andand.room_no.to_s)
				.gsub("$departure_date$", reservation.dep_date.strftime("%d-%b %Y").to_s)
				.gsub("$normal_checkout_time$", hotel.checkout_time.strftime("%I:%M %P").to_s)
				.gsub("$logo_index$", hotel.settings.bill_logo_index.to_s)
    elsif print_template.template_type == Setting.printer_template_types[:checkout]
      transaction_details = map_transaction_details_from_bill_details(reservation)
      template = template.gsub("$hotel_name$",hotel.name.to_s)
        .gsub("$street$", hotel.street.to_s)
        .gsub("$city$", hotel.city.to_s)
        .gsub("$state$", hotel.state.to_s)
        .gsub("$zip_code$", hotel.zipcode.to_s)
        .gsub("$logo_index$", reservation.hotel.settings.bill_logo_index.to_s)
        .gsub("$guest_title$", guest_detail.andand.title.to_s)
        .gsub("$guest_full_name$", guest_detail.andand.full_name.to_s)
        .gsub("$guest_street$", primary_address.andand.street1.to_s)
        .gsub("$guest_state$", primary_address.andand.state.to_s)
        .gsub("$guest_city$", primary_address.andand.state.to_s)
        .gsub("$guest_zip_code$", primary_address.andand.postal_code.to_s)
        .gsub("$room_number$", current_daily_instance.andand.room.andand.room_no.to_s)
        .gsub("$arrival_date$", reservation.arrival_date.strftime("%d-%b %Y").to_s)
        .gsub("$departure_date$", reservation.dep_date.strftime("%d-%b %Y").to_s)
        .gsub("$total_guests$", (reservation.accompanying_guests.count+1).to_s)
        .gsub("$balance_amount$", reservation.current_balance.to_s)
        .gsub("$transaction_details$", transaction_details.to_s)
    end
    template
  end

  def self.map_transaction_details_from_bill_details(reservation)
    txn_text = ""
    fee_details = reservation.guest_bill_details["fee_details"]
    fee_details.each do |fee_detail_per_date|
      txn_date = fee_detail_per_date["print_date"]
      charge_details = fee_detail_per_date["charge_details"]
      credit_details = fee_detail_per_date["credit_details"]
      charge_details.each do |charge|
        txn_text += txn_date.to_s.ljust(11,' ') + line_wrap_text(charge["description"], 35).to_s.ljust(35,' ') + charge["amount"].to_s.rjust(23,' ') + "\n"
      end
      credit_details.each do |credit|
        txn_text += txn_date.to_s.ljust(11,' ') + line_wrap_text(credit["description"], 35).to_s.ljust(35,' ') + ("-" + credit["amount"].to_s).rjust(11,' ') + "\n"
      end
    end
    txn_text
  end

  def self.line_wrap_text(line_text, max_length)
    if line_text.to_s.length > max_length
      line_text = line_text.to_s[0..-(line_text.to_s.length - max_length + 3)] + ".."
    end
    line_text
  end

end