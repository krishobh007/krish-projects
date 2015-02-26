class FeatureType < ActiveRecord::Base
  attr_accessible :hide_on_room_assignment, :hotel_id, :selection_type, :value, :is_system_features_only

  belongs_to :hotel
  has_many :features, inverse_of: :feature_type
  has_and_belongs_to_many :hotels, join_table: 'hotels_feature_types', association_foreign_key: 'hotel_id'

  # validates :value, uniqueness: { scope: [:hotel_id], case_sensitive: false }
  validates :value, :selection_type, presence: true

  validates :features, presence: { message: I18n.t(:invalid_options) }, if: :features_required?

  validate :feature_type_uniqueness

  scope :for_hotel_or_system, proc { |hotel_id| where('hotel_id = ? OR hotel_id is null', hotel_id) }
  def feature_type_uniqueness
    query = FeatureType.for_hotel_or_system(hotel_id).where('lower(value) = lower(?)', value)
    # Do not include the current rate type
    query = query.where('id != ?', id) if persisted?

    errors.add(:value, :uniqueness) if query.exists?
  end

  def has_options
    errors.add(:base, I18n.t(:no_options_error)) if features.blank?
  end

  def is_option?
    selection_type === 'radio' || selection_type === 'dropdown' || selection_type === 'checkbox'
  end

  def is_system_type?
    hotel_id == nil
  end

  def features_required?
    self.is_option? && !self.is_system_type?
  end
end
