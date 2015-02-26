class ReservationCreator
  
  def initialize(params, hotel_id)
    @params = params
    @hotel = Hotel.find(hotel_id)
  end
  
  def create
    begin
      errors = []
      data = {}
      status = false
      confirmation_emails = @params[:confirmation_emails]
      tax_details = @params[:tax_details]
      @reservations_list = []
      if !cards_valid?
        errors << I18n.t('reservation_cards.one_card_required')
      elsif !emails_valid?(confirmation_emails)
        errors << I18n.t('mailer.reservation_mailer.email_validation')
      else
        Reservation.transaction do
          if @params[:room_id] && !@params[:room_id].empty?
            @params[:room_id].each do |room_id|
              room = Room.find(room_id)
              departure_datetime = @params[:departure_time]
              arrival_datetime = @params[:arrival_time]
              # Check whether the requested room is assigned to any other reservations in the time span
              existing_reservation_count = room.reservation_daily_instances.joins(:reservation).
                                           where("reservations.arrival_time <= ? and reservations.departure_time >= ?", 
                                           departure_datetime, arrival_datetime).where("reservations.status_id NOT IN (?,?)", 
                                           Ref::ReservationStatus[:NOSHOW].id, Ref::ReservationStatus[:CANCELED].id).uniq.count
              # If exsting room counts goes greater than zero, break the loop
              if existing_reservation_count > 0
                errors << I18n.t('room_not_available')
                break
              else
                YOTEL_LOGGER.info("params[:room_id] is #{room_id}")
                @reservation = Reservation.create!(reservation_attributes)
                (@reservation.arrival_date..@reservation.dep_date).each { |day|
                  @reservation.daily_instances.create!(daily_instance_attributes(day, @reservation))
                  # Update Inventory count - Based on story CICO-8604
                  if day != @reservation.dep_date || @reservation.dep_date == @reservation.arrival_date
                    stay_date = stay_attributes(day)
                    inventory_detail = InventoryDetail.record!(stay_date[:rate_id], stay_date[:room_type_id], @hotel.id, day, true) if stay_date.present?
                  end
                }
                @reservation.daily_instances.update_all(room_id: room_id)
                update_guest!(@reservation) if @params[:guest_detail_id]
                @reservation.reservations_addons.create!(addons_attributes) if @params[:addons]
                
                # PaymentMethod.create_on_reservation!(@reservation, payment_type_attributes, false) if @params[:payment_type].present?
                @reservation.payment_methods.create!(payment_type_attributes) if @params[:payment_type].present?
                Bill.create_or_update_bills(@params[:payment], @reservation) if @params[:payment].present?
                @reservations_list << @reservation
              end
            end
          else
            YOTEL_LOGGER.info("params[:room_id] is empty")
            @reservation = Reservation.create!(reservation_attributes)
            (@reservation.arrival_date..@reservation.dep_date).each { |day|

              @reservation.daily_instances.create!(daily_instance_attributes(day, @reservation))
              # Update Inventory count - Based on story CICO-8604
              if day != @reservation.dep_date || @reservation.dep_date == @reservation.arrival_date
                stay_date = stay_attributes(day)
                inventory_detail = InventoryDetail.record!(stay_date[:rate_id], stay_date[:room_type_id], @hotel.id, day, true) if stay_date.present?
              end
            } 
            update_guest!(@reservation) if @params[:guest_detail_id]
            @reservation.reservations_addons.create!(addons_attributes) if @params[:addons]
              
            PaymentMethod.create_on_reservation!(@reservation, payment_type_attributes, false) if @params[:payment_type].present?
            Bill.create_or_update_bills(@params[:payment], @reservation)
            @reservations_list << @reservation
          end
        end
      end
      if errors.present?
        errors =  errors      
      else
        send_confirmation_emails(confirmation_emails, tax_details, @reservation)
        reservation_details = @reservations_list.map { |reservation| {id: reservation.id, confirmation_no: reservation.confirm_no} }
        data = {confirm_no: @reservation.confirm_no}
      end
      { errors: errors, data: data}
    rescue ActiveRecord::RecordInvalid => e
      {errors: e.record.errors.full_messages}
    end
  end
  
  def cards_valid?
    @params[:guest_detail_id] || @params[:company_id] || @params[:travel_agent_id]
  end
  
  def emails_valid?(emails)
    !emails.andand.select { |email| email.present? && !email.match(/\A[^@]+@[^@]+\z/) }.present?
  end
  
  def reservation_attributes
    {
      hotel_id: @hotel.id,
      arrival_date: @params[:arrival_date],
      arrival_time: @params[:arrival_time],
      dep_date: @params[:departure_date],
      departure_time: @params[:departure_time],
      company_id: @params[:company_id],
      travel_agent_id: @params[:travel_agent_id],
      reservation_type_id: @params[:reservation_type_id],
      source_id: @params[:source_id],
      market_segment_id: @params[:market_segment_id],
      booking_origin_id: @params[:booking_origin_id],
      status: :RESERVED,
      is_hourly: @params[:is_hourly],
      creator_id: @params[:creator_id],
      updator_id: @params[:updator_id]
    }
  end
  
  def daily_instance_attributes(day, reservation)
    stay_date = @params[:stay_dates].select { |date| Date.parse(date[:date]) == day }.first if @params[:stay_dates]

    if stay_date
      @begin_date = @reservation.arrival_date
      @begin_time =@reservation.arrival_time.andand.in_time_zone(@hotel.tz_info).andand.utc
      @end_time = @reservation.departure_time.andand.in_time_zone(@hotel.tz_info).andand.utc
      rate = Rate.find(stay_date[:rate_id])
      room_type = RoomType.find(stay_date[:room_type_id])
      adults = stay_date[:adults_count]
      children = stay_date[:children_count] || 0
      infants = stay_date[:infants_count] || 0
      # Changing actual_rate_amount calculation from rate.calculate_hourly_rate_amount(@begin_date, room_type, @begin_time, @end_time)
      # to @params[:passed_rate_amount], as per Gop's requirement to honor the Yotel API and to proceed with the amount passed by it.
      actual_rate_amount = @params[:passed_rate_amount] 
      rate_amount = stay_date[:date].to_date == @begin_date ? actual_rate_amount : 0 if rate.is_hourly_rate
      {
        reservation_date: day,
        adults: adults,
        children: children,
        infants: infants,
        rate_id: rate.andand.id,
        room_type_id: room_type.andand.id,
        status: reservation.status,
        rate_amount: rate_amount,
        original_rate_amount: actual_rate_amount,
        currency_code: @hotel.default_currency
      }
    end
  end
  
  def stay_attributes(day)
    stay_date = @params[:stay_dates].select { |date| Date.parse(date[:date]) == day }.first if @params[:stay_dates]
  end
  
  def addons_attributes
    @params[:addons].map do |addon_attribute|
      addon = Addon.find(addon_attribute[:id])

      {
        addon_id: addon_attribute[:id],
        quantity: addon_attribute[:quantity],
        price: addon.amount,
        is_inclusive_in_rate: false
      }
    end
  end
  
  def update_guest!(reservation)
    guest_detail = GuestDetail.find(@params[:guest_detail_id])
    reservation.reservations_guest_details.create!(guest_detail_id: guest_detail.id, is_primary: true)
  end
  
  def payment_type_attributes
    payment_type = @params[:payment_type]

    attributes = {
      payment_type: PaymentType.find(payment_type[:type_id]),
      credit_card_type: payment_type[:credit_card_type_id],
      card_name: payment_type[:card_name],
      card_expiry: payment_type[:expiry_date],
      bill_number: 1,
      credit_card_transactions_attributes: [payment_type[:credit_card_transactions_attributes]]
    }
    # attributes[:session_id] = payment_type[:session_id] if payment_type.key?(:session_id)
    # attributes[:card_number] = payment_type[:card_number] if payment_type.key?(:card_number)
    
    # # CICO-9283 - iPage credit card transaction 
    # attributes[:is_six_payment] = false
    # if payment_type.key?(:isSixPayment) && payment_type[:isSixPayment]
    #   attributes[:is_six_payment] = true
    #   attributes[:token] = payment_type[:token]
    # end
    
    attributes
  end
  
  def send_confirmation_emails(emails, tax_details, reservation)
    reservation.tax_details = tax_details
    emails.andand.each do |email|
      begin
        ReservationMailer.send_confirmation_number_mail(@reservation, email).deliver!
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        logger.error "Standalone PMS Confirmation Number Sending Failed - " \
                     "Email not sent confirmation number #{@reservation.confirm_no} to #{email} : #{e.message}"
      end
    end
  end
  
end