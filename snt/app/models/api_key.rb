class ApiKey < ActiveRecord::Base
  attr_accessible :email, :api_key, :expiry_date

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: /^([^@\s]+)@((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})$/i }

  validates :expiry_date, presence: true

  validate :validate_expiry_date_cannot_be_in_the_past

  after_save :expire_all_cached_api_keys
  after_destroy :expire_all_cached_api_keys

  def validate_expiry_date_cannot_be_in_the_past
    require 'time'
    errors.add(:expiry_date, 'should be greater than current date') if !expiry_date.blank? && Time.now > expiry_date
  end

  def self.all_cached
    Rails.cache.fetch('ApiKey.all') { all }
  end

  def self.find_by_cached_key(api_key)
    Rails.cache.fetch(api_key) do
      key = find_by_key(api_key)
      key.expiry_date if key
    end
  end

  def expire_all_cached_api_keys
    Rails.cache.delete('ApiKey.all')
  end
end
