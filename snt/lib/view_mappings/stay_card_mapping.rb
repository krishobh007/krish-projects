class ViewMappings::StayCardMapping

  def self.getDatetime(date, time, hotel)
    ActiveSupport::TimeZone[hotel.tz_info].parse(date.to_s + ' ' + time.to_s)
  end

  def self.map_view_status(reservation, active_business_date)
    current_time = Time.now.utc

    mapped_status = reservation.status.value
    # Handling Hourly status BEGIN CICO-9483
    if reservation.is_hourly
      # As per the defect CICO- 12464, we will consider DUEIN - Reservations which comes in 24hours of the current EOD time
      # If hotel doent enable EOD, we will take current system time within 24hours reservation.
      is_eod_enabled = reservation.hotel.settings.is_auto_change_bussiness_date && reservation.hotel.settings.business_date_change_time.present?
      # if eod enabled we will take the EOD time
      if is_eod_enabled
        current_time = reservation.hotel.settings.business_date_change_time
      else
        current_time = getDatetime(active_business_date, Time.now.utc, reservation.hotel)
      end

      current_eod_time = current_time.in_time_zone(reservation.hotel.tz_info)
      next_business_date_eod_time = getDatetime(active_business_date + 1.day, current_eod_time, reservation.hotel)

      if reservation.status === :RESERVED &&
        reservation.arrival_time.utc <= next_business_date_eod_time.utc
        mapped_status = Setting.reservation_view_status[:checking_in]

      elsif reservation.is_hourly && reservation.status === :CHECKEDIN &&
      reservation.departure_time.utc <= getDatetime(active_business_date, Time.now.utc, reservation.hotel) + 1.hour
        mapped_status = Setting.reservation_view_status[:checking_out]
      else
        mapped_status = reservation.status.value
      end
    # Handling Hourly status END CICO-9483
    elsif reservation.status === :RESERVED && reservation.arrival_date == active_business_date
      mapped_status = Setting.reservation_view_status[:checking_in]
    elsif reservation.status === :CHECKEDIN && reservation.dep_date == active_business_date
      mapped_status = Setting.reservation_view_status[:checking_out]
    elsif reservation.status === :NO_SHOW && reservation.dep_date > active_business_date
      mapped_status = Setting.reservation_view_status[:noshow_current]
    end
    mapped_status
  end

  def self.get_first_time_checkin_status(reservation, active_business_date)
    status = 'false'
    if map_view_status(reservation, active_business_date) == Setting.reservation_view_status[:checking_in]
      status = reservation.is_first_time_checkin.to_s if reservation.is_first_time_checkin.present?
    end
    status
  end

  def self.map_to_stay_card_data(reservation, active_business_date,booking_attributes = nil)
    current_daily_instance = reservation.current_daily_instance
    room = current_daily_instance.andand.room
    
    # There may be a case where, room is nil, but room_type is mandatory for a reservation
    # So we cannot take room.room_type, instead we will take room_type directly
    room_type = current_daily_instance.andand.room_type
    room_max_occupancy = room.andand.max_occupancy
    room_type_max_occupancy = room_type.andand.max_occupancy
   
    max_occupancy = room_max_occupancy ? room_max_occupancy : room_type_max_occupancy

    reservation_notes = reservation.notes.order('notes.updated_at DESC')
    amount_hash = {}
    hotel = reservation.hotel
    reservation_payment_method = reservation.valid_primary_payment_method
    if hotel.is_third_party_pms_configured?
      avg_daily_rate =  NumberUtility.default_amount_format(reservation.average_rate_amount, true)
      total_rate = NumberUtility.default_amount_format(reservation.get_total_stay_amount.to_f, true)
      guarantee_type = reservation.guarantee_type.to_s
    else
      avg_daily_rate =  NumberUtility.default_amount_format(reservation.standalone_average_rate_amount, true)
      total_rate = NumberUtility.default_amount_format(reservation.standalone_total_stay_amount.to_f, true)
      guarantee_type = reservation.reservation_type.andand.description
      is_rate_suppressed_present_in_daily_instances = reservation.suppress_rate_present_in_daily_instances.present?
    end

    # As per CICO-6135 only list converted arrival & departure time, when updating actual CI & CO.

    arrival_time = reservation.arrival_time if reservation.arrival_time

    arrival_time = arrival_time.in_time_zone(reservation.hotel.tz_info).strftime('%l:%M %p') if arrival_time

    departure_time = reservation.departure_time.present? ? reservation.departure_time.in_time_zone(reservation.hotel.tz_info) : nil
    departure_time = departure_time.strftime('%l:%M %p') if departure_time
    reservation_rate_ids = []
    if hotel.is_third_party_pms_configured?
      deposit_attributes_hash = booking_attributes.present? ? get_balance_and_deposit(booking_attributes) : {}
    else
      deposit_attributes_hash = standalone_balance_and_deposit(reservation)
    end
    stay_card_hash = {
      timeline: reservation.timeline(active_business_date).to_s,
      confirmation_num: reservation.confirm_no.to_s,
      reservation_status: map_view_status(reservation, active_business_date).to_s,
      arrival_date: reservation.arrival_date.andand.strftime('%Y-%m-%d').to_s,
      # As per CICO-13076 - we will send departure date as departure_time date
      departure_date: reservation.is_hourly ? reservation.departure_time.andand.strftime('%Y-%m-%d').to_s : reservation.dep_date,
      group_name: current_daily_instance.group.andand.name.to_s,
      accompaying_guests: map_reservation_accompanying_guests(reservation),
      guests_total: current_daily_instance.total_guests,
      number_of_infants: 0, # TODO: Get the number of infants
      number_of_adults: current_daily_instance.adults,
      number_of_children: current_daily_instance.children,
      guarentee_type: guarantee_type,
      has_smartbands: reservation.smartbands.present?,
      room_number:  room.andand.room_no.to_s,
      room_id:  room.andand.id.to_s,
      key_settings: reservation.hotel.settings.room_key_delivery_for_rover_check_in.to_s,
      room_status: room.andand.is_ready? ? 'READY' : 'NOTREADY',
      fo_status: room.andand.mapped_fo_status,
      room_type_description: current_daily_instance.room_type.andand.room_type_name,
      room_type_code: current_daily_instance.room_type.andand.room_type.to_s,
      membership_type: '', # #TODO Data not available
      avg_daily_rate: avg_daily_rate,
      total_rate: total_rate,
      rate_name: current_daily_instance.andand.rate.andand.rate_name,
      rate_description: current_daily_instance.andand.rate.andand.rate_desc,
      total_nights: reservation.total_nights,
      loyalty_level: {
        selected_loyalty: reservation.memberships.first.andand.id,
        frequentFlyerProgram: reservation.get_ffps,
        hotelLoyaltyProgram: reservation.get_hlps
      },

      reservation_id: reservation.id,
      payment_details: map_payment_details(reservation),
      wake_up_time: reservation.get_wakeup_time,
      is_force_upsell: hotel.settings.upsell_is_force.to_s,
      is_upsell_available: current_daily_instance.room_type.upsell_available?(reservation).to_s,
      news_paper_pref: reservation.hotel.get_newspaper_features(reservation),
      payment_type: reservation_payment_method.andand.id,
      notes: {
        note_topics: reservation.notes ? reservation.notes.map { |note| note.note_type.value }.uniq : [],
        reservation_notes: reservation_notes.map do |note|
          map_reservation_notes_hash(note)
        end
      },
      currency_code: reservation.currency_code,
      balance_amount: reservation.current_balance,
      enable_nights: reservation.get_enabled_night_status(active_business_date),
      is_late_checkout_on: reservation.hotel.settings.late_checkout_is_on,
      is_opted_late_checkout: reservation.is_opted_late_checkout,
      late_checkout_time: reservation.late_checkout_time.andand.strftime('%l:%M %p'),
      routings: '',
      deposit_attributes: deposit_attributes_hash,
      payment_method_used: reservation_payment_method.andand.payment_type.andand.is_cc?(hotel) ? 
                              PaymentType.credit_card.value.andand.upcase: reservation_payment_method.andand.payment_type.andand.value.andand.upcase,
      payment_method_description: reservation_payment_method.andand.payment_type.andand.description.to_s,
      is_rates_suppressed: reservation.is_rate_suppressed.to_s,
      text_rates_suppressed: reservation.is_rate_suppressed ? 'SR' : '',
      arrival_time: arrival_time,
      departure_time: departure_time,
      is_routing_available: reservation.charge_routings.any?.to_s,
      room_ready_status: room.andand.hk_status.to_s,
      use_inspected: hotel.settings.use_inspected.to_s,
      use_pickup: hotel.settings.use_pickup.to_s,
      checkin_inspected_only: hotel.settings.checkin_inspected_only.to_s,
      is_reservation_queued: reservation.is_queued.to_s,
      is_queue_rooms_on: hotel.settings.is_queue_rooms_on.to_s,
      icare_enabled: hotel.settings.icare_enabled.to_s,
      smartband_has_balance: reservation.smartbands.has_balance.exists?.to_s,
      booking_origin_id: reservation.booking_origin_id,
      market_segment_id: reservation.market_segment_id,
      source_id: reservation.source_id,
      reservation_type_id: reservation.reservation_type_id,
      is_pre_checkin: reservation.is_pre_checkin,
      is_rate_suppressed_present_in_stay_dates: reservation.suppress_rate_present_in_daily_instances.present?,
      combined_key_room_charge_create: hotel.settings.icare_combined_key_room_charge_create.to_s,
      stay_dates: reservation.daily_instances.exclude_dep_date.map do |daily_instance|
        reservation_rate_id = daily_instance.rate_id
        date = daily_instance.reservation_date  
        rate = current_daily_instance.andand.rate
        room_type = current_daily_instance.andand.room_type
        begin_time = ActiveSupport::TimeZone[reservation.hotel.tz_info].parse(date.to_s + ' ' + arrival_time.to_s)
        if !hotel.is_third_party_pms_configured?
          amount_hash = (reservation.is_hourly? && rate.is_hourly_rate?) ? rate.fetch_hourly_roomrates_data(date, room_type, begin_time) : rate.amounts(date, room_type)
        end
        
        # Catch the rate ids into an array to check whether the reservation is of multiple rates or single rate
        reservation_rate_ids << reservation_rate_id
        {
          adults: daily_instance.adults,
          children: daily_instance.children,
          infants: daily_instance.infants,
          date: date,             
          rate:{
            actual_amount: ('%.2f' % daily_instance.original_rate_amount.to_f).to_s,
            modified_amount: ('%.2f' % daily_instance.rate_amount.to_f).to_s,
            is_discount_allowed: daily_instance.rate.andand.is_discount_allowed_on.to_s,
            is_suppressed: daily_instance.rate.andand.is_suppress_rate_on.to_s
          },
          rate_id: reservation_rate_id,
          room_type_id: daily_instance.room_type_id,
          rate_config:{
            child: amount_hash && amount_hash[:child_amount].to_f,
            double: amount_hash && amount_hash[:double_amount].to_f,
            extra_adult: amount_hash && amount_hash[:extra_adult_amount].to_f,
            single: amount_hash && amount_hash[:single_amount].to_f
          }
        }
      end,
      is_multiple_rates: (!reservation_rate_ids.empty? && reservation_rate_ids.uniq.size != 1) ? true : false,
      is_hourly_reservation: reservation.is_hourly?,
      max_occupancy: max_occupancy,
      deposit_amount: ('%.2f' % reservation.balance_deposit_amount).to_s,
      deposit_policy: map_deposit_details(reservation),
      is_disabled_email_phone_dialog: hotel.settings.disable_email_phone_dialog.to_s,
      hotel_selected_key_system: hotel.key_system.to_s,
      is_package_exist: reservation.reservations_addons.present?,
      package_count: reservation.reservations_addons.count.to_s
    }
  stay_card_hash
  end

  def self.map_deposit_details(reservation)
    deposit_policy = reservation.deposit_policy
    if deposit_policy
      {
        id: deposit_policy.id,
        name: deposit_policy.name,
        description: deposit_policy.description,
        amount: deposit_policy.amount,
        amount_type: deposit_policy.amount_type
      }
    else
      {}
    end
  end

  def self.map_reservation_accompanying_guests(reservation)
    reservation.accompanying_guests.map do |guest_detail|
     {
      guest_name: guest_detail.full_name
     }
    end
  end

  def self.map_reservation_notes_hash(reservation_note)
   {
      note_id: reservation_note.id,
      username:  reservation_note.is_from_external_system ? 'FROM PMS' : reservation_note.user.andand.full_name,
      posted_time: reservation_note.is_from_external_system ? '' : reservation_note.updated_at.strftime('%I:%M %p'),
      posted_date: reservation_note.is_from_external_system ? '' : reservation_note.updated_at.strftime('%Y-%m-%d'),
      topic: 'GENERAL',
      text: reservation_note.description.gsub(/\n/, "<br/>"),
      user_image: reservation_note.user && reservation_note.user.detail ? reservation_note.user.detail.avatar.url(:thumb) : ''
   }
  end



  def self.map_payment_details(reservation)
    payment_details = {}
    valid_primary_payment_method = reservation.valid_primary_payment_method
    hotel = reservation.hotel
    payment_type = valid_primary_payment_method.andand.payment_type
    if (payment_type.andand.is_cc?(hotel) && !payment_type.andand.credit_card?)
      card_type_image = "credit-card.png"
    else
      card_type_image = "#{valid_primary_payment_method.andand.credit_card_type.andand.value.to_s.downcase}.png"
    end
    
    payment_details = {
        card_type_image: card_type_image,
        card_number:  valid_primary_payment_method.andand.mli_token_display.to_s,
        card_expiry:  valid_primary_payment_method.andand.card_expiry_display.to_s,
        is_swiped:    valid_primary_payment_method.andand.is_swiped,
        id:           valid_primary_payment_method.andand.id
    }

    payment_details
  end

  def self.map_reservation_routings_hash(routing)
    routing_hash = {}
    routing_hash['routing_id'] = routing.id
    routing_hash['bill_number'] = routing.bill.bill_number
    routing_hash['routing_instructions'] = routing.external_routing_instructions
    routing_hash['room_no'] = routing.room.andand.room_no

    routing_hash
  end

  def self.map_guest_card_contact_info(reservation)
    guest_card_hash_data = {}
    guest_card_hash_data['first_name'] = reservation.primary_guest.contact_info[:first_name]
    guest_card_hash_data['last_name'] = reservation.primary_guest.contact_info[:last_name]
    guest_card_hash_data['membership_type'] =  reservation.primary_guest.contact_info[:membership_level]
    guest_card_hash_data['city'] = reservation.primary_guest.contact_info[:city] ? reservation.primary_guest.contact_info[:city] : ''
    guest_card_hash_data['state'] = reservation.primary_guest.contact_info[:state] ? reservation.primary_guest.contact_info[:state] : ''
    guest_card_hash_data['phone'] =  reservation.primary_guest.contact_info[:phone]
    guest_card_hash_data['email'] =  reservation.primary_guest.email
    guest_card_hash_data['vip'] = reservation.primary_guest.is_vip
    guest_card_hash_data['guest_id'] = reservation.primary_guest.external_id
    guest_card_hash_data['user_id'] = reservation.primary_guest.id ? reservation.primary_guest.id : nil
    guest_card_hash_data['reservation_id'] = reservation.id
    guest_card_hash_data['avatar'] = reservation.primary_guest.avatar.url(:thumb)
    guest_card_hash_data
  end

  def self.build_reservation_ids(reservations, current_hotel)
    reservations.map do |reservation|
      {
        'id' => reservation.id,
        'confirmation_num' => reservation.confirm_no,
        'reservation_status' => map_view_status(reservation, current_hotel.active_business_date),
        'is_pre_checkin' => reservation.is_pre_checkin
      }
    end
  end

  def self.map_key_setup(reservation)
    @result = {
      room_number: reservation.current_daily_instance.andand.room.andand.room_no.to_s,
      confirmation_number: reservation.confirm_no,
      email: reservation.primary_guest.email,
      is_late_checkout: reservation.is_opted_late_checkout.to_s,
      late_checkout_time: reservation.late_checkout_time ? reservation.late_checkout_time.strftime('%I:%M %p') : '',
      user_name: " #{reservation.andand.primary_guest.andand.first_name}  #{reservation.andand.primary_guest.andand.last_name}",
      retrieve_uid: reservation.hotel.key_system.andand.retrieve_uid
    }
  end

  # Method to return reservation header details for upsell screens
  def self.get_reservation_header(reservation, active_business_date)
    current_daily_instance = reservation.current_daily_instance
    room = current_daily_instance.room
    room_type = current_daily_instance.room_type

    {
      'room_number' => room.andand.room_no,
      'room_type_name' => room_type.room_type_name,
      'room_type' => room_type.room_type,
      'total_nights' => reservation.total_nights,
      'arrival_date' => ApplicationController.helpers.formatted_date(reservation.arrival_date),
      'departure_date' => ApplicationController.helpers.formatted_date(reservation.dep_date),
      'room_status' => room.andand.is_ready? ? 'READY' : 'NOTREADY',
      'reservation_status' => ViewMappings::StayCardMapping.map_view_status(reservation, active_business_date),
      'fo_status' => room.andand.mapped_fo_status || '',
      'room_ready_status' => room.andand.hk_status.to_s,
      'use_inspected' =>  reservation.hotel.settings.use_inspected.to_s,
      'use_pickup' =>  reservation.hotel.settings.use_pickup.to_s,
      'checkin_inspected_only' => reservation.hotel.settings.checkin_inspected_only.to_s,
      'reservation_occupancy' => current_daily_instance.total_guests
    }
  end

  def self.get_credit_cards(reservation, bill_number)
    reservation_payment_method = reservation.bill_payment_method(bill_number)

    primary_guest = reservation.primary_guest
    guest_payment_methods = primary_guest ? primary_guest.payment_methods.valid : []

    payment_methods = guest_payment_methods

    if reservation_payment_method && !reservation_payment_method.card_expiry_masked?
      on_both = guest_payment_methods.select { |payment_method| payment_method.mli_token == reservation_payment_method.mli_token }.count > 0
      payment_methods << reservation_payment_method unless on_both
    end
    payment_methods = payment_methods.select {|payment_method| payment_method.payment_type.andand.is_cc?(reservation.hotel) }
    
    {
      merchant_id: reservation.hotel.settings.mli_merchant_id,
      selected_payment: reservation_payment_method.andand.id.to_s,
      selected_payment_fees_details: reservation_payment_method.andand.fees_information(reservation.hotel),
      existing_payments: payment_methods.map do |payment_method|
        payment_type = payment_method.payment_type;
        if (payment_type.is_cc?(reservation.hotel) && !payment_type.credit_card?)
          card_code = "credit-card"
        else
          card_code = payment_method.credit_card_type.to_s.downcase;
        end
        
        {
          value: payment_method.id.to_s,
          card_code: card_code,
          ending_with: payment_method && payment_method.mli_token? ? payment_method.mli_token_display : '',
          expiry_date: payment_method && payment_method.card_expiry? ? payment_method.card_expiry_display : '',
          holder_name: payment_method.card_name.to_s,
          is_credit_card: payment_method.credit_card?,
          fees_information: payment_method ? payment_method.fees_information(reservation.hotel) : {}
        }
      end
    }
  end

  def self.get_balance_and_deposit(booking_attributes)
    sub_total =  booking_attributes[:total_room_cost].to_f + booking_attributes[:total_package_cost].to_f
    stay_total = sub_total + booking_attributes[:total_tax].to_f
    total_cost_of_stay = stay_total + booking_attributes[:nightly_charges].to_f
    deposit_paid = booking_attributes[:deposit].present? ? booking_attributes[:deposit][:deposit_paid].to_f : 0.0
    outstanding_stay_total =  booking_attributes[:deposit].present? ? total_cost_of_stay -  deposit_paid : total_cost_of_stay
    {
      room_cost: NumberUtility.default_amount_format(booking_attributes[:total_room_cost].to_f,false).to_s,
      packages:  NumberUtility.default_amount_format(booking_attributes[:total_package_cost].to_f,false).to_s,
      sub_total: NumberUtility.default_amount_format(sub_total,false).to_s,
      fees: NumberUtility.default_amount_format(booking_attributes[:total_tax].to_f,false).to_s,
      stay_total:  NumberUtility.default_amount_format(stay_total,false).to_s,
      nightly_charges: NumberUtility.default_amount_format(booking_attributes[:nightly_charges].to_f,false).to_s,
      total_cost_of_stay:  NumberUtility.default_amount_format(total_cost_of_stay,false).to_s,
      deposit_paid:  NumberUtility.default_amount_format(deposit_paid,false).to_s,
      outstanding_stay_total: NumberUtility.default_amount_format(outstanding_stay_total.to_f,false).to_s,
      currency_code:  booking_attributes[:deposit].present? ? booking_attributes[:deposit][:currency_code] : ''
    }
  end

  def self.standalone_balance_and_deposit(reservation)
    hotel = reservation.hotel

    accommodation_cost = reservation.accommodation_cost
    addon_cost = reservation.addon_cost

    room_cost = accommodation_cost[:room_cost]
    package_cost = addon_cost[:package_cost]

    accommodation_exclusive_tax = accommodation_cost[:accommodation_exclusive_tax]
    accommodation_inclusive_tax = accommodation_cost[:accommodation_inclusive_tax]

    addon_exclusive_tax = addon_cost[:addon_exclusive_tax]
    addon_inclusive_tax = addon_cost[:addon_inclusive_tax]
    
    bill = reservation.bills.first || Bill.create(bill_number: 1, reservation_id: reservation.id) 

    fees = bill.financial_transactions.where('charge_code_id in (?)', hotel.charge_codes.fees.pluck(:id)).sum(:amount)

    total_exclusive_tax = accommodation_exclusive_tax + addon_exclusive_tax
    total_inclusive_tax = accommodation_inclusive_tax + addon_inclusive_tax
    total_fees = total_exclusive_tax + total_inclusive_tax + fees

    sub_total = room_cost + package_cost
    stay_total = sub_total + total_exclusive_tax + fees
    nightly_charges = 0
    total_cost_of_stay = stay_total + nightly_charges
    # Excluded the fees from deposit_paid, so fee has to add to make balance as 0 CICO-11976
    deposit_paid = reservation.deposit_paid + fees
    outstanding_stay_total = total_cost_of_stay.andand.round(2) - deposit_paid.andand.round(2)
    currency_code = reservation.financial_transactions.credit.last.andand.currency_code.andand.symbol
    {
      room_cost: NumberUtility.default_amount_format(room_cost.to_f,false).to_s,
      packages:  NumberUtility.default_amount_format(package_cost.to_f,false).to_s,
      sub_total: NumberUtility.default_amount_format(sub_total,false).to_s,
      fees: NumberUtility.default_amount_format(total_fees.to_f,false).to_s,
      stay_total:  NumberUtility.default_amount_format(stay_total,false).to_s,
      nightly_charges: NumberUtility.default_amount_format(nightly_charges.to_f,false).to_s,
      total_cost_of_stay:  NumberUtility.default_amount_format(total_cost_of_stay,false).to_s,
      deposit_paid:  NumberUtility.default_amount_format(deposit_paid,false).to_s,
      outstanding_stay_total: NumberUtility.default_amount_format(outstanding_stay_total.to_f, false).to_s,
      currency_code: currency_code
    }
  end
end
