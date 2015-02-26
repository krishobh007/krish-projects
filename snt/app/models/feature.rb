class Feature < ActiveRecord::Base
  attr_accessible :description, :value, :feature_type, :feature_type_id, :hotel_id

  belongs_to :feature_type, inverse_of: :features

  has_and_belongs_to_many :hotels, uniq: true, class_name: 'Hotel', join_table: 'hotels_features', association_foreign_key: 'hotel_id'
  has_and_belongs_to_many :rooms, uniq: true, class_name: 'Room', join_table: 'rooms_features', association_foreign_key: 'room_id'
  has_and_belongs_to_many :guest_details, uniq: true, class_name: 'GuestDetail', join_table: 'guest_features', association_foreign_key: 'guest_detail_id'
  has_and_belongs_to_many :reservations, uniq: true, class_name: 'Reservation', join_table: 'reservations_features', association_foreign_key: 'reservation_id'

  validates :value, :feature_type, presence: true
  validates :value, uniqueness: { scope: [:feature_type_id, :hotel_id], case_sensitive: false }

  scope :is_system, -> { where(hotel_id: nil) }
  scope :for_hotel_or_system, proc { |hotel| where('hotel_id = ? OR hotel_id is null', hotel.id) }

  scope :newspaper, -> { includes(:feature_type).where("feature_types.value = 'NEWSPAPER'") }
  scope :floor, -> { includes(:feature_type).where("feature_types.value = 'FLOOR'") }
  scope :elevator, -> { includes(:feature_type).where("feature_types.value = 'ELEVATOR'") }
  scope :smoking, -> { includes(:feature_type).where("feature_types.value = 'SMOKING'") }
  scope :room_type, -> { includes(:feature_type).where("feature_types.value = 'ROOM TYPE'") }
  scope :room_feature, -> { joins(:feature_type).where("feature_types.value = 'ROOM FEATURE'") }

  scope :exclude_feature_type, -> { includes(:feature_type).where('feature_types.value not in (?, ?, ?)', 'NEWSPAPER', 'ROOM TYPE', 'ROOM FEATURE') }

  scope :with_feature_type, proc { |value| includes(:feature_type).where('feature_types.value = ?', value) }

  def is_delete_allowed?
    rooms.empty? && guest_details.empty? && reservations.empty?
  end
end
