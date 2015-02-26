class Staff::PaymentsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  def payment
    guest_detail = GuestDetail.find(params[:user_id])
    payment_methods = guest_detail.payment_methods
    
    # Filtering for credit cards
    payment_methods = payment_methods.select {|payment_method| payment_method.payment_type.andand.is_cc?(current_hotel) }
    
    @payment_records = payment_methods.map do |payment_method|
      payment_type = payment_method.payment_type;
      card_code = ''
      if (payment_type.andand.is_cc?(current_hotel) && !payment_type.andand.credit_card?)
        card_code = "credit-card"
      else
        card_code = payment_method.credit_card_type.andand.value.andand.downcase
      end
      payment_method.attributes.merge(
        payment_type: payment_method.andand.payment_type.andand.is_cc?(current_hotel) ? 
                            PaymentType.credit_card.value.andand.upcase : payment_method.payment_type.andand.description,
        card_expiry: payment_method.card_expiry_display == 'XXXX-XX-XX' ? 'XX/XX' : payment_method.card_expiry_display,
        card_code: card_code,
        mli_token: payment_method.mli_token_display,
        fees_details: payment_method.fees_information(current_hotel),
        is_credit_card: payment_method.payment_type.andand.is_cc?(current_hotel)
      )
    end
    
    render json: { status: SUCCESS, data: @payment_records, errors: [] }
  end

  # function to show the set as primary and delete modal
  def showCreditModal
    @credit_card = params[:id]
    render partial: 'modals/creditCardSetAsPrimary'
  end

  # function to set selected guest credit card as primary
  def setCreditAsPrimary
    guest_detail = GuestDetail.find(params[:user_id])

    errors = []

    # Set all other payment types to not primary
    guest_detail.payment_methods.update_all(is_primary: false)

    # Update selected payment type to primary
    payment_method = PaymentMethod.find(params[:id])
    payment_method.is_primary = true

    if payment_method.external_id && payment_method.credit_card?
      guest_api = GuestApi.new(current_hotel.id)

      api_result = guest_api.update_credit_card(payment_method.external_id, payment_method.credit_card_type.value, payment_method.is_primary,
                                                payment_method.card_name, payment_method.mli_token, payment_method.card_expiry)

      errors << I18n.t(:external_pms_failed) unless api_result[:status]
    end

    payment_method.save! if errors.empty?

    respond_to do |format|
      if errors.empty?
        format.json { render json: { status: SUCCESS, data: [], errors: nil } }
      else
        format.json { render json: { status: FAILURE, data: [], errors: errors } }
      end
    end
  end

  # function to delete selected guest credit card
  def deleteCreditCard
    errors = []

    payment_method = PaymentMethod.find(params[:id])
    guest_detail = payment_method.associated

    if current_hotel.is_third_party_pms_configured? && payment_method.external_id && payment_method.credit_card?
      guest_api = GuestApi.new(current_hotel.id)
      api_result = guest_api.delete_credit_card(payment_method.external_id)

      errors << I18n.t(:external_pms_failed) unless api_result[:status]
    end

    payment_method.destroy if errors.empty?

    # If there is only one card left, make it primary
    if guest_detail.payment_methods.count == 1
      remaining_payment_method = guest_detail.payment_methods.first
      remaining_payment_method.is_primary = true
      remaining_payment_method.save!

      if current_hotel.is_third_party_pms_configured? && remaining_payment_method.external_id && remaining_payment_method.credit_card?
        guest_api = GuestApi.new(current_hotel.id)
        guest_api.update_credit_card(remaining_payment_method.external_id, remaining_payment_method.credit_card_type.value,
                                     remaining_payment_method.is_primary, remaining_payment_method.card_name, remaining_payment_method.mli_token,
                                     remaining_payment_method.card_expiry)
      end
    end

    respond_to do |format|
      if errors.empty?
        format.json { render json: { status: SUCCESS, data: [], errors: nil } }
      else
        format.json { render json: { status: FAILURE, data: [], errors: errors } }
      end
    end
  end

  # function to show add new payment screen
  def addNewPayment
    # fetch current hotel payment types
    #payment_types = current_hotel.is_third_party_pms_configured? ? current_hotel.payment_types.selectable : current_hotel.payment_types
    
    #CICO-10426 
    payment_types = PaymentType.activated_non_credit_card(current_hotel).order(:description)
    
    
    @payments_hash = {}
    # Final JSON Array
    @resultant_array = []

    # To save the values for each payment type For eg: CC, MA, VA etc

    payment_types.each do |payment_type|
      values_array = []
      
            
      payment_type_hash = Hash.new
      payment_type_hash['id'] = payment_type.id
      payment_type_hash['name'] = payment_type.value
      payment_type_hash['description'] = payment_type.description
      hotel_payment_type = HotelsPaymentType.where(:hotel_id => current_hotel.id, :payment_type_id => payment_type.id).first
      payment_type_hash['is_display_reference'] = hotel_payment_type.andand.is_display_reference
      
      payment_type_hash['charge_code'] = {}
      charge_code = payment_type.charge_code(current_hotel)
      unless charge_code.nil?
        payment_type_hash['charge_code']['id'] = charge_code.id
        payment_type_hash['charge_code']['fees_information'] = charge_code.fees_information
      end
      
      value_list = payment_type.credit_card? ? PaymentType.activated_credit_card(current_hotel) + current_hotel.credit_card_types : []
      value_list.each do |each_value|
        sub_hash  = {}
        sub_hash['id'] = each_value.id
        sub_hash['cardname'] = each_value.description
        sub_hash['cardcode'] = each_value.value
        
        hotel_credit_card_type = each_value.is_a?(PaymentType) ? 
                HotelsPaymentType.where(:hotel_id => current_hotel.id, :payment_type_id => each_value.id).first : 
                HotelsCreditCardType.where(:hotel_id => current_hotel.id, :ref_credit_card_type_id => each_value.id).first
                
        sub_hash['is_display_reference'] = hotel_credit_card_type.andand.is_display_reference
        
        sub_hash['charge_code'] = {}
        charge_code = each_value.charge_code(current_hotel)
        unless charge_code.nil?
          sub_hash['charge_code']['id'] = charge_code.id
          sub_hash['charge_code']['fees_information'] = charge_code.fees_information
        end
        
        values_array << sub_hash
      end

      payment_type_hash['values'] = values_array
      @resultant_array.push(payment_type_hash) unless (current_hotel.is_third_party_pms_configured? && !payment_type.credit_card?)
    end

    @payments_hash[:payment_types] = @resultant_array
    @payments_hash[:card_action] = params[:card_action]

    respond_to do |format|
      format.html { render partial: 'modals/addNewPayment' }
      format.json { render json: { status: SUCCESS, data: @resultant_array, errors: nil } }
    end
  end

  def save_new_payment
    guest_detail = GuestDetail.find(params[:user_id])
    attributes = ViewMappings::PaymentTypeMapping.map_payment_type(params)
    
    if params[:card_code].present?
      card_code = params[:card_code]
      # Check whether it is system defined one
      credit_card_type = Ref::CreditCardType[card_code.upcase.to_sym]
      
      # If the card_type is custom
      if credit_card_type.nil?
        custom_credit_card = PaymentType.where("hotel_id = ? AND UPPER(value) = ?", current_hotel.id, card_code.upcase).first
        attributes[:custom_payment_type] = custom_credit_card.andand.value
      end
    end
    
    result = PaymentMethod.create_on_guest!(guest_detail, current_hotel, attributes)
    
    errors = result[:errors]

    respond_to do |format|
      if errors.empty?
        format.json { render json: { status: SUCCESS, data: { id: result[:payment_method].id, payment_name: result[:payment_method].payment_type.andand.value, fees_information: result[:payment_method].andand.fees_information(current_hotel) }, errors: nil } }
      else
        format.json { render json: { status: FAILURE, data: {}, errors: errors } }
      end
    end
  end

  # Get the MLI token for the encrypted card data. Required parameters:
  # - et2 or etb
  # - ksn
  def tokenize
    errors = []
    mli_token = nil

    if (params[:et2] || params[:etb]) && params[:ksn]
      logger.debug "Card Swipe - tokenize - Parameters et2 = #{params[:et2]}, etb = #{params[:etb]}, ksn = #{params[:ksn]}"
      
      is_encrypted = params[:is_encrypted]
      result = Mli.new(current_hotel).get_token(et2: params[:et2], etb: params[:etb], ksn: params[:ksn], is_encrypted: is_encrypted, card_number: params[:et2])

      if result[:status]
        mli_token = result[:data]
        logger.debug "Card Swipe - tokenize - MLI TOKEN #{mli_token}"
      else
        errors += result[:errors]
      end
    else
      errors << 'et2 / etb and ksn are required parameters'
    end

    render json: { status: errors.empty? ? SUCCESS : FAILURE, data: mli_token, errors: errors }
  end

  # Accepts encrypted credit card data, looks up the token, and returns the first closest reserved/checked-in reservation. Required parameters:
  # - et2 or etb
  # - ksn
  def search_by_cc
    errors = []

    if (params[:et2] || params[:etb]) && params[:ksn]
      logger.debug "Card Swipe - search_by_cc - Parameters et2 = #{params[:et2]}, etb = #{params[:etb]}, ksn = #{params[:ksn]}"

      result = Mli.new(current_hotel).get_token(et2: params[:et2], etb: params[:etb], ksn: params[:ksn], card_number: params[:et2], is_encrypted: params[:is_encrypted])

      if result[:status]
        mli_token = result[:data]
        logger.debug "Card Swipe - search_by_cc - MLI TOKEN #{mli_token}"
        reserved_status_id = Ref::ReservationStatus[:RESERVED].id
        inhouse_id = Ref::ReservationStatus[:CHECKEDIN].id
        checked_out_id = Ref::ReservationStatus[:CHECKEDOUT].id
        active_business_date = current_hotel.active_business_date

        # Find the reserved/checked-in reservations that has the MLI token
        reservations = current_hotel.reservations.joins(:payment_methods).with_status(:RESERVED, :CHECKEDIN)
          .where('payment_methods.mli_token = ?', mli_token)
          .where("reservations.dep_date >= '#{active_business_date - 7.days}'")
          .order('CASE '\
        "when reservations.status_id = #{reserved_status_id} and reservations.arrival_date = '#{active_business_date}' then 1 "\
        "when reservations.status_id = #{inhouse_id} and reservations.dep_date > '#{active_business_date}' then 2 "\
        "when reservations.status_id = #{inhouse_id} and reservations.dep_date = '#{active_business_date}' then 3 "\
        "when reservations.status_id = #{reserved_status_id} and reservations.arrival_date > '#{active_business_date}' then 4 "\
        "when reservations.status_id = #{checked_out_id} and reservations.dep_date <'#{active_business_date}' then 5 "\
        "else 6 END")

        # Active business date for the current_hotel
        active_business_date = current_hotel.active_business_date
        is_late_checkout_on = current_hotel.settings.late_checkout_is_on

         # Build reset hash for each reservation
        results = reservations.map do |reservation|
          guest_detail = reservation.primary_guest
          primary_address = guest_detail.addresses.primary.first
          location = primary_address.andand.city_state
          room = reservation.current_daily_instance.room
          
          guest_images = []

          if guest_detail
            # To fix defect CICO-9877 - Need to optimize later since we already build the guest detail inorder to prevent n+1 problem
            guest_images << { is_primary: true, guest_image: guest_detail.avatar.url(:thumb).to_s }
          end
          
          result = {
            id: reservation.id,
            confirmation: reservation.confirm_no,
            room: room.andand.room_no,
            group: reservation.current_daily_instance.andand.group.andand.name.to_s,
            reservation_status: ViewMappings::StayCardMapping.map_view_status(reservation, active_business_date),
            roomstatus: room.andand.is_ready? ? 'READY' : 'NOTREADY',
            fostatus: room.andand.mapped_fo_status || '',
            lastname: guest_detail.last_name,
            firstname: guest_detail.first_name,
            location: location,
            vip: guest_detail.is_vip,
            images: guest_images
          }

          if is_late_checkout_on
            result[:is_opted_late_checkout] = reservation.is_opted_late_checkout
            result[:late_checkout_time] = reservation.late_checkout_time.andand.strftime('%l:%M %p')
          end

          result
        end

      else
        errors += result[:errors]
      end
    else
      errors << 'et2 / etb and ksn are required parameters'
    end

    render json: { status: errors.empty? ? SUCCESS : FAILURE, data: results, errors: errors }
    logger.error "Card Swipe - search_by_cc - Error = #{errors}"  unless errors.empty?
  end
end
