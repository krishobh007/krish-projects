class Api::RatesController < ApplicationController
  before_filter :check_session
  before_filter :check_active_end_date_passed, only: [:index]
  before_filter :retrieve, only: [:show, :update, :destroy, :room_types, :enable_disable, :validate_end_date]
  after_filter :load_business_date_info
  before_filter :check_business_date
  # List rates for the hotel, optionally filtering by rate type or base rate
  def index
    @total_count = 0
    if params[:page].present? && params[:per_page].present?
      @rates = current_hotel.rates.search(params[:query]).non_contract.page(params[:page]).per(params[:per_page])
        .sort_by(params[:sort_field], params[:sort_dir])
        
      @total_count = current_hotel.rates.search(params[:query]).non_contract.count
    else
      @rates = current_hotel.rates.search(params[:query]).non_contract
      @total_count = current_hotel.rates.count
    end
    @rates = @rates.where(rate_type_id: params[:rate_type_id]) if params.key?(:rate_type_id)
    @rates = @rates.where(based_on_rate_id: params[:based_on_rate_id]) if params.key?(:based_on_rate_id)
    @rates = @rates.where(based_on_rate_id: nil) if params[:is_parent] == 'true'
    @rates = @rates.fully_configured if params[:is_fully_configured] == 'true'
  end

  # Show the rate details
  def show
  end

  # GET Contract Rates
  def contract_rates
    @rates = current_hotel.rates.present? ? current_hotel.rates.contract_rates : []
  end

  # Create a new rate
  def create
    Rate.transaction do
      @rate = Rate.new(rate_params)
      @rate.copy_based_on_rate!
      @rate.save!
      @rate.rates_addons.create!(params[:addons]) if params[:addons] && !params[:addons].empty?
      @rate.update_rate_restrictions!(rate_restriction_params)
    end
  rescue ActiveRecord::RecordInvalid => e
    render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

  # Update an existing rate
  def update
    Rate.transaction do
      @rate.attributes = rate_params
      @rate.copy_based_on_rate! if @rate.based_on_rate_id_changed? || @rate.based_on_value_changed? || @rate.based_on_type_changed?
      @rate.save!

      # Delete rate from rate_addons table, if addon exists for given rate
      @rate.rates_addons.destroy_all
      @rate.rates_addons.create!(params[:addons]) if params[:addons].present?

      @rate.update_rate_restrictions!(rate_restriction_params)
    end
  rescue ActiveRecord::RecordInvalid => e
    render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

  # Destroys a rate
  def destroy
    @rate.destroy || render(json: @rate.errors.full_messages, status: :unprocessable_entity)
  end

  # Add/remove room types from the rate
  def room_types
    if !@rate.based_on_rate || @rate.rate_type.linked?
      Rate.transaction do
        # Need to remove the Room Rate, when user unselect any room type from the rate admin grid.
        @rate.room_rates.without_room_types(params[:room_type_ids]).destroy_all
        @rate.room_types = params[:room_type_ids].andand.map { |room_type_id| RoomType.find(room_type_id) } || []
        @rate.room_types_required = true
        @rate.save!

        @rate.sync_based_on_room_rates!
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

  # Import rates from the external PMS
  def import
    current_hotel.import_rates_from_external_pms || render(json: [I18n.t(:external_pms_failed)], status: :unprocessable_entity)
  end

  def enable_disable
    unless @rate.is_activation_allowed
      if params[:is_active]
        render(json: [I18n.t(:rate_end_date_passed)], status: :unprocessable_entity)
      end
    else
      @rate.is_active = params[:is_active]
      @rate.save
    end
  end

  #--------   Method to check whether the end date is valid for a rate   ---------#
  def validate_end_date
    end_date = Date.parse(params[:end_date])
    @status = @rate.based_on_rates.contracts_with_end_date_exceeding(end_date).empty?
  end

  def tax_information
    rates = current_hotel.rates.where('id in (?)', params[:rate_ids])
    @tax_information = []
    rates.each do |rate|
      @tax_information << {
        rate_id: rate.id,
        tax: rate.charge_code.tax_information
      }
    end
    @tax_codes = current_hotel.charge_codes.where(charge_code_type_id: Ref::ChargeCodeType[:TAX].id)
  end

  private
  def check_active_end_date_passed
     passed_rates = current_hotel.rates.active.end_date_passed(current_hotel.active_business_date)
     passed_rates.each do |passed_rate|
          passed_rate.update_attributes(is_active: false)
     end
  end


  # Retrieve the selected rate
  def retrieve
    @rate = Rate.find(params[:id])
    @rate.andand.market_segment_id = @rate.andand.based_on_rate.andand.market_segment_id if @rate.andand.market_segment_id.nil? 
    @rate.andand.source_id = @rate.andand.based_on_rate.andand.source_id if @rate.andand.source_id.nil?
    fail I18n.t(:access_denied) unless @rate.accessible?(current_hotel)
  end

  def rate_params
    {
      rate_name: params[:name],
      rate_desc: params[:description],
      promotion_code: params[:promotion_code],
      rate_type_id: params[:rate_type_id],
      based_on_rate_id: params[:based_on_rate_id],
      based_on_type: params[:based_on_type],
      based_on_value: params[:based_on_value],
      hotel_id: current_hotel.id,
      charge_code_id: params[:charge_code_id],
      currency_code_id: params[:currency_code_id],
      end_date: params[:end_date],
      source_id: params[:source_id],
      market_segment_id: params[:market_segment_id],
      is_commission_on: params[:is_commission_on],
      is_suppress_rate_on: params[:is_suppress_rate_on],
      is_discount_allowed_on: params[:is_discount_allowed_on],
      deposit_policy_id: params[:deposit_policy_id],
      cancellation_policy_id: params[:cancellation_policy_id],
      use_rate_levels: params[:use_rate_levels],
      is_hourly_rate: params[:is_hourly_rate]
    }
  end

  def rate_restriction_params
    {
      min_adv_booking: params[:min_advanced_booking],
      max_adv_booking: params[:max_advanced_booking],
      min_stay_length: params[:min_stay],
      max_stay_length: params[:max_stay]
    }
  end
end
