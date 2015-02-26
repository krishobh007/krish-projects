class HotelsCreditCardType < ActiveRecord::Base
  
  attr_accessible :is_cc, :is_offline, :is_rover_only, :is_web_only, :hotel, :credit_card_type, :active, :is_display_reference
  
  belongs_to :hotel
  belongs_to :credit_card_type, class_name: 'Ref::CreditCardType', foreign_key: :ref_credit_card_type_id
end