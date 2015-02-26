class Api::SmartbandsController < ApplicationController
  layout false
  before_filter :check_session
  before_filter :check_business_date
  before_filter :retrieve_reservation, only: [:index, :create, :with_balance, :cash_out]
  before_filter :retrieve, only: [:show, :update]
  after_filter :load_business_date_info

  def index
    # Sync the fixed smartbands with icare
    Smartband.sync_smartbands_with_icare(@reservation.smartbands.fixed)

    @smartbands = @reservation.smartbands.page(params[:page]).per(params[:per_page]).order(:last_name, :first_name)
    @smartbands = @smartbands.has_balance if params[:has_balance] == 'true'

    # TODO: REMOVE THIS AFTER MOVING TO 1.9
    @data = {}
    @data[:results] = @smartbands.map do |smartband|
      {
        first_name: smartband.first_name,
        last_name: smartband.last_name,
        is_fixed: smartband.is_fixed,
        id: smartband.id,
        amount: smartband.amount,
        account_number: smartband.account_number
      }
    end

    @data[:total_count] = @smartbands.total_count
  end

  # TODO: REMOVE THIS AFTER MOVING TO 1.9
  def with_balance
    # Sync the fixed smartbands with icare
    Smartband.sync_smartbands_with_icare(@reservation.smartbands.fixed)

    @smartbands = @reservation.smartbands.has_balance.page(params[:page]).per(params[:per_page]).order(:last_name, :first_name)

    @data = {}
    @data[:results] = @smartbands.map do |smartband|
      {
        first_name: smartband.first_name,
        last_name: smartband.last_name,
        is_fixed: smartband.is_fixed,
        id: smartband.id,
        amount: smartband.amount,
        account_number: smartband.account_number
      }
    end

    @data[:total_count] = @smartbands.total_count
    render(json: @data) 
  end

  def show
    result = { status: true, errors: [] }

    # Sync the amount with icare if fixed
    result = @smartband.sync_amount_with_icare if @smartband.is_fixed

    render(json: result[:errors], status: :unprocessable_entity) unless result[:status]
  end

  def create
    errors = []

    @smartband = @reservation.smartbands.build(create_params)
    if @smartband.valid?
      # If the smartband is fixed, issue the account with icare and post the charge to the external PMS
      if @smartband.is_fixed
        icare_result = @smartband.issue_account_with_icare

        if icare_result[:status]
          unless @smartband.post_charge_to_external_pms(params[:amount], true, "Smartband Issued - #{@smartband.account_number}")
            errors << I18n.t(:external_pms_failed)
            # Remove account from icare
          end
        else
          errors += icare_result[:errors]
        end
      else
        # As per CICO-9117
        logger.debug 'Smartband Create - API - Fixed Room Charage'
        result = @smartband.send_smartband_key_data_to_external_pms
        logger.debug 'Smartband Create - API - OWS call Success' if result[:status]
        errors << I18n.t(:external_pms_failed) if result[:status] == false
      end
      @smartband.save if errors.empty?
    else
      errors += @smartband.errors.full_messages
    end
    # if there are no errors then send alerts to external pms
    @smartband.send_alert_to_external_pms('ADD') if errors.empty? && current_hotel.settings.pms_alert_code
    #
    render(json: errors, status: :unprocessable_entity) if errors.present?
  end

  def update
    errors = []

    @smartband.attributes = update_params

    if @smartband.valid?
      # If the smartband is fixed, issue the account with icare and post the charge to the external PMS
      if @smartband.is_fixed && params[:credit].present?
        @smartband.amount += params[:credit]

        icare_result = @smartband.reload_account_with_icare(params[:credit])

        if icare_result[:status]
          unless @smartband.post_charge_to_external_pms(params[:credit], true, "Smartband Value Added - #{@smartband.account_number}")
            errors << I18n.t(:external_pms_failed)
            # TODO: Remove credit from icare
          end
        else
          errors += icare_result[:errors]
        end
      end

      @smartband.save if errors.empty?
    else
      errors += @smartband.errors.full_messages
    end

    render(json: errors, status: :unprocessable_entity) if errors.present?
  end

  def cash_out
    errors = []

    @reservation.smartbands.has_balance.each do |smartband|
      unless errors.present?
        result = smartband.cash_out_with_icare

        if result[:status]
          unless smartband.post_charge_to_external_pms(result[:data][:amount], false, "Smartband Cashed Out - #{smartband.account_number}")
            errors << I18n.t(:external_pms_failed)
            # TODO: Undo cash out from icare
          end
        else
          errors += result[:errors]
        end
      end
    end

    render(json: errors, status: :unprocessable_entity) if errors.present?
  end

  private

  # Retrieve the smartband
  def retrieve
    @smartband = Smartband.find(params[:id])
  end

    # Retrieve the reservation
  def retrieve_reservation
    @reservation = Reservation.find(params[:reservation_id])
  end

  # Map the smartband params for create
  def create_params
    {
      first_name: params[:first_name],
      last_name: params[:last_name],
      account_number: formatted_account_number(params[:account_number]),
      is_fixed: params[:is_fixed],
      amount: params[:amount],
      # CICO- 9174 - Removed Validation
      name_required: false
    }
  end

  # Map the smartband params for update
  def update_params
    {
      first_name: params[:first_name],
      last_name: params[:last_name],
      # CICO- 9174 - Removed Validation
      name_required: false
    }
  end

  # Obtain the formatted account number, which is the account preamble combined with the padded account number
  def formatted_account_number(account_number)
    if account_number
      # As per CICO-9065 Reversing the received account number by byte
      logger.debug "ICARE: Orignal Account Number from Device - #{account_number}"

      account_number = reverse_account_number_by_byte(account_number)
      logger.debug "ICARE: Reversed Account Number from Device - #{account_number}"

      account_preamble = current_hotel.settings.icare_account_preamble
      account_length = current_hotel.settings.icare_account_length.to_i

      preamble_length = account_preamble.size
      pad_length = account_length - preamble_length
      formatted_account_number = account_preamble + account_number.ljust(pad_length, '0')
      logger.debug "ICARE: Constructed Account Number before Trim - #{formatted_account_number}"

      # As per CICO-9033, there could be a mismatich setting account number from admin & icare admin.
      resultant_account_number = formatted_account_number[0..(account_length - 1)]
      if resultant_account_number.length < account_length
        resultant_account_number = formatted_account_number.ljust(account_length, '0')
      end
      resultant_account_number
    end
  end

  def reverse_account_number_by_byte(account_number)
    account_number.scan(/.{2}/).reverse.join
  end
end
