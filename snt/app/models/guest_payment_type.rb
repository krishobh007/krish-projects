class GuestPaymentType < ActiveRecord::Base
  attr_accessible :account_no, :bank_routing_no, :card_cvv, :card_expiry, :card_name, :mli_token, :mli_transaction_id,
                  :credit_card_type_id, :credit_card_type, :external_id, :guest_detail_id,
                  :is_on_guest_card, :is_primary, :payment_type_id, :payment_type, :is_swiped, :skip_credit_card_info_validation

  attr_accessor :skip_credit_card_info_validation, :et2, :etb, :ksn, :pan

  belongs_to :guest_detail

  has_many :reservations_guest_payment_types
  has_many :reservations, through: :reservations_guest_payment_types

  belongs_to :payment_type, class_name: 'PaymentType'
  has_enumerated :credit_card_type, class_name: 'Ref::CreditCardType'

  validates :guest_detail_id, :payment_type_id, presence: true
  validates :card_expiry, :mli_token, presence: true, if: :credit_card_info_required?
  validates :credit_card_type_id, presence: true, if: :credit_card?
  validates :mli_token, uniqueness: { scope: [:guest_detail_id] }, if: 'credit_card? && mli_token.present?'
  validates :mli_token, numericality: { only_integer: true }, if: 'credit_card? && mli_token.present?'

  # Commented the validations as we don't have placeholder to input account no and bank routing no, for future use
  # validates :account_no, :bank_routing_no, presence: true, if: :check?
  # validates :account_no, uniqueness: { scope: [:guest_detail_id, :bank_routing_no], case_sensitive: false }, if: :check?
  validates :account_no, presence: true, uniqueness: { scope: :guest_detail_id, case_sensitive: false }, if: :paypal?

  def credit_card?
    payment_type.andand.credit_card?
  end

  def check?
    payment_type.andand.check?
  end

  def paypal?
    payment_type.andand.paypal?
  end

  def direct_payment?
    payment_type.andand.direct_payment?
  end

  def cash?
    payment_type.andand.cash?
  end

  def credit_card_info_required?
    self.credit_card? && !skip_credit_card_info_validation
  end

  # Only return user payment types that are on the guest card
  scope :guest_card_only, -> { where(is_on_guest_card: true) }

  # Only return user payment types that are hidden from the guest card
  scope :not_on_guest_card, -> { where(is_on_guest_card: false) }

  # Only returns primary payment types
  scope :primary, -> { where(is_primary: true) }

  # Returns swiped credit cards that have not had MLI original authorization yet
  scope :needs_original_auth, -> { where(payment_type_id: PaymentType.credit_card.id, is_swiped: true, mli_transaction_id: nil) }

  # Returns payment types that are in a valid state. This excludes credit cards with masked credit card expiry dates or null mli tokens.
  scope :valid, lambda {
    where("(not(lower(card_expiry) like '%x%') and mli_token is not null) or payment_type_id != ?", PaymentType.credit_card.id)
  }

  # Returns payment types that are in an invalid state. This includes credit cards with masked credit card expiry dates or null mli tokens.
  scope :invalid, lambda {
    where("(lower(card_expiry) like '%x%' or mli_token is null) and payment_type_id = ?", PaymentType.credit_card.id)
  }

  # Finds all payment types not linked to a reservation
  scope :not_linked_to_reservation, -> { where('id not in (select guest_payment_type_id from reservations_guest_payment_types)') }

  # Return payment types that are equal to the details based on the payment type
  scope :for_payment_type_details, proc { |payment_type, mli_token, account_no, bank_routing_no, hotel|
    results = scoped
    hotel_payment_type = hotel.payment_types.find_by_value(payment_type)
    results = results.where(payment_type_id: hotel_payment_type.id) if hotel_payment_type

    if payment_type == PaymentType::CREDIT_CARD
      results = results.where(mli_token: mli_token)
    elsif payment_type == PaymentType::CHECK
      results = results.where(account_no: account_no, bank_routing_no: bank_routing_no)
    elsif payment_type == PaymentType::PAYPAL
      results = results.where(account_no: account_no)
    end

    results
  }

  # Only return the last four digits of the mli token
  def mli_token_display
    mli_token.andand.last(4)
  end

  # Convert the card expiry to MM/YY if not masked
  def card_expiry_display
    !self.card_expiry_masked? ? card_expiry_date.strftime('%m/%y') : card_expiry
  end

  # Convert the card expiry for MLI to MMYY if not masked
  def card_expiry_mli_formatted
    !self.card_expiry_masked? ? card_expiry_date.strftime('%m%y') : ''
  end

  # Convert the card expiry to date
  def card_expiry_date
    Date.strptime(card_expiry, '%Y-%m-%d')
  end

  # Determines whether the card expiry is masked or not
  def card_expiry_masked?
    card_expiry.to_s.downcase.count('x') > 0
  end

  # Returns a new instance of a payment type according to the options
  def self.create_and_process(hotel, guest_detail, attributes, add_to_guest_card, add_process = lambda { |p| },is_deposit=false)
    errors = []

    is_swiped = false

    if attributes[:card_expiry].present?
      card_expiry_date = attributes[:card_expiry].to_date
      if !Payment.is_credit_card_expiry_date_valid?(card_expiry_date)
        errors << "Please check the expiry date you have entered"
      end
    end

    if attributes.has_key?(:session_id)
      token_response = Mli.new(hotel).get_token(:session_id => attributes[:session_id], :is_encrypted => false, :is_manual => true)
      if token_response["result"] == "SUCCESS"
        mli_token = token_response["token"]
        response_card_type =  token_response["sourceOfFunds"]["provided"]["card"]["brand"]
        credit_card_type = Ref::CreditCardType[Setting.mli_card_types[response_card_type]].id
        selected_payment_type = 'CC'
      else
        errors << "Payment Gateway Error:" + token_response["error"]["explanation"]
      end
    elsif attributes.has_key?(:mli_token)
      mli_token = attributes[:mli_token]
      et2 = attributes[:et2]
      etb = attributes[:etb]
      ksn = attributes[:ksn]
      pan = attributes[:pan]
      is_swiped = true
    elsif attributes.has_key?(:card_number)
      # Validate that the card number is valid for the card type
      if CreditCardValidator::Validator.card_type(attributes[:card_number]) == Ref::CreditCardType[attributes[:credit_card_type]].andand.validator_code
        # Get the MLI token for the credit card number
        mli_token = Mli.new(hotel).get_token(:card_number => attributes[:card_number], :is_encrypted => false, :is_manual => true)[:data]
      end
    end
    payment_type = attributes[:payment_type] || selected_payment_type
    # Look for existing payment type for this user (either on the guest card or reservation)
    guest_payment_type = guest_detail.payment_types
      .for_payment_type_details(payment_type, mli_token, attributes[:account_no], attributes[:bank_routing_no], hotel).first
    # If the payment type could not be found, create a new one
    unless guest_payment_type
      guest_payment_type = GuestPaymentType.new
      guest_payment_type.payment_type_id = hotel.payment_types.find_by_value(payment_type).id
      guest_payment_type.mli_token = mli_token
      guest_payment_type.guest_detail_id = guest_detail.id
    end
 
    # Set the remaining payment type details
    guest_payment_type.credit_card_type = attributes[:credit_card_type] || credit_card_type
    guest_payment_type.card_expiry = attributes[:card_expiry].present? ? attributes[:card_expiry] : nil
    guest_payment_type.card_name = attributes[:card_name]
    guest_payment_type.is_swiped ||= is_swiped # Only set to not swiped if not previously swiped
    guest_payment_type.et2 = et2
    guest_payment_type.etb = etb
    guest_payment_type.ksn = ksn
    guest_payment_type.pan = pan

    if add_to_guest_card
      guest_payment_type.is_on_guest_card = true

      # Payment type should be primary if it is the first one added
      guest_payment_type.is_primary = !guest_detail.payment_types.guest_card_only.exists?
    else
      guest_payment_type.is_on_guest_card = false
      guest_payment_type.is_primary = false
    end
    # If the payment type is valid, process it using closure and save if no errors
    if guest_payment_type.valid?
      errors += add_process.call(guest_payment_type) unless is_deposit
      guest_payment_type.save! if errors.empty?
    else
      errors += guest_payment_type.errors.full_messages
    end

    { guest_payment_type: guest_payment_type, errors: errors }
  end

  def sync_with_external_pms_profile(hotel)
    errors = []

    # If we have a guest_id and it is a credit card, save it to the 3rd party PMS
    if hotel.is_third_party_pms_configured? && credit_card?
      guest_api = GuestApi.new(hotel.id)
      api_result = guest_api.insert_credit_card(guest_detail.external_id, credit_card_type.to_s, is_primary, card_name, mli_token, card_expiry, et2,
                                                etb, ksn, pan)

      if api_result[:status]
        self.external_id = api_result[:external_id]
      else
        errors << I18n.t(:external_pms_failed)
      end
    end

    errors
  end

  def sync_with_external_pms_reservation(reservation, bill_number)
    errors = []
    hotel = reservation.hotel

    # If bill number is passed use it, otherwise use bill #1
    bill_number ||= 1

    # if 3p PMS is set then call modify payment method
    if hotel.is_third_party_pms_configured?
      card_info = {
        credit_card_type: credit_card_type,
        card_name: card_name,
        mli_token: mli_token,
        et2: et2,
        etb: etb,
        ksn: ksn,
        pan: pan,
        card_expiry: card_expiry,
        bill_number: bill_number
      }

      result = reservation.modify_payment_method_of_external_pms(card_info)
    else
      result[:status] = true
    end

    if result[:status]
      # If card was swiped and not yet authorized, MLI original authorize card for $1
      if is_swiped && !mli_transaction_id
        mli_transaction_id = Mli.new(hotel).original_authorization(reservation, mli_token, card_expiry_mli_formatted)[:data]
      end

      self.save!
      reservation.update_bill_payment_type!(bill_number, self)

      # Destroy all invalid payment types not linked to a reservation
      guest_detail.destroy_invalid_payment_types
    else
      errors << "External PMS rejected the payment method"
    end
    errors
  end
end
