class RateType < ActiveRecord::Base
  CONSORTIA = 'Consortia Rates'
  CORPORATE = 'Corporate Rates'
  GOVERNMENT = 'Government Rates'
  PACKAGE = 'Package Rates'
  PROMOTION = 'Specials & Promotions'
  GROUP = 'Group Rates'

  attr_accessible :hotel_id, :name

  belongs_to :hotel
  has_many :rates

  validates :name, presence: true
  validate :name_uniqueness

  before_destroy :validate_not_in_use

  def name_uniqueness
    query = RateType.for_hotel_or_system(hotel_id).where('lower(name) = lower(?)', name)

    # Do not include the current rate type
    query = query.where('id != ?', id) if persisted?

    errors.add(:name, :uniqueness) if query.exists?
  end

  scope :system_specific, -> { where('hotel_id IS NULL') }
  scope :for_hotel_or_system, ->(hotel_id) { where('hotel_id = ? OR hotel_id is null', hotel_id) }

  scope :linkable, -> { where('rate_types.name not in (?)', [PROMOTION]) }
  scope :copyable, -> { where(name: [PROMOTION]) }
  scope :government_or_corporate, -> { where(name: [GOVERNMENT, CORPORATE]) }

  scope :include_public_only, -> { where('rate_types.name not in (?)', [GOVERNMENT, GROUP, CONSORTIA, CORPORATE]) }

  def system_defined?
    hotel_id.nil?
  end

  # Validates that the rate type is not in use before destroying
  def validate_not_in_use
    if rates.count > 0
      errors.add(:base, I18n.t(:destroy_unallowed))
      return false
    end
  end

  def government?
    name == GOVERNMENT
  end

  def consortia?
    name == CONSORTIA
  end

  def corporate?
    name == CORPORATE
  end

  def promotion?
    name == PROMOTION
  end

  def linked?
    name != PROMOTION
  end

  def copied?
    name == PROMOTION
  end
end
