class PaymentMethod < ActiveRecord::Base
  attr_accessible :account_no, :bank_routing_no, :card_cvv, :card_expiry, :card_name, :mli_token, :mli_transaction_id,
                  :credit_card_type_id, :credit_card_type, :external_id, :bill_number, :associated_id, :associated_type,
                  :is_primary, :payment_type_id, :payment_type, :is_swiped, :skip_credit_card_info_validation,
                  :credit_card_transactions_attributes

  attr_accessor :skip_credit_card_info_validation, :et2, :etb, :ksn, :pan

  belongs_to :associated, polymorphic: true, touch: true

  belongs_to :payment_type, class_name: 'PaymentType'
  has_enumerated :credit_card_type, class_name: 'Ref::CreditCardType'
  
  has_many :credit_card_transactions
  
  #Removed validation for associated since we need to store unassociated payment_method - CICO-11518
  validates :payment_type, presence: true
  validates :mli_token, presence: true, if: :credit_card_info_required?
  validates :credit_card_type_id, presence: true, if: :credit_card?
  
  
  # validates :mli_token, uniqueness: { scope: [:associated_id, :associated_type, :bill_number] }, if: 'credit_card? && mli_token.present?'
  # validates :mli_token, numericality: { only_integer: true }, if: 'credit_card? && mli_token.present?'

  # Commented the validations as we don't have placeholder to input account no and bank routing no, for future use
  # validates :account_no, :bank_routing_no, presence: true, if: :check?
  # validates :account_no, uniqueness: { scope: [:guest_detail_id, :bank_routing_no], case_sensitive: false }, if: :check?
  validates :account_no, presence: true, uniqueness: { scope: [:associated_id, :associated_type], case_sensitive: false }, if: :paypal?
  
  validates_uniqueness_of :mli_token, scope: [:associated_id, :associated_type, :bill_number], if: 'credit_card? && associated_id.present?'
  validate :expiry_date_is_in_future, if: 'credit_card?'
  
  
  
  accepts_nested_attributes_for :credit_card_transactions
  
  def credit_card?
    payment_type.andand.credit_card? || credit_card_type.present?
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

  # Return payment types that are equal to the details based on the payment type
  scope :for_payment_type_details, proc { |payment_type, mli_token, account_no, bank_routing_no|
    results = scoped
    results = results.includes(:payment_type).where('payment_types.value = ?', payment_type)
    if payment_type.to_s == PaymentType::CREDIT_CARD
      results = results.where(mli_token: mli_token)
    elsif payment_type.to_s == PaymentType::CHECK
      results = results.where(account_no: account_no, bank_routing_no: bank_routing_no)
    elsif payment_type.to_s == PaymentType::PAYPAL
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
    card_expiry_date.present? && !self.card_expiry_masked? ? card_expiry_date.strftime('%m/%y') : card_expiry
  end

  # Convert the card expiry for MLI to MMYY if not masked
  def card_expiry_mli_formatted
    !self.card_expiry_masked? ? card_expiry_date.strftime('%m%y') : ''
  end

  # Convert the card expiry to date
  def card_expiry_date
    card_expiry.present? && !card_expiry_masked? ? Date.strptime(card_expiry, '%Y-%m-%d') : card_expiry
  end
  
  # Validation for expiry date
  def expiry_date_is_in_future
    unless card_expiry_masked?
      if card_expiry.present?
        if (Date.strptime(card_expiry, '%Y-%m-%d') < Date.today)
          errors.add(:card_expiry, "is invalid")
        end
      end
    end
  end

  # Determines whether the card expiry is masked or not
  def card_expiry_masked?
    card_expiry.to_s.downcase.count('x') > 0
  end

  def charge_code(hotel)
    charge_code = self.credit_card? ?
      self.credit_card_type.andand.charge_code(hotel) : 
      self.payment_type.andand.charge_code(hotel)
    charge_code
  end

  def fees_information(hotel)
    self.charge_code(hotel).andand.fees_information || {}
  end

  # Create the payment type on the reservation, and possibly copy to the guest card
  def self.create_on_reservation!(reservation, attributes, add_to_guest_card = false)
    is_already_on_guest_card = false

    add_process = lambda do |new_payment_method|
      if add_to_guest_card
        guest_detail = reservation.primary_guest

        if guest_detail
          # Opera is automatically adding credit card to guest
          guest_result = create_on_guest!(guest_detail, reservation.hotel, attributes, false)

          is_already_on_guest_card = guest_result[:is_already_present]
        end
      end

      # Sync with external PMS, if configured
      new_payment_method.sync_with_external_pms_reservation(reservation)
    end

    reservation_result = create_and_process!(reservation, reservation.hotel, attributes, add_process)

    reservation_result.merge(is_already_on_guest_card: is_already_on_guest_card)
  end

  # Create the reservation on the guest
  def self.create_on_guest!(guest_detail, hotel, attributes, sync_to_external_pms = true)
    add_process = lambda do |new_payment_method|
      # Payment type should be primary if it is the first one added
      new_payment_method.is_primary = !new_payment_method.associated.payment_methods.exists?

      # Sync with external PMS, if configured
      sync_to_external_pms ? new_payment_method.sync_with_external_pms_profile(hotel) : []
    end

    create_and_process!(guest_detail, hotel, attributes, add_process)
  end

  # Create the unassociated payment method
  def self.create_unassociated!(attributes, hotel)
    result = create_and_process!(nil, hotel, attributes, nil)
  end

  # Returns a new instance of a payment type according to the options
  def self.create_and_process!(associated, hotel, attributes, add_process = ->(p) {})
    errors = []
    is_already_present = true
    is_swiped = false
    custom_payment_type = attributes[:custom_payment_type]
    
    errors += validate_expiry_date(attributes[:card_expiry])

    if attributes[:token].present?
      if hotel.payment_gateway == 'sixpayments'
        token_client = SixPayment::Web2Pay::Token::Client.new(hotel)
        token = token_client.check_token(attributes[:token])
        mli_token = token.token_no
        credit_card_type = Ref::CreditCardType[Setting.six_payment_card_types[token.card_type_code.to_sym]]
        attributes[:credit_card_type] = credit_card_type
        attributes[:card_name] = token.card_holder_forename
        attributes[:card_expiry] = token.card_expiry_yymm.present? ? Date.strptime(token.card_expiry_yymm,"%y%m").to_s : "XXXX-XX-XX"
        attributes[:payment_type] = :CC
      elsif hotel.payment_gateway == 'MLI'
        token_response = Mli.new(hotel).get_token(session_id: attributes[:token], is_encrypted: false, is_manual: true)
        if token_response['result'] == 'SUCCESS'
          mli_token = token_response['token']
          response_card_type =  token_response['sourceOfFunds']['provided']['card']['brand']
          attributes[:credit_card_type] = Ref::CreditCardType[Setting.mli_card_types[response_card_type.to_sym]].id
          attributes[:payment_type] = :CC
        else
          errors << 'Payment Gateway Error: ' + token_response['error']['explanation']
        end
      end
    elsif attributes[:mli_token].present?
      mli_token = attributes[:mli_token]
      et2 = attributes[:et2]
      etb = attributes[:etb]
      ksn = attributes[:ksn]
      pan = attributes[:pan]
      is_swiped = attributes[:is_swipe].nil? ? true : attributes[:is_swipe]

    elsif attributes[:card_number].present?
      # Validate that the card number is valid for the card type
      card_type = CreditCardValidator::Validator.card_type(attributes[:card_number])

      if card_type == Ref::CreditCardType[attributes[:credit_card_type]].andand.validator_code
        # Get the MLI token for the credit card number
        mli_token = Mli.new(hotel).get_token(card_number: attributes[:card_number], is_encrypted: false, is_manual: true)[:data]
      end
    end
    if associated
      payment_method = associated.payment_methods
        .for_payment_type_details(attributes[:payment_type], mli_token, attributes[:account_no], attributes[:bank_routing_no]).first

      # Delete the previous attached payments for the bill and reservation
      if attributes[:bill_number].present? && associated.payment_methods.find_by_bill_number(attributes[:bill_number]).present? && associated.class.to_s == Setting.payment_associated[:reservation]
        already_attached_payments_for_bill = associated.payment_methods.where("bill_number = ? and id !=  ? ", attributes[:bill_number], payment_method.andand.id) if payment_method
        already_attached_payments_for_bill = associated.payment_methods.where("bill_number = ?", attributes[:bill_number]) unless payment_method
        already_attached_payments_for_bill.destroy_all if already_attached_payments_for_bill.present?
      end
    else 
      payment_method = PaymentMethod.where('associated_id IS NULL AND associated_type IS NULL').for_payment_type_details(attributes[:payment_type], mli_token, attributes[:account_no], attributes[:bank_routing_no]).first
    end
    
    # If the payment type could not be found, create a new one
    unless payment_method.present? && payment_method.bill_number == attributes[:bill_number]
      payment_method = PaymentMethod.new
      if custom_payment_type.present?
        payment_method.payment_type_id = PaymentType.hotel_payment_types(hotel).find_by_value(custom_payment_type).andand.id
      else
        payment_method.payment_type_id = PaymentType.hotel_payment_types(hotel).find_by_value(attributes[:payment_type]).andand.id
      end
      payment_method.mli_token = mli_token
      payment_method.associated = associated if associated
      is_already_present = false
    end
    
    # Set the remaining payment type details
    payment_method.credit_card_type = attributes[:credit_card_type]
    payment_method.card_expiry = attributes[:card_expiry].present? ? attributes[:card_expiry] : nil
    payment_method.card_name = attributes[:card_name]
    payment_method.is_swiped ||= is_swiped # Only set to not swiped if not previously swiped
    payment_method.et2 = et2
    payment_method.etb = etb
    payment_method.ksn = ksn
    payment_method.pan = pan
    payment_method.is_primary ||= false
    payment_method.bill_number = attributes[:bill_number]
    payment_method.mli_token = mli_token

    # If the payment type is valid, process it using closure and save if no errors
    if payment_method.valid?
      errors += add_process.call(payment_method) if add_process
      payment_method.save! if errors.empty?
    else
      errors += payment_method.errors.full_messages
    end

    { payment_method: payment_method, payment_name: payment_method.payment_type.andand.description, is_already_present: is_already_present, errors: errors }
  end
                    
  def self.validate_expiry_date(card_expiry)
    errors = []

    if card_expiry.present?
      card_expiry_date = card_expiry.to_date
      unless Payment.is_credit_card_expiry_date_valid?(card_expiry_date)
        errors << 'Please check the expiry date you have entered'
      end
    elsif card_expiry.blank? && !card_expiry.nil?
      errors << 'Please check the expiry date you have entered'
    end

    errors
  end

  def sync_with_external_pms_profile(hotel)
    errors = []

    # If we have a guest_id and it is a credit card, save it to the 3rd party PMS
    if hotel.is_third_party_pms_configured? && credit_card?
      guest_api = GuestApi.new(hotel.id)
      api_result = guest_api.insert_credit_card(associated.external_id, credit_card_type.to_s, is_primary, card_name, mli_token, card_expiry, et2,
                                                etb, ksn, pan)

      if api_result[:status]
        self.external_id = api_result[:external_id]
      else
        errors << I18n.t(:external_pms_failed)
      end
    end

    errors
  end

  def sync_with_external_pms_reservation(reservation)
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
      result = { status: true }
    end

    if result[:status]
      # If card was swiped and not yet authorized, MLI original authorize card for $1
      if is_swiped && !mli_transaction_id
        self.mli_transaction_id = Mli.new(hotel).original_authorization(reservation, mli_token, card_expiry_mli_formatted)[:data]
      end
    else
      errors << 'External PMS rejected the payment method'
    end

    errors
  end
end
