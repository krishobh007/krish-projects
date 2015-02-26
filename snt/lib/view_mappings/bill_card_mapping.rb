class ViewMappings::BillCardMapping
  extend ApplicationHelper
  def self.map_bill_card(reservation, current_hotel)
    bill_card = {}
    # As per CICO-6083, we need to SR rate information for each date in standalone PMS
    is_reservation_rate_suppressed = reservation.is_rate_suppressed
    daily_instances = reservation.daily_instances
    current_daily_instance = reservation.current_daily_instance
    room = current_daily_instance.andand.room
    active_business_date = current_hotel.active_business_date
    if room
      room_status = room.is_ready? ? 'READY' : 'NOTREADY'
    end
    # qr_flag = (reservation.hotel.settings.room_key_delivery_for_rover_check_in == "qr_code_tablet")
    bill_card['key_settings'] = reservation.hotel.settings.room_key_delivery_for_rover_check_in
    bill_card['icare_enabled'] = reservation.hotel.settings.icare_enabled.to_s
    bill_card['combined_key_room_charge_create'] = reservation.hotel.settings.icare_combined_key_room_charge_create.to_s
    bill_card['reservation_id']  = reservation.id
    bill_card['reservation_status']  = ViewMappings::StayCardMapping.map_view_status(reservation, active_business_date)
    bill_card['room_number']  = room ? room.room_no : ''
    bill_card['room_status']  = room_status.to_s
    bill_card['room_type']    = room ? room.room_type.room_type : ''
    bill_card['room_type_name']    = room ? room.room_type.room_type_name : ''
    bill_card['checkin_date']   =  reservation.arrival_date
    bill_card['checkout_date']  = reservation.dep_date
    bill_card['number_of_nights'] = reservation.total_nights
    bill_card['no_post'] = reservation.no_post.to_s
    bill_card['fo_status']  = room.andand.mapped_fo_status
    bill_card['currency_code']  = current_daily_instance.currency_code.andand.value
    bill_card['is_promotions_and_email_set'] = reservation.primary_guest.andand.is_opted_promotion_email ? 'true' : 'false'
    bill_card['required_signature_at'] = reservation.hotel.settings.require_signature_at || ''
    bill_card['room_ready_status'] = room.andand.hk_status.to_s
    bill_card['use_inspected'] = current_hotel.settings.use_inspected.to_s
    bill_card['use_pickup'] = current_hotel.settings.use_pickup.to_s
    bill_card['checkin_inspected_only'] = current_hotel.settings.is_inspected_only.to_s
    bill_card['is_rates_suppressed'] = is_reservation_rate_suppressed.to_s
    bill_card['text_rates_suppressed'] = is_reservation_rate_suppressed ? 'SR' : ''

    bill_card['signature_details'] = {
      'is_signed' => reservation.signature.present? ? 'true' : 'false',
      'signed_image' => reservation.signature.present? ? "data:image/jpeg;base64, #{Base64.encode64(reservation.signature.andand.data.to_s)}" : '',
      'signed_date_time' => reservation.signature.present? ? reservation.signature.created_at.utc.in_time_zone(reservation.hotel.tz_info).strftime('%m-%d-%y %I:%M %p') : ''
    }

    # gets reservation, room and housekeeping info
    bill_card = get_reservation_info(reservation, current_daily_instance, current_hotel, is_reservation_rate_suppressed)
    bills = []
    # Get bill details for given reservation
    @days_assigned = false
    bill_instance = Bill.where(reservation_id: reservation.id).order('bill_number ASC')

    if bill_instance
      bill_instance.each do |each_bill_instance|
        bill_hash = Hash.new

        # will return financial transactions for debits posted
        financial_records = each_bill_instance.financial_transactions.where('financial_transactions.charge_code_id IS NOT NULL AND is_active=true')
        .order('financial_transactions.date, financial_transactions.charge_code_id') #order('financial_transactions.date, financial_transactions.external_id, financial_transactions.updated_at')

        # get all the revenues or debits
        financial_records_debits = financial_records.exclude_payment

        # get all the payments or credits
        financial_records_credits = financial_records.credit

        # get total payments and debits
        if each_bill_instance
          bill_hash['bill_number'] = each_bill_instance.bill_number.to_s
          bill_hash['total_amount'] = financial_records_debits.sum(:amount).round(2).to_s
          bill_hash['total_payments'] = financial_records_credits.sum(:amount).round(2).to_s

          bill_hash['credit_card_details']  = map_bill_credit_card_hash(each_bill_instance.reservation, each_bill_instance.bill_number)
          bill_hash['guest_or_company_name']  = map_guest_or_company_name(each_bill_instance)
        end

        # get finiancial transactions groups details
        group_items = get_financial_tran_groups(financial_records_debits)
        # get addons
        if bill_instance.first == each_bill_instance
          if reservation.addons.present?
            addons = get_reservation_addons(reservation)
            bill_hash['addons'] = addons
          end
        end
        bill_hash['group_items'] = group_items

        # Get total fees
        # structure the revenues to show debits
        total_fees, make_all_charges_suppressed =
          get_financial_transaction_details(financial_records, reservation, is_reservation_rate_suppressed, bill_hash)
        bill_hash['total_amount'], bill_hash['total_payments'] = get_bill_hash_amounts(bill_hash, make_all_charges_suppressed)
        # bill_hash['total_amount'] =
        # make_all_charges_suppressed ? Setting.suppressed_rate : NumberUtility.default_amount_format(bill_hash['total_amount'])
        # bill_hash['total_payments'] =
        # make_all_charges_suppressed ? Setting.suppressed_rate : NumberUtility.default_amount_format(bill_hash['total_payments'])

        bill_hash['total_fees'] = total_fees

        days = Array.new
        # Get daily rates for the reservation
        if each_bill_instance.bill_number.to_s == '1'
          @days_assigned = true
          if daily_instances
            # get reservation daily instance info
            days = get_res_daily_instance_info(daily_instances, is_reservation_rate_suppressed)
          end
        end
        bill_hash['days'] = days

        bills.push(bill_hash)
      end
    end

    # if there are no bills then assign days to default bill number 1
    unless @days_assigned
      bill_hash = {}
      group_items = []
      bill_hash['group_items'] = group_items
      total_fees = []
      bill_hash['total_fees'] = total_fees
      bill_hash['bill_number'] = '1'
      bill_hash['total_amount'] = NumberUtility.default_amount_format('0')
      bill_hash['total_payments'] = NumberUtility.default_amount_format('0')
      @days_assigned = true
      days = []

      if daily_instances
        # get reservation daily instance info
        days = get_res_daily_instance_info(daily_instances, is_reservation_rate_suppressed)
      end
      bill_hash['days'] = days

      # Add CC details for bill 1 if no bills present
      bill_hash['credit_card_details']  = map_bill_credit_card_hash(reservation, '1')
      #bill_hash['guest_or_company_name'] = map_guest_or_company_name(each_bill_instance) Commenting since this key may not be used in bill screen. Need to confirm with UI team.

      if reservation.addons.present?
        addons = get_reservation_addons(reservation)
        bill_hash['addons'] = addons
      end
      # Changed from push to unshift so that bill number 1 is alwasy on top
      bills.unshift(bill_hash)
    end

    bill_card['bills']  = bills
    bill_card['number_of_bills'] = bills.count
    # To get all routing information for a reservation
    bill_card['routing_array'] = map_bill_routings_array(reservation)
    bill_card['incoming_routing_array'] = map_incoming_bill_routings_array(reservation)
    bill_card['account_id'] = reservation.company.andand.id || reservation.travel_agent.andand.id
    bill_card['ar_number'] = reservation.company.andand.ar_detail.andand.ar_number || reservation.travel_agent.andand.ar_detail.andand.ar_number
    bill_card['is_hourly'] = reservation.is_hourly
    bill_card['deposit_amount']=  ('%.2f' % reservation.balance_deposit_amount).to_s
    bill_card['is_disabled_terms_conditions_checkin'] = current_hotel.settings.disable_terms_conditions_checkin.to_s
    bill_card['is_disabled_cc_swipe'] = current_hotel.settings.disable_cc_swipe.to_s
    bill_card['is_early_departure_penalty_disabled'] = current_hotel.settings.disable_early_departure_penalty == true ? true : false
    bill_card['is_res_posting_control_disabled'] = current_hotel.settings.disable_reservation_posting_control == true ? true : false
    bill_card
  end

  # get credit card name on the bill
  def self.get_bill_credit_card_name(bill_hash)
    bill_hash['credit_card_details']['card_name'].present? ? bill_hash['credit_card_details']['card_name'].to_s : ''
  end

  # Iterate each routing entry for a reservation
  def self.map_bill_routings_array(reservation)
    reservation.charge_routings.map { |routing| map_bill_routings_hash(routing) }
  end

  # Iterate each routing entry for a reservation
  def self.map_incoming_bill_routings_array(reservation)
    reservation.incoming_charge_routings.joins(bill: :reservation).where('reservations.id != ?', reservation.id).map { |routing| map_incoming_bill_routings_hash(routing) }
  end

  # Hash for routing
  def self.map_bill_routings_hash(routing)
    {
      'routing_id' => routing.id,
      'bill_number' => routing.to_bill.andand.bill_number.to_s,
      'details' => routing.external_routing_instructions,
      'guest_or_company' => routing.owner_name.to_s,
      'room_no' => routing.room.andand.room_no.to_s
    }
  end

  # Hash for incoming routing
  def self.map_incoming_bill_routings_hash(routing)
    {
      'routing_id' => routing.id,
      'room_no' => routing.bill.reservation.current_daily_instance.room.andand.room_no.to_s,
      'guest_name' => routing.bill.reservation.primary_guest.andand.full_name,
      'details' => routing.external_routing_instructions
    }
  end

  # get hash for credit card info for a bill on reservation
  def self.map_bill_credit_card_hash(reservation, bill_number)
    reservation_credit_card_hash = {}
    hotel = reservation.hotel
    bill_payment_method = reservation.bill_payment_method(bill_number)
    payment_type = bill_payment_method.andand.payment_type
    
    if bill_payment_method
      reservation_credit_card_hash['payment_type'] = payment_type.is_cc?(hotel) ? PaymentType.credit_card.value.to_s : bill_payment_method.payment_type.value.to_s
      reservation_credit_card_hash['payment_type_description'] = bill_payment_method.payment_type.description
      card_code = ''
      if (payment_type.andand.is_cc?(hotel) && !payment_type.andand.credit_card?)
        card_code = "credit-card"
      else
        card_code = bill_payment_method.credit_card_type.to_s.downcase
      end
      reservation_credit_card_hash['card_code'] = card_code
      reservation_credit_card_hash['card_number'] = bill_payment_method.mli_token_display.to_s
      reservation_credit_card_hash['card_expiry'] = bill_payment_method.card_expiry ? bill_payment_method.card_expiry_display : ''
      reservation_credit_card_hash['payment_id'] = bill_payment_method.id
      reservation_credit_card_hash['card_name'] = bill_payment_method.card_name
      reservation_credit_card_hash['is_swiped'] = bill_payment_method.is_swiped
      reservation_credit_card_hash['fees_information'] = bill_payment_method.fees_information(hotel)
    end
    reservation_credit_card_hash
  end

  # get reservation, room and housekeeping info for a reservation
  def self.get_reservation_info(reservation, current_daily_instance, current_hotel, is_reservation_rate_suppressed)
    res_card = {}
    # get room info and status
    room = current_daily_instance.andand.room
    room_status = room.is_ready? ? 'READY' : 'NOTREADY' if room
    # qr_flag = (reservation.hotel.settings.room_key_delivery_for_rover_check_in == "qr_code_tablet")
    res_card['key_settings'] = reservation.hotel.settings.room_key_delivery_for_rover_check_in
    res_card['hotel_selected_key_system'] = reservation.hotel.key_system.to_s
    res_card['reservation_id']  = reservation.id
    res_card['icare_enabled'] = reservation.hotel.settings.icare_enabled.to_s
    res_card['combined_key_room_charge_create'] = reservation.hotel.settings.icare_combined_key_room_charge_create.to_s
    res_card['confirm_no']  = reservation.confirm_no
    res_card['reservation_status']  = ViewMappings::StayCardMapping.map_view_status(reservation, current_hotel.active_business_date)
    res_card['room_number']  = room ? room.room_no : ''
    res_card['room_status']  = room_status.to_s
    res_card['no_post'] = reservation.no_post.to_s
    res_card['room_type']    = room ? room.room_type.room_type : ''
    res_card['room_type_name']    = room ? room.room_type.room_type_name : ''
    res_card['checkin_date']   =  reservation.arrival_date
    res_card['checkout_date']  = reservation.dep_date
    res_card['number_of_nights'] = reservation.total_nights
    res_card['fo_status']  = room.andand.mapped_fo_status
    res_card['currency_code']  = current_daily_instance.currency_code.andand.value
    res_card['is_promotions_and_email_set'] = reservation.primary_guest.andand.is_opted_promotion_email ? 'true' : 'false'
    res_card['required_signature_at'] = reservation.hotel.settings.require_signature_at || ''
    res_card['is_auto_assign_ar_numbers'] = reservation.hotel.settings.is_auto_assign_ar_numbers ? 'true' : 'false'
    res_card['room_ready_status'] = room.andand.hk_status.to_s
    res_card['use_inspected'] = current_hotel.settings.use_inspected.to_s
    res_card['use_pickup'] = current_hotel.settings.use_pickup.to_s
    res_card['checkin_inspected_only'] = current_hotel.settings.checkin_inspected_only.to_s
    res_card['enable_room_status_at_checkout'] = current_hotel.settings.enable_room_status_at_checkout.to_s
    # res_card['is_rates_suppressed'] = is_reservation_rate_suppressed.to_s
    # res_card['text_rates_suppressed'] = is_reservation_rate_suppressed ? 'SR' : ''

    res_card['signature_details'] = get_signature_details(reservation)
    res_card['is_advance_bill'] = reservation.is_advance_bill
    res_card['is_rate_suppressed_present_in_stay_dates'] = reservation.suppress_rate_present_in_daily_instances.present?
    res_card['reservation_balance'] = reservation.current_balance
    res_card
  end

  # get signature details
  def self.get_signature_details(reservation)
    {
      'is_signed' => reservation.signature.present? ? 'true' : 'false',
      'signed_image' => reservation.signature.present? ? "data:image/jpeg;base64, #{Base64.encode64(reservation.signature.andand.data.to_s)}" : '',
      'signed_date' => reservation.signature.present? ? reservation.signature.created_at.utc.in_time_zone(reservation.hotel.tz_info).strftime('%Y-%m-%d') : '',
      'signed_time' => reservation.signature.present? ? reservation.signature.created_at.utc.in_time_zone(reservation.hotel.tz_info).strftime(%'I:%M %p') : ''
    }
  end

  # get signed date time
  def self.get_signed_date_time(reservation)
    reservation.signature.present? ? reservation.signature.created_at.utc.in_time_zone(reservation.hotel.tz_info).strftime('%m-%d-%Y %I:%M %p') : ''
  end

  # get reservation addons
  def self.get_reservation_addons(reservation)
    addons = []
    package_type = 'PACKAGES'
    packages_amount = reservation.reservations_addons.sum(:price)
    if reservation.addons.rate_inclusive_addons.present? && reservation.addons.rate_exclusive_addons.present?
      package_type = 'MULTI'
    elsif reservation.addons.rate_inclusive_addons.present?
      package_type = 'INCL'
    end

    expense_details = reservation.addons.map do|addon|
      reservation_addon = reservation.reservations_addons.where(addon_id: addon.id).first
      {
        'is_inclusive' => reservation_addon.is_inclusive_in_rate ? 'true' : 'false',
        'price' => reservation_addon.price ? NumberUtility.default_amount_format(reservation_addon.price) : '',
        'package' => addon.description
      }
    end
    addons << {
      'title' => 'Packages',
      'package_type'  => package_type,
      'amount' => NumberUtility.default_amount_format(packages_amount).to_s,
      'expense_details' => expense_details
    }
    addons
  end

  # get reservation daily instance info
  def self.get_res_daily_instance_info(daily_instances, is_reservation_rate_suppressed)
    # For Connected PMS works for SR based on the reservation flag
    # For standalone PMS, we need to check each daily rate and check whether this is SR or not.
    current_hotel = daily_instances.first.reservation.hotel
    if daily_instances
      daily_instances.map do |daily_instance|
        if  current_hotel.is_third_party_pms_configured?
          amount = is_reservation_rate_suppressed ? Setting.suppressed_rate :
                   NumberUtility.default_amount_format(daily_instance.rate_amount)
        else
          amount = daily_instance.sr_rate? ? Setting.suppressed_rate :
                   NumberUtility.default_amount_format(daily_instance.rate_amount)
        end
        {
          'date' => daily_instance.reservation_date,
          'amount' => amount,
          'rate_name' => daily_instance.rate.andand.rate_name,
          'rate_description' => daily_instance.rate.andand.rate_desc,
          'room_type_name' => daily_instance.room_type.room_type_name,
          'room_type_description' => daily_instance.room_type.description
        }
      end
    end
  end

  # get finiancial transactions groups details
  def self.get_financial_tran_groups(financial_records_debits)
    # get financial transaction for charge groups
    financial_records_groups = financial_records_debits.joins(charge_code: :charge_groups)
    .select('charge_groups.id as id, charge_groups.description as description, sum(financial_transactions.amount) as amount')
    .group('charge_groups.id') if financial_records_debits

    if financial_records_groups

      group_items = financial_records_groups.map do |each_record|
        expense_info = Array.new
        expense_info = financial_records_debits.joins(charge_code: :charge_groups)
        .select('charge_codes.description as description, financial_transactions.date as date, financial_transactions.id as fin_id, financial_transactions.amount as amount, '\
                'financial_transactions.external_id as external_id')
        .where('charge_groups.id = ?', each_record.id) if financial_records_debits
        # .order('financial_transactions.date, financial_transactions.external_id, financial_transactions.updated_at')

        expense_details = Array.new
        if expense_info
          expense_details = expense_info.map do |expense_record|
            {
              'expense' => expense_record.amount.to_s,
              'location' => expense_record.description,
              'date' => expense_record.date,
              'transaction_id' => expense_record.external_id,
              'id' => expense_record.fin_id
            }
          end
        end
        {
          'title'  => each_record.description,
          'amount' => NumberUtility.default_amount_format(each_record.amount),
          'expense_details' => expense_details
        }
      end
    end
    group_items
  end

  # structure the revenues to show debits
  def self.get_financial_transaction_details(financial_records, reservation, is_reservation_rate_suppressed, bill_hash)
    # structure the revenues to show debits
    fin_fees_details = financial_records#.order('date, external_id, financial_transactions.updated_at') if financial_records
    #
    if fin_fees_details
      make_all_charges_suppressed = false
      # Check if any rate is SR. If yes then make all the charges as SR
      current_hotel = reservation.hotel
      if current_hotel.is_third_party_pms_configured?
        make_all_charges_suppressed = true if is_reservation_rate_suppressed && fin_fees_details.include_room.exists?
      else
        make_all_charges_suppressed = reservation.current_daily_instance.sr_rate? if fin_fees_details.include_room.exists?
      end
      parent_transactions = []
      fees_details = fin_fees_details.where('parent_transaction_id IS NULL AND original_transaction_id IS NULL').each do |fee|
        parent_transactions << fee 
        adjusted_transactions = fee.adjusted_transactions
        
        while(!adjusted_transactions.empty?) do
          adjusted_transactions.each do |transaction|
            parent_transactions << transaction
            adjusted_transactions = transaction.adjusted_transactions
          end
        end
      end

      fee_transactions = []
      parent_transactions.each do |parent|
        if parent
          fee_transactions << parent
          child_transactions = parent.child_transactions
          if !child_transactions.empty?
            child_transactions.order('financial_transactions.charge_code_id').each do |child|
              fee_transactions << child
            end
          end
        end
      end       

      fin_fees_details = fee_transactions
      fees_details = fin_fees_details.map do|financial_transaction|

        desc_main = Array.new
        @credits = ''
        if !(financial_transaction.andand.charge_code.andand.charge_code_type === :PAYMENT)
          # if financial_transaction.original_transaction_id
          #   orig_transactions = fin_fees_details.select{|t|t.id=financial_transaction.original_transaction_id}
          #   order_field = orig_transactions.first.order_field
          # else
          #   order_field = financial_transaction.order_field
          # end
          desc_main = [
            'fees_desc' => financial_transaction.andand.charge_code.andand.description,
            'charge_code' => financial_transaction.andand.charge_code.andand.charge_code,
            'fees_amount' => make_all_charges_suppressed ? Setting.suppressed_rate :
                             NumberUtility.default_amount_format(financial_transaction.amount)
          ]
        else
          desc_main = [
            'fees_desc' => financial_transaction.andand.charge_code.andand.description,
             'charge_code' => financial_transaction.andand.charge_code.andand.charge_code
          ]
          @credits = make_all_charges_suppressed ? Setting.suppressed_rate :
                     NumberUtility.default_amount_format(financial_transaction.amount)
        end

        description = desc_main
        {
          'type' => financial_transaction.charge_code.andand.charge_code_type ,
          'date' => financial_transaction.date,
          'description' => description,
          'credits' => @credits,
          'transaction_id' => financial_transaction.external_id,
          'id' => financial_transaction.id,
          'reference_text' => financial_transaction.andand.reference_text.to_s
        }
      end
      
      total_fees = [
        'total_amount' => make_all_charges_suppressed ? Setting.suppressed_rate :
                          NumberUtility.default_amount_format(bill_hash['total_amount']),
        'balance_amount' => make_all_charges_suppressed ? Setting.suppressed_rate :
                            NumberUtility.default_amount_format((bill_hash['total_amount'].to_f - bill_hash['total_payments'].to_f)).to_s,
        'fees_date' => formatted_date(reservation.current_daily_instance.reservation_date),
        'fees_details' => fees_details
      ]
    end

    [total_fees, make_all_charges_suppressed]
  end

  # get total amount and payments
  def self.get_bill_hash_amounts(bill_hash, make_all_charges_suppressed)
    total_amount = make_all_charges_suppressed ? Setting.suppressed_rate : NumberUtility.default_amount_format(bill_hash['total_amount'])
    total_payments = make_all_charges_suppressed ? Setting.suppressed_rate : NumberUtility.default_amount_format(bill_hash['total_payments'])

    [total_amount, total_payments]
  end

  def self.map_guest_or_company_name(bill)
    account_name = nil
    if bill.reservation.hotel.is_third_party_pms_configured?
      account_routing_on_bill = bill.incoming_charge_routings.where("room_id IS NULL").first
      account_name = account_routing_on_bill.owner_name if account_routing_on_bill
    else
      account_name = bill.account.account_name if bill.account.present?
      # Commenting as per the modification suggested by nicole in CICO-6080
      # if bill.account.present?
      #  account_name = bill.account.account_name
      # else
      #  account_name = bill.reservation.company.andand.account_name || bill.reservation.travel_agent.andand.account_name
      # end
    end
    account_name.to_s
  end
end
