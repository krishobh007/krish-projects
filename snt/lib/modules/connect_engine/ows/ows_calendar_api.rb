class OwsCalendarApi
  # Fetch the guest information from OWS
  def self.fetch_calendar(hotel_id, start_date, end_date, adult_count, child_count, room_type, rate_plan_code)
    availability_service = OwsAvailabilityService.new(hotel_id)

    message = OwsMessage.new

    # Sending start_date and end_date
    message.append_fetch_calendar_attributes(hotel_id, start_date, end_date)

    # Sending adult_count and child_count
    message.append_fetch_calendar_guest_count(adult_count, child_count)

    # Sending room_type and rate_plan_code
    message.append_fetch_calendar_room_type_attribute(room_type, rate_plan_code)

    # Calling the availability Service API in SOAP
    availability_service.fetch_calendar message, '//FetchCalendarResponse', lambda { |operation_response|
      operation_response.xpath('Calendar/CalendarDay').map do |each_calendar_day|
        {
          calendar_date: Date.parse(each_calendar_day.xpath('@Date').text),
          restriction_list: get_restriction_list_map(each_calendar_day.xpath('Rates/RestrictionList')),
          rate_list: get_rate_list_map(each_calendar_day.xpath('Rates/RateList')),
          occupancy_list: get_occupancy_map(each_calendar_day.xpath('Occupancy'))
        }
      end
    }
  end

  # Parsing Resctriction List
  def self.get_restriction_list_map(restriction_tag)
    restriction_tag.xpath('Restriction').map do |restriction|
      {
        restriction_type: restriction.xpath('@restrictionType').text,
        number_of_days: restriction.xpath('@numberOfDays').text,
        room_type_code: restriction.xpath('@roomType').text,
        rate_plan_code: restriction.xpath('@rateCode').text
      }
    end
  end

  # Parsing Rate List for each day
  def self.get_rate_list_map(rate_tag)
    rate_tag.xpath('Rate').map do |rate|
      {
        room_type_code: rate.xpath('@roomTypeCode').text,
        rate_plan_code: rate.xpath('@ratePlanCode').text,
        has_package: rate.xpath('@hasPackage').text,
        currency_code: rate.xpath('Rates/Rate/Base/@currencyCode').text,
        rate_amount: rate.xpath('Rates/Rate/Base').text,
        addtional_guest_list: get_addtional_guest_amounts(rate.xpath('Rates/Rate/AdditionalGuestAmounts'))
      }
    end
  end

  # Parsing Occupancy List for each day
  def self.get_occupancy_map(occupancy_tag)
    occupancy_tag.xpath('RoomTypeInventory').map do |occupancy|
      {
        room_type_code: occupancy.xpath('@roomTypeCode').text,
        total_rooms: occupancy.xpath('@totalRooms').text,
        over_booking_limit: occupancy.xpath('@overBookingLimit').text,
        total_available_rooms: occupancy.xpath('@totalAvailableRooms').text
      }
    end
  end

  def self.get_addtional_guest_amounts(additional_guest_amounts_tag)
    additional_guest_amounts_tag.xpath('AdditionalGuestAmount').map do |additional_guest|
      {
        guest_type: additional_guest.xpath('@additionalGuestType').text,
        guest_currency_code: additional_guest.xpath('Amount/@currencyCode').text,
        guest_amount: additional_guest.xpath('Amount').text
      }
    end
  end
end
