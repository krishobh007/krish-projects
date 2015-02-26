class HotelsRestrictionType < ActiveRecord::Base
  attr_accessible :hotel_id, :restriction_type_id

  belongs_to :hotel
  belongs_to :restriction_type, class_name: 'Ref::RestrictionType'

  validates :hotel, :restriction_type, presence: true
  validates :restriction_type_id, uniqueness: { scope: :hotel_id }
end
