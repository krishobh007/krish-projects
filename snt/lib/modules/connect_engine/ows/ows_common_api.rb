class OwsCommonApi
  def self.parse_check_out_response(hotel_id, check_out_tag)
    check_out_guest = {}

    # get the reservation information
    check_out_guest[:resv_name_id] = check_out_tag.xpath('ReservationID/UniqueID[1]').text

    room_tag = check_out_tag.xpath('Room')

    # get the room no
    check_out_guest[:room_number] = room_tag.xpath('RoomNumber').text

    # get room type text from room description tag
    check_out_guest[:room_description_text] = room_tag.xpath('RoomDescription/Text').text

    # get room type code from room type tag
    check_out_guest[:room_type] = RoomType.where(hotel_id: hotel_id, room_type: room_tag.xpath('RoomType/@roomTypeCode').text).first.andand.id

    check_out_guest[:key1_track] = check_out_tag.xpath('KeyTrack/@key1Track').text
    check_out_guest[:key2_track] = check_out_tag.xpath('KeyTrack/@key2Track').text
    check_out_guest[:key3_track] = check_out_tag.xpath('KeyTrack/@key3Track').text
    check_out_guest[:key4_track] = check_out_tag.xpath('KeyTrack/@key4Track').text

    check_out_guest
  end
  # Parse the checkin response and return a hash of the information
  def self.parse_checkin_response(hotel_id, check_in_tag)
    checkin_guest = {}

    # get the reservation information
    checkin_guest[:resv_name_id] = check_in_tag.xpath('ReservationID/UniqueID[1]').text

    room_tag = check_in_tag.xpath('Room')

    # get the room no
    checkin_guest[:room_number] = room_tag.xpath('RoomNumber').text

    # get room type text from room description tag
    checkin_guest[:room_description_text] = room_tag.xpath('RoomDescription/Text').text

    # get room type code from room type tag
    checkin_guest[:room_type] = RoomType.where(hotel_id: hotel_id, room_type: room_tag.xpath('RoomType/@roomTypeCode').text).first.andand.id

    checkin_guest[:key1_track] = check_in_tag.xpath('KeyTrack/@key1Track').text
    checkin_guest[:key2_track] = check_in_tag.xpath('KeyTrack/@key2Track').text
    checkin_guest[:key3_track] = check_in_tag.xpath('KeyTrack/@key3Track').text
    checkin_guest[:key4_track] = check_in_tag.xpath('KeyTrack/@key4Track').text

    checkin_guest
  end

  # Parse the guest response and return a hash of the information
  def self.parse_guest_response(hotel_id, profile_tag)
    guest = {}

    hotel = Hotel.find(hotel_id)

    # Guest id
    guest[:guest_id] = profile_tag.xpath('ProfileIDs/UniqueID[@type="INTERNAL"][1]').text

    # Capture Language Code
    guest[:language] = profile_tag.xpath('@languageCode').text

    # Nationality
    guest[:nationality] = profile_tag.xpath('@nationality').text

    # VIP Code
    guest[:vip] = profile_tag.xpath('@vipCode').text

    # Customer Tag
    customer_tag = profile_tag.xpath('Customer')

    # Passport
    passport_tag = customer_tag.xpath('GovernmentIDList/GovernmentID[@documentType="Passport"][1]')
    guest[:passport_no] = passport_tag.xpath('@documentNumber').text
    guest[:passport_expiry] = passport_tag.xpath('@expirationDate').text

    # Birthday
    guest[:birthday] = customer_tag.xpath('@birthDate').text

    # Name tag
    name_tag = customer_tag.xpath('PersonName')
    guest[:title] = name_tag.xpath('nameTitle').text
    guest[:first_name] = name_tag.xpath('firstName').text
    guest[:last_name] = name_tag.xpath('lastName').text
    guest[:gender] = name_tag.xpath('@gender').text

    # Payment Types (Credit Cards)
    guest[:payment_types] = []
    profile_tag.xpath('CreditCards/NameCreditCard[@cardType="CREDIT"]').each do |credit_card_tag|
      mapped_card_type = ExternalMapping.map_external_value(hotel, credit_card_tag.xpath('cardCode').text, Setting.mapping_types[:credit_card_type])

      payment_type = {
        payment_type: PaymentType.credit_card,
        credit_card_type: mapped_card_type,
        card_expiry: credit_card_tag.xpath('expirationDate').text,
        is_primary: credit_card_tag.xpath('@primary').text == 'true',
        external_id: credit_card_tag.xpath('@operaId').text
      }

      # If PMS is tokenized, get token, otherwise get credit card number and convert to token
      if hotel.settings.is_pms_tokenized
        payment_type[:mli_token] = credit_card_tag.xpath('VaultedCardData/@vaultedCardID').text
      else
        mli_token = Mli.new(hotel).get_token(card_number: credit_card_tag.xpath('cardNumber').text, is_encrypted: false, is_manual: true)[:data]
        payment_type[:mli_token] = mli_token
      end

      logger.info "OPERA PROFILE DIDN'T GIVE US A CREDIT CARD NAME FOR #{payment_type[:mli_token]}" unless credit_card_tag.xpath('cardHolderName').text.present?

      payment_type[:card_name] = credit_card_tag.xpath('cardHolderName').text if credit_card_tag.xpath('cardHolderName').text.present?

      guest[:payment_types] << payment_type
    end

    # Addresses
    guest[:addresses] = []
    profile_tag.xpath('Addresses/NameAddress[@primary="true"][1]').each do |address_tag|
      mapped_address_label = ExternalMapping.map_external_value(hotel, address_tag.xpath('@addressType').text, Setting.mapping_types[:address_type])
      mapped_country = Country.find_by_code(address_tag.xpath('countryCode').text)
      mapped_country_id = mapped_country ? mapped_country.id : nil

      guest[:addresses] << {
        street1: address_tag.xpath('AddressLine[1]').text,
        street2: address_tag.xpath('AddressLine[2]').text,
        city: address_tag.xpath('cityName').text,
        state: address_tag.xpath('stateProv').text,
        country_id: mapped_country_id,
        postal_code: address_tag.xpath('postalCode').text,
        label: mapped_address_label,
        is_primary: true,
        external_id: address_tag.xpath('@operaId').text
      }
    end

    # Phones
    guest[:phones] = []
    profile_tag.xpath('Phones/NamePhone[@phoneRole="PHONE"]').each do |phone_tag|
      mapped_phone_label = ExternalMapping.map_external_value(hotel, phone_tag.xpath('@phoneType').text, Setting.mapping_types[:phone_type])

      guest[:phones] << {
        contact_type: :PHONE,
        value: phone_tag.xpath('PhoneNumber').text,
        label: mapped_phone_label,
        external_id: phone_tag.xpath('@operaId').text,
        is_primary: false
      }
    end

    # Emails (in phones section)
    guest[:emails] = []
    profile_tag.xpath('Phones/NamePhone[@primary="true"][@phoneRole="EMAIL"]').each do |email_tag|
      mapped_email_label = ExternalMapping.map_external_value(hotel, email_tag.xpath('@phoneType').text, Setting.mapping_types[:email_type])

      guest[:emails] << {
        contact_type: :EMAIL,
        value: email_tag.xpath('PhoneNumber').text,
        label: mapped_email_label,
        external_id: email_tag.xpath('@operaId').text,
        is_primary: true
      }
    end

    # Emails (only if not retrieved in phones section)
    if guest[:emails].empty?
      profile_tag.xpath('EMails/NameEmail[@primary="true"]').each do |email_tag|
        guest[:emails] << {
          contact_type: :EMAIL,
          value: email_tag.text,
          label: :HOME,
          external_id: email_tag.xpath('@operaId').text,
          is_primary: true
        }
      end
    end

    # Memberships
    guest[:memberships] = []
    profile_tag.xpath('Memberships/NameMembership').each do |membership_tag|
      mapped_membership_type = ExternalMapping.map_external_value(hotel, membership_tag.xpath('membershipType').text, Setting.mapping_types[:membership_type])

      if membership_tag.xpath('@membershipClass').present?
        mapped_membership_class = ExternalMapping.map_external_value(hotel, membership_tag.xpath('@membershipClass').text, Setting.mapping_types[:membership_class])
      else
        mapped_membership_class = MembershipType.where(property_id: hotel, value: mapped_membership_type).first.andand.membership_class.andand.value
      end

      # Get the external id from the opera_id or otherwise the membershipid
      external_id = membership_tag.xpath('@operaId').present? ? membership_tag.xpath('@operaId').text : membership_tag.xpath('membershipid').text

      guest[:memberships] << {
        membership_type: mapped_membership_type,
        membership_card_number: membership_tag.xpath('membershipNumber').text,
        card_name: membership_tag.xpath('memberName').text,
        membership_start_date: membership_tag.xpath('effectiveDate').text,
        membership_expiry_date: membership_tag.xpath('expirationDate').text,
        membership_level: membership_tag.xpath('membershipLevel').text,
        external_id: external_id,
        membership_class: mapped_membership_class,
        used_in_reservation: membership_tag.xpath('@usedInReservation').text == 'true'
      }
    end

    # Preferences
    guest[:preferences] = []
    profile_tag.xpath('Preferences/Preference').each do |preference_tag|
      mapped_preference_type = ExternalMapping.map_external_value(hotel, preference_tag.xpath('@preferenceType').text, Setting.mapping_types[:preference_type], false)
      mapped_preference_value = ExternalMapping.map_external_value(hotel, preference_tag.xpath('@preferenceValue').text, Setting.mapping_types[:preference_value], false)

      guest[:preferences] << {
        preference_type: mapped_preference_type,
        preference_value: mapped_preference_value
      }
    end

    # Features
    guest[:features] = []
    profile_tag.xpath('Features/Features').each do |feature_tag|
      guest[:features] << {
        feature_value: feature_tag.xpath('@Feature').text
      }
    end

    guest
  end

  # Parse the commets response and return a hash of the information
  def self.parse_comments_response(hotel_id, comments_tag)
    comments_tag.xpath('Comments/Comment').map do |comment_tag|
      {
        description: comment_tag.xpath('Text').text,
        external_id: comment_tag.xpath('CommentId').text,
        is_guest_viewable: comment_tag.xpath('@guestViewable').text
      }
    end
  end

  def self.parse_booking_response(hotel_id, confirm_no, operation_response)
    booking = { confirm_no: confirm_no }

    hotel = Hotel.find(hotel_id)

    # Hotel Reservation Tag
    hotel_reservation_tag = operation_response.xpath('HotelReservation')

    if hotel_reservation_tag
      # Get reservation status from reservationStatus
      booking[:status] = hotel_reservation_tag.xpath('@reservationStatus').text
      booking[:is_queued] = hotel_reservation_tag.xpath('@queueExists').text if hotel_reservation_tag.xpath('@queueExists').text.present?
      booking[:no_post] = hotel_reservation_tag.xpath('@noPost').text if hotel_reservation_tag.xpath('@noPost').text.present?

      departure_time = hotel_reservation_tag.xpath('@checkOutTime').text
      if departure_time.present?
        Time.zone = hotel.tz_info
        booking[:departure_time] = Time.zone.parse(departure_time)
      end
      market_segment = hotel_reservation_tag.xpath('@marketSegment').text

      # Room Stay Tag
      room_stay_tag = hotel_reservation_tag.xpath('RoomStays/RoomStay[1]')

      booking[:arrival_date] = Date.parse(room_stay_tag.xpath('TimeSpan/StartDate').text)
      booking[:dep_date] = Date.parse(room_stay_tag.xpath('TimeSpan/EndDate').text)
      booking[:guarantee_type] = room_stay_tag.xpath('Guarantee/@guaranteeType').text
      booking[:total_amount] = room_stay_tag.xpath('Total').text

      # Rate Plans
      rate_plans = []
      room_stay_tag.xpath('RatePlans/RatePlan').each do |rate_plan_tag|
        rate_plans << {
          rate_code: rate_plan_tag.xpath('@ratePlanCode').text,
          market_segment: market_segment,
          rate_desc: rate_plan_tag.xpath('RatePlanDescription/Text').text
        }
      end


       # Deposit and Due
      deposit = 0.0
      deposit_due = 0.0
      room_stay_tag.xpath('RatePlans/RatePlan').each do |rate_plan_tag|
        deposit += rate_plan_tag.xpath('DepositRequired/DepositAmount').text.to_f
        deposit_due += rate_plan_tag.xpath('DepositRequired/DepositDueAmount').text.to_f
        booking[:deposit]  =  {
          deposit_paid: deposit,
          deposit_due: deposit_due,
          currency_code: rate_plan_tag.xpath('DepositRequired/DepositAmount/@currencyCode').text
        }
      end

      # Get the first rate plan promotion code
      promotion_code = room_stay_tag.xpath('RatePlans/RatePlan[1]/@promotionCode').text
      booking[:promotion_code] = promotion_code.present? ? promotion_code : nil

      # Packages
      packages = []
      room_stay_tag.xpath('Packages/Package').each do |package_tag|
        packages << {
          package_code: package_tag.xpath('@packageCode').text,
          source: package_tag.xpath('@source').text,
          description: package_tag.xpath('Description/Text/TextElement').text,
          package_amount:           {
            currency_code: package_tag.xpath('PackageAmount/@currencyCode').text,
            amount: package_tag.xpath('PackageAmount').text,
            decimals: package_tag.xpath('PackageAmount/@decimals').text
          },
          tax_amount: {
            currency_code: package_tag.xpath('TaxAmount/@currencyCode').text,
            amount: package_tag.xpath('TaxAmount').text,
            decimals: package_tag.xpath('TaxAmount/@decimals').text
          },
          allowance: {
            currency_code: package_tag.xpath('Allowance/@currencyCode').text,
            amount: package_tag.xpath('Allowance').text,
            decimals: package_tag.xpath('Allowance/@decimals').text
          }
        }
      end
      booking[:packages] = packages

      # Room Types
      room_types = []
      room_stay_tag.xpath('RoomTypes/RoomType').each do |room_type_tag|
        room_types << {
          room_type: room_type_tag.xpath('@roomTypeCode').text,
          no_of_rooms: room_type_tag.xpath('@numberOfUnits').text,
          description: room_type_tag.xpath('RoomTypeDescription/Text').text,
          room: room_type_tag.xpath('RoomNumber').text
        }
      end

      # Expected Charges Tag
      expected_charges = []
      total_room_cost = 0.0
      total_package_cost = 0.0
      total_tax = 0.0
      room_stay_tag.xpath('ExpectedCharges/ChargesForPostingDate').each do |charges_tag|
        expected_charge = {
          reservation_date: Date.parse(charges_tag.xpath('@PostingDate').text),
          rates: [],
          taxes_and_fees: []
        }

        charges_tag.xpath('RoomRateAndPackages/Charges').each do |charge_tag|
          amount_tag = charge_tag.xpath('Amount')
          if charge_tag.xpath('Description').text == "BASE RATE"
            total_room_cost += amount_tag.text.to_f
          else
             total_package_cost += amount_tag.text.to_f
          end
          booking[:total_room_cost] = total_room_cost.to_s
          booking[:total_package_cost] = total_package_cost.to_s
          expected_charge[:rates] << {
            description: charge_tag.xpath('Description').text,
            currency_code: amount_tag.xpath('@currencyCode').text,
            amount: amount_tag.text
          }
        end

        charges_tag.xpath('TaxesAndFees/Charges').each do |charge_tag|
          amount_tag = charge_tag.xpath('Amount')
          total_tax += amount_tag.text.to_f
          booking[:total_tax] = total_tax.to_s
          expected_charge[:taxes_and_fees] << {
            description: charge_tag.xpath('Description').text,
            currency_code: amount_tag.xpath('@currencyCode').text,
            amount: amount_tag.text
          }
        end

        expected_charges << expected_charge
      end

      # Room Rates
      rates = []
      room_stay_tag.xpath('RoomRates/RoomRate').each do |room_rate_tag|
        room_type = room_types.select { |type| type[:room_type] == room_rate_tag.xpath('@roomTypeCode').text }.first
        rate_plan = rate_plans.select { |plan| plan[:rate_code] == room_rate_tag.xpath('@ratePlanCode').text }.first

        # Rates
        room_rate_tag.xpath('Rates/Rate[1]').each do |rate_tag|
          rates << {
            room_type_info: room_type ? room_type : { code: room_rate_tag.xpath('@roomTypeCode').text },
            rate_info: rate_plan ? rate_plan : { rate_code: room_rate_tag.xpath('@ratePlanCode').text },
            reservation_date: rate_tag.xpath('@effectiveDate').present? ? Date.parse(rate_tag.xpath('@effectiveDate').text) : booking[:arrival_date],
            currency_code: rate_tag.xpath('Base/@currencyCode').text,
            rate_amount: rate_tag.xpath('Base').text,
            room: room_type ? room_type[:room] : nil
          }
        end
      end

      booking[:is_rate_suppressed] = room_stay_tag.xpath('RoomRates/RoomRate')[0].xpath('@suppressRate').text

      # Guest Counts
      adults = room_stay_tag.xpath('GuestCounts/GuestCount[@ageQualifyingCode="ADULT"]/@count').text
      children = 0
      room_stay_tag.xpath('GuestCounts/GuestCount[@ageQualifyingCode="CHILD"]').each do |child_guests|
        children += child_guests.xpath('@count').text.to_i
      end

      # Setup Daily Instances
      booking[:daily_instances] = []
      (booking[:arrival_date]..booking[:dep_date]).each do |day|

        # Get the last rate with a reservation date less than or equal to the day
        rate = rates.select { |r| r[:reservation_date] <= day }.last
        if rate
          # Clone the daily instance information from the rate information
          daily_instance = rate.clone

          # Set the details daily instance
          daily_instance[:reservation_date] = day
          daily_instance[:market_segment] = market_segment
          daily_instance[:adults] = adults
          daily_instance[:children] = children.to_s

          # Get the last expected charge with a reservation date less than or equal to the day
          daily_instance[:expected_charge] = expected_charges.select { |charge| charge[:reservation_date] <= day }.last

          booking[:daily_instances] << daily_instance
        else
          logger.warn 'RESERVATION IMPORTER EXCEPTION - RATE IS NOT FOUND'
        end
      end

      # Hotel Reference Tag
      booking[:chain_code] = room_stay_tag.xpath('HotelReference/@chainCode').text
      booking[:hotel_code] = room_stay_tag.xpath('HotelReference/@hotelCode').text

      # Notes
      booking[:notes] = []
      room_stay_tag.xpath('Comments.Comment').each do |comment_tag|
        booking[:notes] << comment_tag.xpath('Text').text
      end

      # Payment Type
      payment_type_tag = room_stay_tag.xpath('//PaymentsAccepted/PaymentType[1]/OtherPayment')

      card_type = payment_type_tag.xpath('@type').text
      mapped_card_type = ExternalMapping.map_external_value(hotel, card_type, Setting.mapping_types[:credit_card_type])

      # If not credit card, then save the payment type.  Otherwise, look in the GuaranteeCreditCard tag.
      if PaymentType.non_credit_card(hotel).exists?(value: mapped_card_type)
        # Payment Type - non credit card
        booking[:payment_type] = {
          credit_card_type: card_type
        }

      else
        # Payment Type - credit card
        room_stay_tag.xpath('//GuaranteeCreditCard[1]').each do |credit_card_tag|
          booking[:payment_type] = {
            credit_card_type: credit_card_tag.xpath('@cardType').text,
            card_expiry: credit_card_tag.xpath('expirationDate').text
          }

          # If PMS is tokenized, get token, otherwise get credit card number and convert to token
          if hotel.settings.is_pms_tokenized
            booking[:payment_type][:mli_token] = credit_card_tag.xpath('VaultedCardData/@vaultedCardID').text
          else
            mli_token = Mli.new(hotel).get_token(card_number: credit_card_tag.xpath('cardNumber').text, is_encrypted: false, is_manual: true)[:data]
            booking[:payment_type][:mli_token] = mli_token
          end

          logger.info "OPERA BOOKING DIDN'T GIVE US A CREDIT CARD NAME FOR #{booking[:payment_type][:mli_token]}" unless credit_card_tag.xpath('cardHolderName').text.present?

          booking[:payment_type][:card_name] = credit_card_tag.xpath('cardHolderName').text if credit_card_tag.xpath('cardHolderName').text.present?
        end

      end

      # if it is not credit card payment type then look for direct bill
      unless booking[:payment_type]
        room_stay_tag.xpath('//GuaranteeCompany[1]').each do |guarantee_company_tag|
          booking[:payment_type] = {
            credit_card_type: 'DB',
            card_name: guarantee_company_tag.xpath('@source').text
          }
        end
      end

      # Reservation Preferences
      booking[:features] = []
      hotel_reservation_tag.xpath('Preferences/Preference[@otherPreferenceType="RESERVATION"]').each do |preference_tag|
        booking[:features] << {
          type: preference_tag.xpath('@preferenceType').text,
          value: preference_tag.xpath('@preferenceValue').text
        }
      end
      # Reservation Accompanying Guest Details
      booking[:accompanying_guests] = []
      hotel_reservation_tag.xpath('AccompanyGuests/AccompanyGuest').each do |accompanying_guest_tag|
        booking[:accompanying_guests] << {
          name_id:  accompanying_guest_tag.xpath('NameID').text,
          first_name: accompanying_guest_tag.xpath('FirstName').text,
          last_name: accompanying_guest_tag.xpath('LastName').text
        }
      end
      arrival_time = hotel_reservation_tag.xpath('ResGuests/ResGuest[1]').xpath('@arrivalTime').text
      if arrival_time.present?
        Time.zone = hotel.tz_info
        booking[:arrival_time] = Time.zone.parse(arrival_time)
      end
      # Guest Tag
      hotel_reservation_tag.xpath('ResGuests/ResGuest[1]/Profiles/Profile[1]').each do |profile_tag|
        booking[:guest] = OwsCommonApi.parse_guest_response(hotel_id, profile_tag)

        # If a membership is used in the reservation, set the booking membership
        booking[:membership] = booking[:guest][:memberships].select { |membership| membership[:used_in_reservation] }.first
      end

      # Multiple Bill card & CC for each Reservation
      booking[:bill_card_payment_types] = hotel_reservation_tag.xpath('PayMethods').map do |pay_routing_tag|
        if pay_routing_tag.xpath('@Owner').present?
          {
            payment_method: pay_routing_tag.xpath('PaymentMethod/@value').text,
            bill_number: pay_routing_tag.xpath('@Window').text,
            card_name: pay_routing_tag.xpath('@Owner').text
          }
        end
      end.compact

      # Routing Instructions
      booking[:routings] = hotel_reservation_tag.xpath('PayRoutings').map do |pay_routing_tag|
        if pay_routing_tag.xpath('@RoutingInstruction').present?
          {
            routing_instruction: pay_routing_tag.xpath('@RoutingInstruction').text,
            owner: pay_routing_tag.xpath('@Owner').text,
            window: pay_routing_tag.xpath('@Window').text,
            room_no: pay_routing_tag.xpath('@Room').text
          }
        end
      end.compact

    end

    booking
  end
end
