class Api::DefaultAccountRoutingsController < ApplicationController
  before_filter :check_session
  before_filter :assign_account, only: [:create, :show, :save]

  def show
    @attached_entities = routing_result
  end

  def routings_count
    @travel_agent = current_hotel.hotel_chain.accounts.find(params[:travel_agent_id]) if params[:travel_agent_id].present?
    @company_card = current_hotel.hotel_chain.accounts.find(params[:company_id]) if params[:company_id].present?
    reservation = current_hotel.reservations.find(params[:reservation_id])
    @has_conflicting_routes = reservation.has_conflicting_routes(@company_card, @travel_agent)

  end

  ## **** Method to save new default routing information for account **** ##
  def save
  	DefaultAccountRouting.transaction do
  	  @account.default_account_routings.destroy_all if params[:attached_charge_codes].present? || params[:attached_billing_groups].present?
      # Create routings for the set of charge codes
      params[:attached_charge_codes].each do |charge_code|
        code = ChargeCode.find(charge_code[:id])
        @account.default_account_routings.create!(hotel_id: current_hotel.id, charge_code_id: charge_code[:id])
      end if params[:attached_charge_codes].present?

      # Create routings for the set of billing groups
      params[:attached_billing_groups].each do |billing_group|
        bil_group = BillingGroup.find(billing_group[:id])
        @account.default_account_routings.create!(hotel_id: current_hotel.id, billing_group_id: billing_group[:id])
      end if params[:attached_billing_groups].present?
    end
    rescue Exception => e
      render(json: e.message, status: :unprocessable_entity)
  end

  
  def attach_reservation
  	errors = []
  	if params[:account_id].present? && params[:reservation_ids].present?
      reservations = current_hotel.reservations.find(params[:reservation_ids])
      account = current_hotel.hotel_chain.accounts.find(params[:account_id])
      account_payment_method = account.payment_methods.last
      
      ChargeRouting.transaction do
        begin
          reservations.each do |reservation|
            bill_one = reservation.bill_one || reservation.bills.create(bill_number: 1)
            to_bill = reservation.next_bill_available_for_account_routings
            account.default_account_routings.for_hotel(current_hotel).each do |account_routing|
        	    routing_instruction = account_routing.charge_code_id.present? ? current_hotel.charge_codes.find(account_routing.charge_code_id).andand.charge_code : current_hotel.billing_groups.find(account_routing.billing_group_id).andand.name
              reservation.bill_one.charge_routings.create(to_bill_id: to_bill.id, charge_code_id: account_routing.charge_code_id, billing_group_id: account_routing.billing_group_id,
           	                                 owner_id: account.andand.id, owner_name: account.andand.account_name, external_routing_instructions: routing_instruction )
               to_bill.update_attributes(account_id: account.id)
              if account_payment_method.present?
                payment_attributes = account_payment_method.attributes.except("id", "associated_id", "associated_type","creator_id", "updater_id", "created_at", "updated_at")
                payment_attributes["bill_number"] = to_bill.bill_number
                reservation.payment_methods.find_by_bill_number(to_bill.bill_number).destroy if reservation.payment_methods.find_by_bill_number(to_bill.bill_number).present?
                reservation.payment_methods.create(payment_attributes)
              end
            end
          end
        rescue Exception => ex
          errors << ex.message
          logger.error "*****  an exception occured during setting the routings for the reservation : #{reservation.confirm_no}"
         logger.error "*****  ex.message  ********"
        end
        raise ActiveRecord::Rollback unless errors.empty?
      end
    else
      errors << "Missing reservation_id / account_id "
    end
    render(json: errors, status: :unprocessable_entity) unless errors.empty?
  end
  
  
  private
  def assign_account
    @account = current_hotel.hotel_chain.accounts.find(params[:id])
  end
   
  def routing_result
    {
      attached_charge_codes: @account.default_account_routings.for_hotel(current_hotel).joins("INNER JOIN charge_codes on default_account_routings.charge_code_id=charge_codes.id").select('charge_codes.id,charge_codes.charge_code,charge_codes.description'),
      attached_billing_groups: @account.default_account_routings.for_hotel(current_hotel).joins("INNER JOIN billing_groups on default_account_routings.billing_group_id=billing_groups.id").select('billing_groups.id,billing_groups.name'),
      credit_card_details: @account.attached_payment_method
    }
  end

end