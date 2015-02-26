class ExternalMapping < ActiveRecord::Base
  attr_accessible :value, :external_value, :hotel_id, :mapping_type, :pms_type_id, :pms_type
  belongs_to :hotel

  has_enumerated :pms_type, class_name: 'Ref::PmsType'

  validates :mapping_type, :external_value, :value, :pms_type_id, presence: true
  validates :value, uniqueness: { scope: [:hotel_id, :mapping_type, :pms_type_id, :external_value], case_sensitive: false }

  after_save :rewrite_cache

  # After saving, delete the old cache values and write the inbound and outbound cache values
  def rewrite_cache
    Rails.cache.delete(inbound_cache_key_was)
    Rails.cache.delete(outbound_cache_key_was)

    Rails.cache.write(inbound_cache_key, value)
    Rails.cache.write(outbound_cache_key, external_value)
  end

  # After destroying, delete the inbound and outbound cache values
  after_destroy do |record|
    Rails.cache.delete(record.inbound_cache_key)
    Rails.cache.delete(record.outbound_cache_key)
  end

  # Only Choose the external_mappings record, if is_inactive = false
  default_scope { where('is_inactive = false') }

  scope :system_only, -> { where(hotel_id: nil) }

  # Maps an external system's value to SNT's internal system-level value
  def self.map_external_system_value(pms_type, external_value, mapping_type)
    # Find the first mapped value for the hotel, either from the cache or the db
    Rails.cache.fetch("ExternalMapping:inbound:system:#{mapping_type}:#{external_value}") do
      with_pms_type(pms_type).system_only.where(external_value: external_value, mapping_type: mapping_type).pluck(:value).first
    end
  end

  # Maps an external system's value to SNT's internal hotel-level value
  def self.map_external_value(hotel, external_value, mapping_type, keep_if_not_found = false)
    # Find the first mapped value for the hotel, either from the cache or the db
    mapped_value = Rails.cache.fetch("ExternalMapping:inbound:#{hotel.id}:#{mapping_type}:#{external_value}") do
      with_pms_type(hotel.pms_type).where(hotel_id: hotel.id, external_value: external_value, mapping_type: mapping_type).pluck(:value).first
    end

    # If neither the hotel or chain have a mapped value, use the external value
    mapped_value = external_value if keep_if_not_found && !mapped_value

    mapped_value
  end

  # Maps an external system's value to SNT's internal system-level value
  def self.map_system_value(pms_type, value, mapping_type)
    # Find the first mapped value for the hotel, either from the cache or the db
    Rails.cache.fetch("ExternalMapping:outbound:system:#{mapping_type}:#{value}") do
      with_pms_type(pms_type).system_only.where(value: value, mapping_type: mapping_type).pluck(:external_value).first
    end
  end

  # Maps an internal SNT value to an external system's hotel-value
  def self.map_value(hotel, value, mapping_type, keep_if_not_found = true)
    # Find the first mapped value for the hotel, either from the cache or the db
    mapped_value = Rails.cache.fetch("ExternalMapping:outbound:#{hotel.id}:#{mapping_type}:#{value}") do
      with_pms_type(hotel.pms_type).where(hotel_id: hotel.id, value: value, mapping_type: mapping_type).pluck(:external_value).first
    end
    logger.debug "**** -----   read cached value #{value} for hotel : #{hotel.code}  and pms_type : #{hotel.pms_type.value} ----- *****"
    logger.debug "**** -----   received mapping type  value #{mapping_type}  ----- *****"
    logger.debug "**** -----   received mapped  value #{mapped_value}  ----- *****"
    logger.debug "**** -----   hotel_id for mapped value is :  #{hotel.id}  ----- *****"
    # If neither the hotel or chain have a mapped value, use SNT's value
    mapped_value = value if keep_if_not_found && !mapped_value
    logger.debug "**** -----   mapped  value before returning  #{mapped_value}  ----- *****"
    mapped_value
  end

  def inbound_cache_key
    key = hotel_id || 'system'
    "ExternalMapping:inbound:#{key}:#{mapping_type}:#{external_value}"
  end

  def outbound_cache_key
    key = hotel_id || 'system'
    "ExternalMapping:outbound:#{key}:#{mapping_type}:#{value}"
  end

  def inbound_cache_key_was
    key = hotel_id || 'system'
    "ExternalMapping:inbound:#{key}:#{mapping_type_was}:#{external_value_was}"
  end

  def outbound_cache_key_was
    key = hotel_id || 'system'
    "ExternalMapping:outbound:#{key}:#{mapping_type_was}:#{value_was}"
  end
end
