class Ref::CreditCardType < Ref::ReferenceValue
  attr_accessible :validator_code
  
  has_many :hotels_credit_card_types, foreign_key: 'ref_credit_card_type_id'
  has_many :hotels, through: :hotels_credit_card_types
  
  default_scope { order('ref_credit_card_types.description ASC') }
  has_many :charge_codes, class_name: 'ChargeCode', as: :associated_payment
  scope :non_charge_code_linked_credit_card_types, -> { includes(:charge_code).where(charge_codes: { associated_payment_id: nil }) }
  
  scope :activated, proc { |hotel| 
    joins(:hotels_credit_card_types).where('hotels_credit_card_types.active = ?', true)
    .where('hotels_credit_card_types.hotel_id = ?', hotel.id)
  }

  # Find the charge code of a creit card type for a specific hotel
  def charge_code(hotel)
    hotel.charge_codes.payment.cc.find_by_associated_payment_id(self.id)
  end
  
  def offline?(hotel)
    hotels_credit_card_type = hotel.hotels_credit_card_types.where(:ref_credit_card_type_id => self.id).first
    return hotels_credit_card_type.andand.is_offline
  end
end
