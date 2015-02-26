class PaymentType < ActiveRecord::Base
  CREDIT_CARD = 'CC'
  CHECK = 'CK'
  CASH = 'CA'
  DIRECT_BILL = 'DB'
  PAYPAL = 'PAYPAL'

  attr_accessible :is_selectable, :hotel_id, :value, :description
  
  has_many :hotels_payment_types
  has_many :guest_payment_types, class_name: 'PaymentMethod', as: :associated, conditions: { associated_type: 'GuestDetail' }

  validates_uniqueness_of :value , scope: [:hotel_id]
  has_many :charge_codes, class_name: 'ChargeCode', as: :associated_payment
  scope :non_charge_code_linked_payment_types, -> { includes(:charge_codes).where(charge_codes: {associated_payment_id: nil,hotel_id: nil} ) }


  validates :value, :description, presence: true
  #validates_exclusion_of :value, :in => %w(CC CK DB CA), :if => "hotel_id.present?"
  validates :value, :exclusion => { :in => proc { system_specific.pluck(:value) } }, :if => "hotel_id.present?"
  
  validate :is_system_defined
  
  scope :selectable, -> { where(is_selectable: true) }
  scope :non_credit_card, proc { |hotel|
    where("payment_types.value != ? and (payment_types.hotel_id IS NULL OR payment_types.hotel_id = ?)", CREDIT_CARD, hotel.id)
  }

  scope :hotel_payment_types, proc{ |hotel|
    where("hotel_id IS NULL OR hotel_id = ?", hotel.id)
  }

  scope :hotel_specific, proc { |hotel|
    where('hotel_id = ?', hotel.id)
  }

  scope :system_specific, -> { where("hotel_id IS NULL") }
  
  scope :activated_non_credit_card, proc { |hotel|
    joins(:hotels_payment_types)
    .where('hotels_payment_types.hotel_id = ?', hotel.id)
    .where('hotels_payment_types.is_cc = ? OR payment_types.hotel_id IS NULL', false)
    .where('hotels_payment_types.active = ?', true)
    .where('hotels_payment_types.is_web_only != ?', true)
  }
  
  scope :activated_credit_card, proc  { |hotel|
    joins(:hotels_payment_types)
    .where('hotels_payment_types.hotel_id = ?', hotel.id)
    .where('hotels_payment_types.is_cc = ? AND payment_types.hotel_id IS NOT NULL', true)
    .where('hotels_payment_types.active = ?', true)
    .where('hotels_payment_types.is_web_only != ?', true)
  }

  def self.credit_card
    Rails.cache.fetch("PaymentType:system:#{CREDIT_CARD}") do
      where(value: CREDIT_CARD, hotel_id: nil).first
    end
  end
  
  def self.credit_card_type(value)
    system_cc_type = Ref::CreditCardType[value.to_sym]
    return system_cc_type unless system_cc_type.nil?
    
    payment_type_flagged_as_cc = self.where(:value => value).first
    return payment_type_flagged_as_cc
  end
  
  def credit_card?
    value == CREDIT_CARD && !hotel_id
  end

  def check?
    value == CHECK && !hotel_id
  end

  def paypal?
    value == PAYPAL && !hotel_id
  end

  def direct_payment?
    value == DIRECT_BILL && !hotel_id
  end

  def cash?
    value == CASH && !hotel_id
  end
  
  def is_system_defined
    if hotel_id.nil?
      errors.add(:is, "system defined")
    end
  end
  
  def offline?(hotel)
    hotels_payment_type = hotel.hotels_payment_types.where(:payment_type_id => self.id).first
    return hotels_payment_type.andand.is_offline
  end
  
  def is_cc?(hotel)
    hotels_payment_type = hotel.hotels_payment_types.where(:payment_type_id => self.id).first
    return (hotels_payment_type.is_cc || self.credit_card?)
  end

  #Find the charge code linked to a payment type for a particular hotel
  def charge_code(hotel)
    hotel.charge_codes.payment.non_cc.find_by_associated_payment_id(self.id)
  end
  
end
