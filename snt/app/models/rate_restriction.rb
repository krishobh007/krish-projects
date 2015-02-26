class RateRestriction < Restriction
  has_enumerated :type, class_name: 'Ref::RestrictionType'

  validates :type_id, uniqueness: { scope: :rate_id }
end
