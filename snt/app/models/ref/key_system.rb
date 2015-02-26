class Ref::KeySystem < Ref::ReferenceValue
  attr_accessible :key_card_type, :aid, :keyb, :retrieve_uid, :encoder_enabled

  has_enumerated :key_card_type, class_name: 'Ref::KeyCardType'
end
