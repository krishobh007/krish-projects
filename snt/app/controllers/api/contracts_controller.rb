class Api::ContractsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  
  before_filter :retrieve, only: [:show, :update]

  def index
    @account = Account.find(params[:account_id])
    business_date = current_hotel.active_business_date
    @current_contracts = @account.rates.current(business_date)
    @future_contracts = @account.rates.future(business_date)
    @history_contracts = @account.rates.history(business_date)
  end

  def show
    @rate = Rate.find(params[:id])
    @rates = current_hotel.rates.active.includes(:rate_type).merge(RateType.government_or_corporate)
    @expired_rates = current_hotel.rates.end_date_passed(current_hotel.active_business_date)
    @rates.reject{|rate|  (@expired_rates.include?(rate))}
    @currency_symbol = current_hotel.default_currency.symbol
  end

  def create
    Rate.transaction do
      @rate = Rate.new(contract_params)
      @rate.copy_based_on_rate!
      @rate.save!
    end
  rescue ActiveRecord::RecordInvalid => e
    render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

  def update
    Rate.transaction do
      @rate.attributes = contract_params
      @rate.validate_based_on_value(params[:rate_value])
      unless  @rate.errors.present?
        @rate.copy_based_on_rate!
        @rate.save!
      else
        render(json: @rate.errors.full_messages, status: :unprocessable_entity)
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

  private

  # Retrieve the selected rate
  def retrieve
    @rate = Rate.find(params[:id])
    fail I18n.t(:access_denied) unless @rate.accessible?(current_hotel)
  end

  def contract_params
    based_on_rate = Rate.find_by_id(params[:contracted_rate_selected])

    mapped_params = {
      hotel_id: current_hotel.id,
      account_id: params[:account_id],
      begin_date: params[:begin_date],
      end_date: params[:end_date],
      based_on_type: params[:selected_type],
      based_on_value: params[:selected_symbol].to_s + params[:rate_value].to_s,
      is_fixed_rate: params[:is_fixed_rate] || false,
      is_rate_shown_on_guest_bill: params[:is_rate_shown_on_guest_bill] || false,
      is_hourly_rate: current_hotel.settings.is_hourly_rate_on

    }

    # Set the following to the same as the based on rate
    if based_on_rate
      mapped_params[:based_on_rate_id] = based_on_rate.id
      mapped_params[:rate_type_id] = based_on_rate.rate_type_id
      mapped_params[:charge_code_id] = based_on_rate.charge_code_id
      mapped_params[:currency_code_id] = based_on_rate.currency_code_id
      mapped_params[:rate_desc] = based_on_rate.rate_desc
    end

    if params[:contract_name].present?
      mapped_params[:rate_name] = params[:contract_name]
    end

    mapped_params
  end
end
