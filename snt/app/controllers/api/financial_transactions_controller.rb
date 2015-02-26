class Api::FinancialTransactionsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date

  def index
    @charge_groups = current_hotel.charge_groups
  end

  def revenue
    @charge_groups = current_hotel.charge_groups
    @from_date = params[:from_date]
    @to_date = params[:to_date]
    @charge_codes = current_hotel.charge_codes
                    .joins('LEFT OUTER JOIN charge_groups_codes ON charge_groups_codes.charge_code_id = charge_codes.id')
                    .joins('LEFT OUTER JOIN charge_groups ON charge_groups.id=charge_groups_codes.charge_group_id')
                    .where('charge_codes.charge_code_type_id <> ?', Ref::ChargeCodeType[:PAYMENT].id)
                    .select('charge_groups.id as charge_group_id, charge_codes.*').where('charge_group_id IN (?)', @charge_groups.map(&:id))
    @transactions = FinancialTransaction.where(charge_code_id: @charge_codes.map(&:id))
                    .where('date >= ? && date <= ?', @from_date, @to_date).order(:time)
  end

  def payments
    @from_date = params[:from_date]
    @to_date = params[:to_date]

    @payment_methods = current_hotel.payment_types
    @credit_cards = current_hotel.credit_card_types

    @cc_charge_codes = current_hotel.charge_codes.cc.where(associated_payment_id: @credit_cards.map(&:id))
    @cc_transactions = FinancialTransaction.where(charge_code_id: @cc_charge_codes.map(&:id))
      .where('date >= ? && date <= ?', @from_date, @to_date).order(:time)

    @non_cc_charge_codes = current_hotel.charge_codes.non_cc.where(associated_payment_id: @payment_methods.map(&:id))
    @non_cc_transactions = FinancialTransaction.where(charge_code_id: @non_cc_charge_codes.map(&:id))
      .where('date >= ? && date <= ?', @from_date, @to_date).order(:time)
  end

  def edit
    @charge_codes = current_hotel.charge_codes.all
  end

  def update
    errors = []
    @financial_transaction = FinancialTransaction.find(params[:id])
    bill = @financial_transaction.bill
    reservation = bill.reservation
    type = ""
  	begin
  	  FinancialTransaction.transaction do
        charge_code = @financial_transaction.charge_code

  	    if params[:process] == 'delete'
          type = "DELETED"
          adjusted_amount = 0 - @financial_transaction.amount
          @financial_transaction.is_active = false
          delete_details = "<br /> Time: #{DateTime.parse(current_hotel.current_time).andand.strftime('%d/%m/%Y, %I:%M %P')}"
          @financial_transaction.comments = @financial_transaction.comments.to_s + "<br />" + params[:reason].to_s + delete_details

          remove_associated_taxes(@financial_transaction) if charge_code && !charge_code.is_tax?
          adjusted_transaction = create_adjusted_transaction(@financial_transaction, adjusted_amount, type)

          FinancialTransaction.record_action(@financial_transaction, :DELETE_TRANSACTION, :WEB, current_hotel.id)
          FinancialTransaction.record_action(adjusted_transaction, :DELETE_TRANSACTION, :WEB, current_hotel.id)

        else
          if params.include?(:split_type) && params.include?(:split_value)
            type = "SPLIT"

            if params[:split_type] == current_hotel.default_currency.symbol
              adjusted_amount = params[:split_value].to_f
              tax_split_percent = adjusted_amount / @financial_transaction.amount * 100
            elsif params[:split_type] == '%'
              adjusted_amount = @financial_transaction.amount * params[:split_value].to_f / 100
              tax_split_percent = params[:split_value].to_f
            end

            action_details = []
            action_details << FinancialTransaction.prepare_action_details('amount', @financial_transaction.amount, ['%.2f' % (@financial_transaction.amount - adjusted_amount), '%.2f' % adjusted_amount].join(', '))

            @financial_transaction.amount = @financial_transaction.amount - adjusted_amount
            @financial_transaction.transaction_type = type
            adjusted_transaction = create_adjusted_transaction(@financial_transaction, adjusted_amount, type)

            FinancialTransaction.record_action(@financial_transaction, :SPLIT_TRANSACTION, :WEB, current_hotel.id, action_details)
            FinancialTransaction.record_action(adjusted_transaction, :SPLIT_TRANSACTION, :WEB, current_hotel.id, action_details)

            split_associated_taxes(@financial_transaction, tax_split_percent, adjusted_transaction) if charge_code && !charge_code.is_tax?
          else
            if params.include?(:new_amount)
              type = "EDIT"
              adjusted_amount = params[:new_amount].to_f - @financial_transaction.amount
              tax_edit_percent = adjusted_amount / @financial_transaction.amount * 100 if !params.include?(:charge_code_id)
              @financial_transaction.transaction_type = type
              adjusted_transaction = create_adjusted_transaction(@financial_transaction, adjusted_amount, type)

              action_details = []
              action_details << FinancialTransaction.prepare_action_details('amount', @financial_transaction.amount,params[:new_amount])

              FinancialTransaction.record_action(@financial_transaction, :SPLIT_TRANSACTION, :WEB, current_hotel.id, action_details)
              FinancialTransaction.record_action(adjusted_transaction, :EDIT_TRANSACTION, :WEB, current_hotel.id, action_details) if adjusted_transaction

              edit_associated_taxes(@financial_transaction, tax_edit_percent, adjusted_transaction) if charge_code && !charge_code.is_tax? && !params.include?(:charge_code_id)
            end
            if params[:charge_code_id].present?
              type = "EDIT"
              remove_associated_taxes(@financial_transaction) if charge_code && !charge_code.is_tax?
              action_details = []
              action_details << FinancialTransaction.prepare_action_details('charge_code_id', @financial_transaction.charge_code_id, params[:charge_code_id])
              @financial_transaction.transaction_type = type
              @financial_transaction.charge_code_id = params[:charge_code_id]
              charge_code = current_hotel.charge_codes.find(params[:charge_code_id])
              amount = params.include?(:new_amount) ? adjusted_amount : @financial_transaction.amount
              reservation.post_taxes(
                                      bill,
                                      charge_code,
                                      amount,
                                      @financial_transaction.date,
                                      false,
                                      @financial_transaction.id
                                    )
              FinancialTransaction.record_action(@financial_transaction, :EDIT_TRANSACTION,:WEB, current_hotel.id, action_details) if @financial_transaction.valid?
            end
          end
          raise ActiveRecord::RollBack, "Record invalid" if !@financial_transaction.save!
        end
      end
      @financial_transaction.updater_id = current_user.id
      @financial_transaction.save!
      @financial_transaction.set_cashier_period

    rescue ActiveRecord::RecordInvalid => e
      errors = e.record.errors.full_messages
    end
    bill_card = ViewMappings::BillCardMapping.map_bill_card(reservation, current_hotel)
    if errors.empty?
      render(json: bill_card)
    else
      render(json: errors, status: :unprocessable_entity)
    end
  end

  private

  def tax_transactions(financial_transaction)
    tax_ids = financial_transaction.charge_code.charge_code_generates.tax(current_hotel).pluck(:generate_charge_code_id)
    bill = financial_transaction.bill
    tax_transactions = bill.financial_transactions.where('charge_code_id in (?) AND parent_transaction_id = ?', tax_ids, financial_transaction.id)
    tax_transactions
  end

  def remove_associated_taxes(financial_transaction)
    taxes_transactions = tax_transactions(financial_transaction)
    taxes_transactions.each do |tax_transaction|
      tax_transaction.is_active = false
      adjusted_amount = 0 - tax_transaction.amount
      tax_transaction.time = current_hotel.current_time
      tax_transaction.set_cashier_period
      tax_transaction.comments = financial_transaction.comments
      tax_transaction.save!
      adjusted_transaction = create_adjusted_transaction(tax_transaction, adjusted_amount, 'DELETED')

      FinancialTransaction.record_action(adjusted_transaction, :DELETE_TRANSACTION, :WEB, current_hotel.id)
      FinancialTransaction.record_action(tax_transaction, :DELETE_TRANSACTION, :WEB, current_hotel.id,)
    end
  end

  def split_associated_taxes(financial_transaction, tax_split_percent, parent_transaction)
    taxes_transactions = tax_transactions(financial_transaction)
    taxes_transactions.each do |tax_transaction|

      adjusted_tax = tax_transaction.amount * tax_split_percent / 100
      action_details = []
      action_details << FinancialTransaction.prepare_action_details('amount', '%.2f' % tax_transaction.amount, ['%.2f' % (tax_transaction.amount - adjusted_tax), '%.2f' % adjusted_tax].join(', '))
      tax_transaction.amount = tax_transaction.amount - adjusted_tax
      tax_transaction.time = current_hotel.current_time
      tax_transaction.updater_id = current_user.id
      tax_transaction.save
      tax_transaction.set_cashier_period

      adjusted_transaction = create_adjusted_transaction(tax_transaction, adjusted_tax, "SPLIT", parent_transaction)
      FinancialTransaction.record_action(tax_transaction, :SPLIT_TRANSACTION, :WEB, current_hotel.id, action_details)
      FinancialTransaction.record_action(adjusted_transaction, :SPLIT_TRANSACTION, :WEB, current_hotel.id, action_details)
    end
  end

  def edit_associated_taxes(financial_transaction, tax_edit_percent, parent_transaction)
    taxes_transactions = tax_transactions(financial_transaction)
    taxes_transactions.each do |tax_transaction|
      adjusted_tax = tax_transaction.amount * tax_edit_percent / 100
      adjusted_transaction = create_adjusted_transaction(tax_transaction, adjusted_tax, "EDIT", parent_transaction)
      action_details = []
      action_details << FinancialTransaction.prepare_action_details('amount', '%.2f' % tax_transaction.amount, '%.2f' % (adjusted_transaction.amount+tax_transaction.amount))
      FinancialTransaction.record_action(tax_transaction, :EDIT_TRANSACTION, :WEB, current_hotel.id, action_details)
      FinancialTransaction.record_action(adjusted_transaction, :EDIT_TRANSACTION, :WEB, current_hotel.id, action_details)
    end
  end

  def create_adjusted_transaction(financial_transaction, adjusted_amount, type, parent_transaction=nil)
    new_financial_transaction = FinancialTransaction.new(financial_transaction.attributes.except(
      "amount", "id", "created_at", "updated_at", "is_eod_transaction"))
    new_financial_transaction.amount = adjusted_amount
    new_financial_transaction.transaction_type = type
    new_financial_transaction.parent_transaction_id = parent_transaction.id if parent_transaction
    new_financial_transaction.original_transaction_id = financial_transaction.id
    new_financial_transaction.time = current_hotel.current_time
    new_financial_transaction.updater_id = current_user.id
    new_financial_transaction.save!
    new_financial_transaction.set_cashier_period
    new_financial_transaction
  end

end
