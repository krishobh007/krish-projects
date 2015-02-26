class Api::BillRoutingsController < ApplicationController
  before_filter :check_session
  before_filter :assign_reservation, only: [:attached_entities, :charge_codes, :billing_groups, :bills,:delete_routing]
  before_filter :check_business_date
  
  ## **** Method to list all attached entities for the reservation **** ##
  def attached_entities
    reservation = current_hotel.reservations.find(params[:id])
    @attached_entity_map = routing_result(reservation)
  end

  ## **** Method to list all attached entities for the reservation **** ##
  def attached_cards
    @reservation = current_hotel.reservations.find(params[:id])
  end

  ## **** Method to list all attachable charge codes for the reservation **** ##
  def charge_codes
    @from_bill = @reservation.bills.first || @reservation.bills.create(bill_number: 1) unless params[:is_default_routing]
    already_linked_charge_codes = []
    if params[:is_new] == "true"
    already_linked_charge_codes = @reservation.bills.joins("INNER JOIN charge_routings AS from_bills on bills.id=from_bills.bill_id")
        .where("from_bills.bill_id=? AND from_bills.charge_code_id IS NOT NULL",@from_bill.id).pluck("from_bills.charge_code_id")
    else
      already_linked_charge_codes = params[:is_default_routing] ? [] : @reservation.bills.joins("INNER JOIN charge_routings AS from_bills on bills.id=from_bills.bill_id")
        .where("from_bills.bill_id=? AND from_bills.to_bill_id != ? AND from_bills.charge_code_id IS NOT NULL",@from_bill.id,params[:to_bill]).pluck("from_bills.charge_code_id")
    end
    already_linked_groups = @reservation.bills.joins("INNER JOIN charge_routings AS from_bills on bills.id=from_bills.bill_id")
        .where("from_bills.bill_id=? AND from_bills.billing_group_id IS NOT NULL", @from_bill.id).pluck("from_bills.billing_group_id") unless params[:is_default_routing]
    already_linked_charge_codes += current_hotel.billing_groups.joins("INNER JOIN charge_codes_billing_groups ON charge_codes_billing_groups.billing_group_id = billing_groups.id").where("charge_codes_billing_groups.billing_group_id IN (?)", already_linked_groups).pluck("charge_codes_billing_groups.charge_code_id")
    
    @charge_codes = !already_linked_charge_codes.empty? ? current_hotel.charge_codes.order('charge_code').where("charge_codes.id NOT IN (?)", already_linked_charge_codes).charge : current_hotel.charge_codes.charge.order('charge_code')
  end

  ## **** Method to list all attachable charge codes for the reservation **** ##
  def bills
    @reservation.bills.create(bill_number: 1) if @reservation.bills.empty?
  end

  ## **** Method to list all attachable billing groups for the reservation **** ##
  def billing_groups
    @from_bill = @reservation.bills.first || @reservation.bills.create(bill_number: 1) unless params[:is_default_routing]

    if params[:is_new] == "true"
      already_linked_groups = @reservation.bills.joins("INNER JOIN charge_routings AS from_bills on bills.id=from_bills.bill_id")
        .where("from_bills.bill_id=? AND from_bills.billing_group_id IS NOT NULL", @from_bill.id).pluck("from_bills.billing_group_id")
    else
      already_linked_groups = params[:is_default_routing] ? [] :  @reservation.bills.joins("INNER JOIN charge_routings AS from_bills on bills.id=from_bills.bill_id")
        .where("from_bills.bill_id=? AND from_bills.to_bill_id != ?  AND from_bills.billing_group_id IS NOT NULL", @from_bill.id, params[:to_bill]).pluck("from_bills.billing_group_id")
    end

    @billing_groups = !already_linked_groups.empty? ? current_hotel.billing_groups.where("billing_groups.id NOT IN (?)", already_linked_groups) : current_hotel.billing_groups
    

  end

  ## **** Method to save new routing information for reservation **** ##
  def save_routing
    ChargeRouting.transaction do
      @reservation = current_hotel.reservations.find(params[:reservation_id])
        guest_detail = @reservation.guest_details.find(params[:guest_id]) if params[:guest_id].present?

      @from_bill = @reservation.bills.first || @reservation.bills.create(bill_number: 1)
      @to_bill = Bill.find(params[:to_bill])
      @reservation.charge_routings.where(bill_id: @reservation.bills.first.id,to_bill_id: params[:to_bill]).destroy_all unless params[:is_new]
      
      # Create routings for the set of charge codes
      params[:attached_charge_codes].each do |charge_code|
        code = ChargeCode.find(charge_code[:id])
        @from_bill.charge_routings.create!(to_bill_id: params[:to_bill], owner_id: guest_detail.andand.id, owner_name: guest_detail.andand.full_name, charge_code_id: charge_code[:id], external_routing_instructions: code.charge_code)
      end if params[:attached_charge_codes].present?

      # Create routings for the set of billing groups
      params[:attached_billing_groups].each do |billing_group|
        bil_group = BillingGroup.find(billing_group[:id])
        @from_bill.charge_routings.create!(to_bill_id: params[:to_bill], owner_id: guest_detail.andand.id, owner_name: guest_detail.andand.full_name, billing_group_id: billing_group[:id], external_routing_instructions: bil_group.name)
      end if params[:attached_billing_groups].present?

      if params[:entity_type] ==  Setting.routing_entity_types[:company_card] || params[:entity_type] ==  Setting.routing_entity_types[:travel_agent]
        @to_bill.update_attributes(account_id: params[:id])
        
        account = Account.find(params[:id])
        account_payment_method = account.payment_methods.last
        
        # Linking account linked payment method to bill
        if account_payment_method.present? && !params[:selected_payment].present?
          payment_attributes = account_payment_method.attributes.except("id", "associated_id", "associated_type","creator_id", "updater_id", "created_at", "updated_at")
          payment_attributes["bill_number"] = @to_bill.bill_number
          @reservation.payment_methods.find_by_bill_number(@to_bill.bill_number).destroy if @reservation.payment_methods.find_by_bill_number(@to_bill.bill_number).present?
          @reservation.payment_methods.create(payment_attributes)
        end
        # Attach the account to reservation if reservation has no previous accounts linked.
        if params[:entity_type] ==  Setting.routing_entity_types[:company_card]
          @reservation.update_attributes!(company_id: params[:id]) unless @reservation.company.present?
        else
          @reservation.update_attributes!(travel_agent_id: params[:id]) unless @reservation.travel_agent.present?
        end
      end

      # Attach the payment to the reservation
      if params[:selected_payment].present?
        payment_attributes = PaymentMethod.find(params[:selected_payment]).attributes.except("id", "associated_id", "associated_type","creator_id", "updater_id", "created_at", "updated_at")
        payment_attributes["bill_number"] = @to_bill.bill_number
        @reservation.payment_methods.find_by_bill_number(@to_bill.bill_number).destroy if @reservation.payment_methods.find_by_bill_number(@to_bill.bill_number).present?
        @reservation.payment_methods.create(payment_attributes)
      end
    end
    rescue ActiveRecord::RecordInvalid => e
     render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

   ## **** Method to delete bill routing information for the reservation **** ##
  def delete_routing
    ChargeRouting.transaction do
      @reservation.charge_routings.where(bill_id: params[:from_bill],to_bill_id: params[:to_bill]).destroy_all
      Bill.find(params[:to_bill]).update_attributes(account_id: nil)
    end
    rescue ActiveRecord::RecordInvalid => e
    render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

  private
  def assign_reservation
    @reservation = current_hotel.reservations.find(params[:id]) unless params[:is_default_routing]
  end

  def routing_result(reservation)
    entity_result = reservation.charge_routings.joins("LEFT OUTER join bills as to_bills on to_bills.id=charge_routings.to_bill_id")
                  .joins("LEFT OUTER JOIN reservations as to_reservations on to_reservations.id=to_bills.reservation_id")
                  .joins("LEFT OUTER JOIN accounts as to_accounts on to_accounts.id=to_bills.account_id")
                  .select("charge_routings.bill_id as from_bill_id, charge_routings.owner_id as guest_id, to_bills.id as to_bill_id, to_bills.bill_number as to_bill_no, to_accounts.id as account_id,to_reservations.id as reservation_id").uniq
    entity_result.order('to_bill_no').map do |entity|
      attached_reservation = current_hotel.reservations.find(entity.reservation_id)
      attached_entity = entity.account_id.present? ?  current_hotel.hotel_chain.accounts.find(entity.account_id) : attached_reservation
      selected_payment_type = attached_reservation.payment_methods.find_by_bill_number(entity.to_bill_no)
      primary_guest = reservation.primary_guest
      selected_payment_type_on_guest = primary_guest.payment_methods.find_by_mli_token(selected_payment_type.mli_token) if selected_payment_type && primary_guest
      {
        entity: attached_entity,
        entity_type: entity.account_id.present? ? map_account_type(entity.account_id)  : Setting.routing_entity_types[:reservation],
        attached_charge_codes: current_hotel.charge_codes.joins("INNER JOIN charge_routings on charge_routings.charge_code_id=charge_codes.id").where("charge_routings.bill_id=? AND charge_routings.to_bill_id=?",entity.from_bill_id,entity.to_bill_id).select('charge_codes.id,charge_codes.charge_code,charge_codes.description'),
        attached_billing_groups: current_hotel.billing_groups.joins("INNER JOIN charge_routings on charge_routings.billing_group_id=billing_groups.id").where("charge_routings.bill_id=? AND charge_routings.to_bill_id=?",entity.from_bill_id,entity.to_bill_id).select('billing_groups.id,billing_groups.name'),
        from_bill: entity.from_bill_id,
        guest_id: entity.guest_id,
        credit_card_details: map_bill_credit_card_hash(attached_reservation, attached_reservation.bills.find(entity.to_bill_id).andand.bill_number),
        reservation_status: !entity.account_id.present? ? ViewMappings::StayCardMapping.map_view_status(attached_entity, current_hotel.active_business_date).to_s : '',
        is_opted_late_checkout: !entity.account_id.present? ? attached_entity.is_opted_late_checkout : '',
        to_bill: entity.to_bill_id,
        selected_payment_id: selected_payment_type_on_guest.andand.id.to_s,
        bill_no: entity.to_bill_no,
        images: map_images(attached_entity, !entity.account_id.present?),
        has_accompanying_guests: !entity.account_id.present? ? reservation.accompanying_guests.present? : false
      }
     end
  end

  def map_images(entity, is_reservation)
    if is_reservation
      entity.guest_details.map do |guest|
        {
          is_primary: !guest.reservations_guest_details.first.is_accompanying_guest,
          image: guest.avatar(:thumb)
        }
      end
    else
      [{is_primary: true,image: entity.logo.andand.image(:thumb)}]
    end
  end

  def map_account_type(account_id)
    account = current_hotel.hotel_chain.accounts.find(account_id)
    account.andand.account_type === :COMPANY ? Setting.routing_entity_types[:company_card] : Setting.routing_entity_types[:travel_agent]
  end

  # get hash for credit card info for a bill on reservation
  def map_bill_credit_card_hash(reservation, bill_number)
    reservation_credit_card_hash = {}
    bill_payment_method = reservation.bill_payment_method(bill_number)

    if bill_payment_method
      reservation_credit_card_hash['payment_type'] = bill_payment_method.payment_type.value.to_s
      reservation_credit_card_hash['payment_type_description'] = bill_payment_method.payment_type.description
      reservation_credit_card_hash['card_code'] = bill_payment_method.credit_card_type.to_s.downcase
      reservation_credit_card_hash['card_number'] = bill_payment_method.mli_token_display.to_s
      reservation_credit_card_hash['card_expiry'] = bill_payment_method.card_expiry ? bill_payment_method.card_expiry_display : ''
      reservation_credit_card_hash['payment_id'] = bill_payment_method.id
      reservation_credit_card_hash['card_name'] = bill_payment_method.card_name
      reservation_credit_card_hash['is_swiped'] = bill_payment_method.is_swiped
    end

    reservation_credit_card_hash
  end

end