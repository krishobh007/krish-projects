class Ref::RestrictionType < Ref::ReferenceValue
  attr_accessible :editable

  # Is the restriction type activated for the hotel
  def activated?(hotel)
    hotel.restriction_types.include?(self)
  end
end
