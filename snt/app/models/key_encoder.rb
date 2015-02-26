class KeyEncoder < ActiveRecord::Base
  attr_accessible :hotel_id, :description, :enabled, :encoder_id, :location

  belongs_to :hotel

  validates :hotel, :description, :encoder_id, presence: true
  validates :description, :encoder_id, uniqueness: { scope: :hotel_id }

  scope :active, -> { where(enabled: true) }

  scope :search, lambda { |query|
    if query.present?
      sql = ['description', 'encoder_id', 'location'].map  { |column| "lower(#{column}) LIKE :query" }.join(' OR ')
      results = where(sql, query: "%#{query.downcase}%")
    end

    results
  }
end
