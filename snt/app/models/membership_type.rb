class MembershipType < ActiveRecord::Base
  attr_accessible :membership_class_id, :property_id, :property_type, :property, :value, :description, :membership_class

  has_enumerated :membership_class, class_name: 'Ref::MembershipClass'
  has_many :membership_levels, dependent: :destroy
  has_and_belongs_to_many :hotels, join_table: 'hotels_membership_types'
  belongs_to :property, polymorphic: true, touch: true

  validates :description, :value, presence: { message: I18n.t(:is_required) }
  validate :membership_uniqueness

  # Ensures that membership types are unique across the system, chain, and hotel for membership class
  def membership_uniqueness
    others_exist = false

    # Setup base query for membership class and value
    query = MembershipType.with_membership_class(membership_class).where('lower(value) = lower(?)', value)

    # Do not include the current membership type
    query = query.where('id != ?', id) if persisted?

    if property
      # Check for uniqueness for hotel and chain
      if property.is_a?(Hotel)
        hotel_id = property.id
        chain_id = property.hotel_chain_id
        others_exist = query.for_hotel_id_and_chain_id(hotel_id, chain_id).exists?
      else
        chain_id = property.id
        others_exist = query.for_chain_id(chain_id).exists?
      end
    else
      # Check for uniquess for system
      others_exist = query.where('property_id is null').exists?
    end

    errors.add(:value, :uniqueness) if others_exist
  end

  scope :for_hotel_id_and_chain_id, lambda { |hotel_id, chain_id|
    where("(property_type = 'Hotel' and property_id = :hotel_id) or (property_type = 'HotelChain' and property_id = :chain_id)",
          hotel_id: hotel_id, chain_id: chain_id)
  }

  scope :for_chain_id, lambda { |chain_id|
    where("(property_type = 'HotelChain' and property_id = :chain_id) or (property_type = 'Hotel' and
      property_id in (select id from hotels where hotel_chain_id = :chain_id))", chain_id: chain_id)
  }

  def ffp?
    membership_class === :FFP
  end

  def hlp?
    membership_class === :HLP
  end
end
