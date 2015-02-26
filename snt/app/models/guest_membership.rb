class GuestMembership < ActiveRecord::Base
  attr_accessible :membership_type_id, :membership_type, :membership_card_number, :membership_expiry_date, :membership_level,
                  :name_on_card, :membership_start_date, :external_id, :guest_detail_id, :membership_level_id

  belongs_to :guest_detail
  has_and_belongs_to_many :reservations, uniq: true, join_table: 'reservations_memberships', foreign_key: 'membership_id'

  belongs_to :membership_type
  belongs_to :membership_level

  validates :membership_type_id, :membership_card_number, :guest_detail_id,
            presence: true

  validates :membership_type_id, uniqueness: { scope: :guest_detail_id }

  validate :membership_number_uniqueness

  # Determine if the membership number is unique for the type and guest_detail's hotel chain
  def membership_number_uniqueness
    if GuestMembership.includes(:guest_detail)
        .where('lower(membership_card_number) = lower(?) AND membership_type_id = ? AND guest_details.hotel_chain_id = ? AND
          guest_memberships.id != ?', membership_card_number, membership_type_id, guest_detail.hotel_chain_id, id).count > 0
      errors.add(:membership_card_number, 'must be unique')
    end
  end

  scope :ffp, lambda {
    includes(:membership_type).where('membership_types.property_id is null and membership_types.membership_class_id = ?',
                                     Ref::MembershipClass[:FFP].id)
  }

  scope :hlp, proc { |hotel|
    includes(:membership_type).where('membership_types.membership_class_id = ?', Ref::MembershipClass[:HLP].id)
    .where("(membership_types.property_id = :hotel_id and membership_types.property_type = 'Hotel') or
            (membership_types.property_id = :chain_id and membership_types.property_type = 'HotelChain')",
           chain_id: hotel.hotel_chain_id, hotel_id: hotel.id)
  }

  # Returns a hash of some of the important details
  def details_hash
    {
      'id' => id,
      'membership_type' => membership_type_id ? MembershipType.find(membership_type_id).value : '',
      'membership_card_number' => membership_card_number,
      'membership_level' => membership_level_id ? MembershipLevel.find(membership_level_id).membership_level : ''
    }
  end
end
