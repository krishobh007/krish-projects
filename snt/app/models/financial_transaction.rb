class FinancialTransaction < ActiveRecord::Base
  attr_accessible :date, :amount, :currency_code_id, :currency_code, :charge_code_id, :bill_id,
    :reference_number, :external_id, :is_active, :article_id, :parent_transaction_id,
    :credit_card_transaction, :credit_card_transaction_id,
    :transaction_type, :is_eod_transaction, :comments,
    :creator_id, :updater_id, :time, :original_transaction_id,
    :cashier_period_id, :reference_text,
    :child_transactions_attributes

  belongs_to :bill
  belongs_to :charge_code
  belongs_to :credit_card_transaction
  belongs_to :article
  belongs_to :user, foreign_key: 'updater_id'
  belongs_to :cashier_period
  
  has_enumerated :currency_code, class_name: 'Ref::CurrencyCode'
  
  has_many :child_transactions, class_name: 'FinancialTransaction', foreign_key: 'parent_transaction_id'
  belongs_to :parent_transaction, class_name: 'FinancialTransaction', foreign_key: 'parent_transaction_id'

  has_many :adjusted_transactions, class_name: 'FinancialTransaction', foreign_key: 'original_transaction_id'
  belongs_to :original_transaction, class_name: 'FinancialTransaction', foreign_key: 'original_transaction_id'

  accepts_nested_attributes_for :child_transactions

  validates :date, :amount, :currency_code_id, :bill_id, presence: true

  scope :exclude_room, -> { includes(:charge_code).where('charge_codes.charge_code_type_id != ?', Ref::ChargeCodeType[:ROOM].id) }
  scope :include_room, -> { includes(:charge_code).where('charge_codes.charge_code_type_id = ?', Ref::ChargeCodeType[:ROOM].id) }
  scope :exclude_payment, -> { includes(:charge_code).where('charge_codes.charge_code_type_id != ?', Ref::ChargeCodeType[:PAYMENT].id) }
  scope :include_payment, -> { includes(:charge_code).where('charge_codes.charge_code_type_id = ?', Ref::ChargeCodeType[:PAYMENT].id) }
  scope :include_cc_payments, -> { includes(:charge_code).where('charge_codes.charge_code_type_id = ? AND charge_codes.associated_payment_type = ?', Ref::ChargeCodeType[:PAYMENT].id, 'Ref::CreditCardType') }

  scope :is_active, -> { where(is_active: true) }

  scope :debit, proc { |is_rate_suppressed|
    results = exclude_payment

    if is_rate_suppressed
      results = results.exclude_room
    end

    results
  }

  scope :credit, -> { include_payment }
  scope :cc_credit, -> { include_cc_payments }
  scope :fees, -> { includes(:charge_code).where('charge_codes.charge_code_type_id = ?', Ref::ChargeCodeType[:FEES].id) }
  
  scope :cash, ->(hotel) { where('charge_code_id IN (?)', ChargeCode.cash(hotel).pluck(:id))}
  scope :checks, ->(hotel) { where('charge_code_id IN (?)', ChargeCode.checks(hotel).pluck(:id))}

  def self.create_or_update_transaction(bill_items, bill, hotel)
    external_ids = bill_items.map { |bill_item| bill_item[:transaction_no] }
    existing_transactions = FinancialTransaction.where('external_id IN (?)',  external_ids)
    existing_transaction_ids = []

    if hotel.is_third_party_pms_configured?
      # deleting records which have been deleted in external pms
      FinancialTransaction.where('bill_id = ? and external_id NOT IN (?)',  bill.id, external_ids).destroy_all
      existing_transaction_ids = existing_transactions.pluck(:external_id)
    end

    new_transactions = []

    bill_items.each do |item|

      if item[:charge_code].present?
        charge_code = ChargeCode.find_by_charge_code_and_hotel_id(item[:charge_code], hotel.id)
      else
        charge_code = ChargeCode.where("hotel_id = ? and lower(replace(trim(charge_codes.description),' ','')) = ?",
                                       hotel.id, item[:charge_code_description].gsub(/\s+/, '').strip.downcase).first
      end
      charge_code_id = charge_code ? charge_code.id : nil
      is_charge_code_payment = charge_code.andand.charge_code_type === :PAYMENT

      currency_code = item[:currency_code].present? ? Ref::CurrencyCode[item[:currency_code]] : hotel.default_currency
      currency_code_id = currency_code.andand.id

      if is_charge_code_payment && item[:amount].to_f < 0
        item[:amount] = item[:amount].to_f.abs
      elsif is_charge_code_payment && item[:amount].to_f > 0
        item[:amount] = -item[:amount].to_f
      end

      item.deep_merge!(bill_id: bill.id, charge_code_id: charge_code_id, currency_code_id: currency_code_id,
                       external_id: item[:transaction_no])
      if item[:child_transactions_attributes]
        item[:child_transactions_attributes].each do |child|
          child.deep_merge!(bill_id: bill.id, currency_code_id: currency_code_id)
          child.except!(:revenue_group, :currency_code)
        end
      end
      item.except!(:charge_code_description, :revenue_group, :transaction_no, :charge_code, :currency_code)
      if existing_transaction_ids.include?(item[:external_id])
        existing_transactions.select { |tr| tr.external_id == item[:external_id] }.first.update_attributes(item)
      else
        new_transactions << item
      end
    end
    if new_transactions.count > 0
      FinancialTransaction.create(new_transactions)
    end
  end

  def self.record_action(transaction, type, application, hotel_id, action_details=[])
    Action.record!(transaction, type, application, hotel_id, action_details)
  end

  def self.prepare_action_details(key, old_value, new_value)
    {
      key: key,
      old_value: old_value,
      new_value: new_value
    }
  end

  def self.create_fees_transactions(parent_transaction, fees_amount, fees_charge_code_id) 
    # This will be recorded as Fees
    fees_recorded = parent_transaction.bill.financial_transactions.create(
      date: parent_transaction.date,
      currency_code_id: parent_transaction.currency_code_id,
      charge_code_id: fees_charge_code_id,
      time: parent_transaction.time,
      parent_transaction_id: parent_transaction.id,
      amount: fees_amount
    )
      
  end

  def self.refund_charge_code_fees(bill, hotel)
    fees_to_refund = bill.financial_transactions.where('charge_code_id in (?)', hotel.charge_codes.fees.pluck(:id))
    fees_to_refund.each do |fee|
      bill.financial_transactions.create(
        date: hotel.active_business_date,
        currency_code_id: fee.currency_code_id,
        charge_code_id: fee.charge_code_id,
        time: hotel.current_time,
        parent_transaction_id: fee.parent_transaction_id,
        amount: -(fee.amount)
        )

    end
  end

  def first_transaction_or_no_other_active_cashier_period?
    hotel = self.bill.reservation.hotel
    user_id = self.updater_id
    user = hotel.users.find(user_id) if user_id
    if user
      financial_transactions = user.financial_transactions.where(date: hotel.active_business_date)

      financial_transactions.count == 1 || !user.active_cashier_period
    else
      false
    end
  end

  def open_cashier_period
    hotel = self.bill.reservation.hotel
        
    options = {
      user_id: self.creator_id,
      starts_at: self.date.andand.strftime("%Y-%m-%d").to_s + " " + self.time.andand.strftime("%H:%M:%S %Z").to_s,
      hotel: hotel,
      creator_id: self.creator_id,
      updater_id: self.creator_id
    }
    cashier_period = CashierPeriod.open(options) 

    cashier_period
  end

  def set_cashier_period
    if !self.is_eod_transaction
      if self.first_transaction_or_no_other_active_cashier_period?
        self.open_cashier_period
      end
      self.cashier_period_id = self.updater.andand.active_cashier_period.andand.id
      self.save
    end
  end

  def record_details(options)
    payment_method = options[:payment_method]
    item_details = options[:item_details]
    comments = options[:comments]
    hotel = options[:hotel]
    details = ""
    if payment_method && payment_method.credit_card?
      #Record the details of transaction in the comments field
      details = details + "Ending with : #{payment_method.andand.mli_token_display}"
      details = details + "<br />" + "Expiry date : #{payment_method.andand.card_expiry_display}"
    elsif item_details
      details = "Item: #{item_details[:description]} <br /> Amount: #{hotel.default_currency.symbol + '%.2f' % item_details[:amount]}"
    elsif comments
      details = details + comments
    end
    self.update_attribute(:comments, details)
  end

end
