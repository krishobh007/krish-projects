class Api::BillingGroupsController < ApplicationController
  before_filter :check_session
  before_filter :retrieve_billing_group, only: [:show, :update, :destroy]
  after_filter :load_business_date_info
  before_filter :check_business_date
  ## **** Method to list all billing groups for the hotel **** ##
  def index
  	
  end

  ## **** Method to edit billing groups for the hotel **** ##
  def show
   
  end

  ## **** Method to get charge_codes in the hotel **** ##
  def charge_codes
   
  end


  ## **** Method to create billing groups for the hotel **** ##
  def create
    @billing_group = current_hotel.billing_groups.new(name: params[:name])
    @billing_group.charge_codes = selected_charge_codes
    @billing_group.save
    render(json: @billing_group.errors.full_messages, status: :unprocessable_entity) if @billing_group.errors.present?
  end

  ## **** Method to update billing groups for the hotel **** ##
  def update
    @billing_group.update_attributes(name: params[:name])
    @billing_group.charge_codes = selected_charge_codes
    render(json: @billing_group.errors.full_messages, status: :unprocessable_entity) if @billing_group.errors.present?
  end

   ## **** Method to delete billing groups for the hotel **** ##
  def destroy
    can_delete = !ChargeRouting.where(billing_group_id: @billing_group.id).present?
    if can_delete
      errors =  @billing_group.delete ? [] : @billing_group.errors.full_messages 
         
    else
      errors = ['Billing Group already associated with reservation']

    end
    render(json: errors , status: :unprocessable_entity)  unless errors.empty?
  end


  private 

  def retrieve_billing_group
    @billing_group = current_hotel.billing_groups.find(params[:id])
  end

  def selected_charge_codes
    current_hotel.charge_codes.where("id in (?)",params[:selected_charge_codes])
  end


end