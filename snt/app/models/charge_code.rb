class ChargeCode < ActiveRecord::Base
  extend ActiveModel::Naming
  attr_accessible :charge_code, :hotel_id, :charge_code_type, :description, :post_type_id, :amount_type_id,
                  :amount, :amount_symbol, :associated_payment_id, :associated_payment_type,
                  :minimum_amount_for_fees

  CASH = 'CA'
  CHECK = 'CK'

  has_many :financial_transactions
  has_and_belongs_to_many :charge_groups, join_table: 'charge_groups_codes'
  has_and_belongs_to_many :billing_groups, join_table: 'charge_codes_billing_groups'
  has_many :financial_transactions
  has_many :charge_code_generates
  has_many :items
  has_many :policies
  has_enumerated :charge_code_type, class_name: 'Ref::ChargeCodeType'
  has_enumerated :amount_type, class_name: 'Ref::AmountType'
  has_enumerated :post_type, class_name: 'Ref::PostType'
  belongs_to :hotel
  belongs_to :associated_payment, polymorphic: true

  validates :charge_code, uniqueness: { scope: [:hotel_id], case_sensitive: false }
  validates :charge_code, :hotel_id, :charge_code_type, presence: true
  validates :description, presence: true
  
  validate :has_charge_groups?

  validate :has_payment_type?
  has_enumerated :charge_code_type, class_name: 'Ref::ChargeCodeType'
  has_enumerated :amount_type, class_name: 'Ref::AmountType'
  has_enumerated :post_type, class_name: 'Ref::PostType'


  scope :credit, -> { with_charge_code_type(:PAYMENT) }
  scope :charge, -> { exclude_charge_code_type(:PAYMENT) }
  scope :room_charge_codes, -> { where('charge_code_type_id = :room', room: Ref::ChargeCodeType[:ROOM]) }
  scope :exclude_payments, -> { where('charge_code_type_id <> :payment', payment: Ref::ChargeCodeType[:PAYMENT]) }
  scope :payment, -> { where('charge_code_type_id = :payment', payment: Ref::ChargeCodeType[:PAYMENT])}
  scope :non_cc, -> { where('associated_payment_type = ?', 'PaymentType') }
  scope :cc, -> { where('associated_payment_type = ?', 'Ref::CreditCardType') }

  scope :cash, ->(hotel) { where('associated_payment_type = ? AND associated_payment_id = ?',
                          'PaymentType',
                          hotel.payment_types.where(value: CASH) ) }

  scope :checks, ->(hotel) { where('associated_payment_type = ? AND associated_payment_id = ?',
                          'PaymentType',
                          hotel.payment_types.where(value: CHECK) ) }


  scope :non_item_linked_charge_codes, -> { includes(:items).where(items: {charge_code_id: nil} ) }

  scope :fees, -> { where(charge_code_type_id: Ref::ChargeCodeType[:FEES].andand.id) }
  scope :tax, -> { where(charge_code_type_id: Ref::ChargeCodeType[:TAX].andand.id) }
  scope :include_charge, -> { exclude_charge_code_types(:PAYMENT, :TAX, :FEES) }

  def self.code(payment_method, hotel)
    payment_type = payment_method.payment_type.value.to_s
    credit_card = payment_method.credit_card_type.to_s if payment_type == 'CC'
    charge_codes = hotel.charge_codes.payment
    charge_code = (payment_type == "CC") ?
      charge_codes.cc.find_by_associated_payment_id(
          Ref::CreditCardType[credit_card].id
        ) : charge_codes.non_cc.find_by_associated_payment_id(
          PaymentType.find_by_value(payment_type).id
        )
    charge_code
  end

  def has_charge_groups?
    errors.add :base, "Charge group can't be blank" if charge_groups.blank? && !hotel.external_pms?
  end

  def has_payment_type?
    errors.add :base, "Payment Type can't be blank" if is_payment? && !hotel.external_pms? && associated_payment_type.blank?
  end

  scope :non_item_linked_charge_codes, -> { includes(:items).where(items: {charge_code_id: nil} ) }
  scope :payment, -> { where('charge_code_type_id = :payment', payment: Ref::ChargeCodeType[:PAYMENT])}
  scope :non_cc, -> { where('associated_payment_type = ?', 'PaymentType') }
  scope :cc, -> { where('associated_payment_type = ?', 'Ref::CreditCardType') }

  def is_tax?
    self.charge_code_type == Ref::ChargeCodeType[:TAX]
  end

  def is_payment?
     self.charge_code_type === :PAYMENT
  end

  # This will return the tax amount for a tax_code
  def tax_amount(charge_amount, reservation)
    if amount_symbol == "amount"
      tax_amount = amount
    elsif amount_symbol == "percent" || amount_symbol == "%"
      tax_amount = charge_amount.to_f * amount / 100
    end
    daily_instance = reservation.current_daily_instance
    if tax_amount
      if amount_type === :ADULT
        tax_amount = daily_instance.adults * tax_amount if daily_instance.adults
      elsif amount_type === :CHILD
        tax_amount = daily_instance.children * tax_amount if daily_instance.children
      elsif amount_type === :PERSON
        tax_amount = daily_instance.total_guests * tax_amount if daily_instance.total_guests
      end
    end
    tax_amount
  end

  def should_post?(bill)
    should_post = false
    if post_type === :STAY
      #check whether it has already been posted
      existing = bill.financial_transactions.find_by_charge_code_id_and_is_active(id, true)
      should_post = true if !existing
    elsif post_type === :NIGHT
      should_post = true
    end
    should_post
  end

  def tax_information
    tax_info = []
    charge_code_generates.tax(hotel).each  do |generate|
      tax_info << {
        charge_code_id: generate.generate_charge_code_id,
        is_inclusive: generate.is_inclusive,
        calculation_rules: generate.tax_calculation_rule_charge_codes.map {|x| x.id}
      }
    end
    tax_info
  end

  def fees_information
    fees_details = {}
    fees = charge_code_generates.fees(hotel).first
    fees_charge_code = hotel.charge_codes.find(fees.generate_charge_code_id) if fees
    if fees_charge_code
      fees_details = {
        charge_code_id: fees_charge_code.id,
        amount_symbol: fees_charge_code.amount_symbol,
        amount_sign: (amount && amount < 0) ? "-" : "+",
        amount: fees_charge_code.amount,
        minimum_amount_for_fees: fees_charge_code.minimum_amount_for_fees,
        description: fees_charge_code.description
      } 
    end
    fees_details
  end

  # Return the taxes for a charge code
  # Arguments : amount to which the tax calculation is to be applied
  #             reservation, bill
  #             incluseve : flag to determine whether to return inclusive or exclusive tax
  # Sample output: 
  #             [{123, 2.5}, {124, 3.5}] 
  def taxes(charge_amount, reservation, bill, inclusive=false)
    tax_generates = self.charge_code_generates.tax(hotel).where(is_inclusive: inclusive)
    charge_amount = charge_amount.to_f
    hotel = reservation.hotel
    total_tax = []
    tax_generates.each do |charge_code_generate|
      tax_code = hotel.charge_codes.find(charge_code_generate.generate_charge_code_id)
      tax_details = {}
      if tax_code.should_post?(bill)
        base_tax_amount = tax_code.tax_amount(charge_amount, reservation)

        #Find the charge codes which is applied to the calculation rule of the tax
        tax_calculation_charge_codes = charge_code_generate.tax_calculation_rule_charge_codes
        # If there are no additional taxes associated with the calculation rule
        # the tax percentage / amount is aplied to the actual amount
        # else sum up the taxes of of all charge codes used to build the calculation rule
        if tax_calculation_charge_codes.empty?
          tax_amount = base_tax_amount
        else
          
          tax_amounts = Array.new
          base_amount = charge_amount
          tax_calculation_charge_codes.each do  |calculation_code|
            tax = calculation_code.amount ? calculation_code.tax_amount(base_amount, reservation) : 0.0
            base_amount = base_amount + tax
            tax_amounts << tax
          end
        end
        tax_details[:code_id] = tax_code.id
        if tax_amounts && !tax_amounts.empty?
          tax_details[:amount] = tax_code.tax_amount(charge_amount + tax_amounts.sum, reservation)
        else
          tax_details[:amount] = tax_amount
        end
        total_tax << tax_details
      end
    end
    total_tax
  end

end
