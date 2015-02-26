module SeedYotelPrinterTemplates
  # encoding: utf-8
  def create_yotel_printer_templates ( yotel = nil )
  	yotel = Hotel.first unless yotel
    checkin_bill_template = yotel.printer_templates.create(template: "\x1b\x1d\x61\x0 $bill_date_time$ \n\x1b\x1d\x61\x1\x1B\x1C\x70" + "$logo_index$" + "\x0\n\x1b\x1d\x61\x0YOUR CABIN NUMBER IS\n\n\x6\x9\x1b\x69\x1\x1" +
						                                             "$room_number$ \n\n" + "\x1b\x69\x0\x0" + "Date of departure : $departure_date$ \nOur standard check out is $normal_checkout_time$\n\n" +
						                                             "YOTEL is 100% non-smoking, including all of our public spaces.\nThere is a fee of $250 if you chose to smoke, an expensive cigarette!\n\n" +
						                                             "Complimentary coffe and muffins on FOUR between 7am and 10am\n(10.30 weekends).  Complimentary tea/coffee/purified water/ice\nin the Galley on your floor" +
						                                             "(24/7).\n\n" + "Our concierge team on FOUR can assist you with many services\nincluding theater tickets, sightseeing tours, transportation to \nand from " +
						                                             "local airports," + " restaurant reservations, florists, and more.\n\n" + "\x1b\x69\x1\x1NOW TAKE THE ELEVATORS TO \"FOUR\"\n\x1b\x69\x0\x0\x1b\x64\x02\x7",
                                            			   template_type: Setting.printer_template_types[:checkin] )

    checkout_bill_template = yotel.printer_templates.create(template: "\x1b\x1d\x61\x0" + "$hotel_name$\n$street$\n$city$\n$state$ $zip_code$" + "\n" +  
															          "\x1b\x1d\x61\x1" + "\x1B\x1C\x70" + "$logo_index$" + "\x0" + "\x1b\x1d\x61\x0" + 
															          "\n\n\nINVOICE\n\n" + "$guest_title$ $guest_full_name$\n$guest_street$\n$guest_state$\n$guest_city$\n$guest_zip_code$" +
															          "\n\n" + "CABIN:                    " + "$room_number$" + "\n" +"ARRIVAL:                  " + "$arrival_date$" + "\n" +
															          "DEPARTURE:                " + "$departure_date$" + "\n" +"GUESTS:                   " + "$total_guests$" + "\n\n" +
															          "Date       Description                             Credit       Debit\n" +"$transaction_details$" +  "\n\nBalance to pay     " + 
															          "$balance_amount$" + "\n" + "\x1b\x64\x02" + "\x7",
															template_type: Setting.printer_template_types[:checkout] )

  end
end