class RoomRateRestriction < Restriction
  attr_accessible :date, :room_type_id

  belongs_to :room_type

  has_enumerated :type, class_name: 'Ref::RestrictionType'

  validates :date, :room_type, presence: true
  validates :type_id, uniqueness: { scope: [:date, :rate_id, :room_type_id] }

  scope :between_dates, ->(from_date, to_date) { where('? <= date and date <= ?', from_date, to_date) }
end
