class Admin::HotelPaymentTypesController < ApplicationController
  before_filter :check_session

  # GET /hotel_payment_types
  # GET /hotel_payment_types.json
  def index
    payment_types = current_hotel.payment_types
                        .where('hotels_payment_types.is_cc = ? OR payment_types.hotel_id IS NULL', false)
                        .order(:description) #PaymentType.hotel_payment_types(current_hotel)
    
    credit_card_types = current_hotel.credit_card_types.all
    hotel_payment_type_ids = current_hotel.payment_types.pluck(:id)
    hotel_credit_card_type_ids = current_hotel.credit_card_types.pluck(:id)
    
    cc_payment_types = current_hotel.payment_types.where('hotels_payment_types.is_cc = ?', true).where('payment_types.hotel_id = ?', current_hotel.id)
    # Updated in CICO-10426
    
    data = {
      payments: payment_types.map do |payment_type|
        hotel_payment_type = HotelsPaymentType.where(:hotel_id => current_hotel.id, :payment_type_id => payment_type.id).first;
        { 
          id: payment_type.id.to_s, 
          value: payment_type.value.to_s, 
          description: payment_type.description, 
          is_system_defined: payment_type.hotel_id.nil?, 
          is_active: hotel_payment_type.active.to_s,
          is_cc: hotel_payment_type.is_cc,
          is_offline: hotel_payment_type.is_offline,
          is_rover_only: hotel_payment_type.is_rover_only,
          is_web_only: hotel_payment_type.is_web_only,
          is_display_reference: hotel_payment_type.is_display_reference
        }
      end,
      
      credit_card_types: credit_card_types.map do |credit_card_type|
        hotel_credit_card_type = current_hotel.hotels_credit_card_types.where(:ref_credit_card_type_id => credit_card_type.id).first;
        { 
          id: credit_card_type.id.to_s, 
          description: credit_card_type.description.titlecase, 
          is_system_defined: true,
          is_active: hotel_credit_card_type.active.to_s,
          is_cc: hotel_credit_card_type.is_cc,
          is_offline: hotel_credit_card_type.is_offline,
          is_rover_only: hotel_credit_card_type.is_rover_only,
          is_web_only: hotel_credit_card_type.is_web_only,
          is_display_reference: hotel_credit_card_type.is_display_reference
        }
      end
    }
    
    cc_payment_types.each do |cc_payment_type|
      hotel_payment_type = HotelsPaymentType.where(:hotel_id => current_hotel.id, :payment_type_id => cc_payment_type.id).first;
      
      data[:credit_card_types].push({
        id: cc_payment_type.id.to_s, 
        value: cc_payment_type.value.to_s, 
        description: cc_payment_type.description, 
        is_system_defined: cc_payment_type.hotel_id.nil?, 
        is_active: hotel_payment_type.active.to_s,
        is_cc: hotel_payment_type.is_cc,
        is_offline: hotel_payment_type.is_offline,
        is_rover_only: hotel_payment_type.is_rover_only,
        is_web_only: hotel_payment_type.is_web_only,
        is_display_reference: hotel_payment_type.is_display_reference
      })
    end
    
    response = { status: SUCCESS, data: data, errors: [] }

    respond_to do |format|
      format.html { render partial: 'admin/hotel_payment/payment_list', locals: response }
      format.json { render json: response }
    end
  end

  def show
    data = PaymentType.hotel_specific(current_hotel).find(params[:id])
    response = { status: SUCCESS, data: data, errors: [] }
    respond_to do |format|
      format.html { render partial: 'admin/hotel_payment/edit_payment', locals: response }
      format.json { render json: data }
    end
  end

  # POST /hotel_payment_types
  # POST /hotel_payment_types.json
  def create
    errors, status, attributes, data = [], SUCCESS, {}, {}

    set_active = params[:set_active]

    if set_active
      payment_type = PaymentType.hotel_payment_types(current_hotel).find(params[:id])
      hotel_payment_type = HotelsPaymentType.where(:hotel_id => current_hotel.id, :payment_type_id => payment_type.id).first;
      
      if set_active == 'true'
        hotel_payment_type.active = true
      else
        hotel_payment_type.active = false
      end
      hotel_payment_type.save
      
      if hotel_payment_type.active && hotel_payment_type.is_cc
        cc_hotel_payment_type = HotelsPaymentType.where(:hotel_id => current_hotel.id, :payment_type_id => PaymentType.credit_card.id).first;
        cc_hotel_payment_type.active = true
        cc_hotel_payment_type.save
      end
    else
      payment_type = params[:id].present? ? current_hotel.payment_types.find(params[:id]) : PaymentType.new(:hotel_id => current_hotel.id)

      attributes[:value] = params[:value] if params[:value]
      attributes[:is_selectable] = params[:is_selectable] if params[:is_selectable].present?
      attributes[:description] = params[:description].titlecase if params[:description]
      attributes[:hotel_id] = current_hotel.id unless params[:id].present?
      
     
      payment_type.update_attributes!(attributes) unless payment_type.hotel_id.nil?
      
      hotel_payment_type = payment_type.hotels_payment_types.find_or_initialize_by_hotel_id(current_hotel.id)
      
      hotel_payment_type.update_attributes!(
        :is_cc          => params[:is_cc] || false,
        :is_offline     => params[:is_offline] || false,
        :is_rover_only  => params[:is_rover_only] || false,
        :is_web_only    => params[:is_web_only] || false,
        :is_display_reference => params[:is_display_reference] || false
      )
      
      #CICO-11123
      if params[:is_cc] == true
        cc_hotel_payment_type = HotelsPaymentType.where(:hotel_id => current_hotel.id, :payment_type_id => PaymentType.credit_card.id).first;
        if hotel_payment_type.active
          cc_hotel_payment_type.active = true
          cc_hotel_payment_type.save
        end
      end
      
      data = { 
        id: payment_type.id, 
        value: payment_type.value, 
        description: payment_type.description, 
        is_system_defined: payment_type.hotel_id.nil?,
        is_cc: hotel_payment_type.is_cc,
        is_offline: hotel_payment_type.is_offline,
        is_rover_only: hotel_payment_type.is_rover_only,
        is_web_only: hotel_payment_type.is_web_only,
        is_display_reference: hotel_payment_type.is_display_reference,
        is_active: hotel_payment_type.active.to_s
      }
    end

    render json: { status: status, data: data, errors: errors }
  rescue ActiveRecord::RecordInvalid => ex
    render json: { status: FAILURE, data: [], errors: ex.record.errors.full_messages }
  end

  # POST /hotel_payment_types/activate_credit_card
  # POST /hotel_payment_types/activate_credit_card.json
  def activate_credit_card
    errors, status = [], SUCCESS
    set_active = params[:set_active]
    credit_card_type_id = params[:id]

    if set_active && credit_card_type_id
      credit_card_type = Ref::CreditCardType.find(credit_card_type_id)
      hotel_credit_card_type = credit_card_type.hotels_credit_card_types.where(:hotel_id => current_hotel.id).first
      
      if set_active == 'true'
        hotel_credit_card_type.active = true
      else
        hotel_credit_card_type.active = false
      end
      hotel_credit_card_type.save
    else
      errors, status = ['Parameter missing'], FAILURE
    end

    render json: { 'status' => status, 'data' => {}, 'errors' => errors }
  end
  
  #POST
  def update_credit_card
    errors, status = [], SUCCESS
    credit_card_type_id = params[:id]
    credit_card_type = current_hotel.credit_card_types.find(credit_card_type_id)
    
    hotel_credit_card_type = credit_card_type.hotels_credit_card_types.where(:hotel_id => current_hotel.id).first
    hotel_credit_card_type.update_attributes!(
      :is_cc          => params[:is_cc],
      :is_offline     => params[:is_offline] || false,
      :is_rover_only  => params[:is_rover_only] || false,
      :is_web_only    => params[:is_web_only] || false,
      :is_display_reference => params[:is_display_reference] || false
    )
    data = {
      id: credit_card_type.id, 
      value: credit_card_type.value, 
      description: credit_card_type.description, 
      is_system_defined: 'true',
      is_cc: hotel_credit_card_type.is_cc,
      is_offline: hotel_credit_card_type.is_offline,
      is_rover_only: hotel_credit_card_type.is_rover_only,
      is_web_only: hotel_credit_card_type.is_web_only,
      is_display_reference: hotel_credit_card_type.is_display_reference,
      is_active: hotel_credit_card_type.active.to_s
    }
    render json: { status: status, data: data, errors: errors }
  rescue ActiveRecord::RecordInvalid => ex
    render json: { status: FAILURE, data: [], errors: ex.record.errors.full_messages }
  end

  def destroy
    data, errors = {}, []

    payment_type = PaymentType.hotel_specific(current_hotel).find(params[:id])

    if payment_type.guest_payment_types.count == 0
      current_hotel.payment_types.destroy(payment_type)
      payment_type.delete
      status = SUCCESS
    else
      errors, status = ['PaymentType already in use'], FAILURE
    end

    response_attr = { data: data, errors: errors, status: status }
    render json: response_attr
  end
end
