class UpsellAmount < ActiveRecord::Base
  attr_accessible :id, :level_from, :level_to, :amount, :hotel_id

  belongs_to :hotel
  validates :level_from, :level_to, :amount, :hotel_id, presence: true
  validates :level_from, uniqueness: { scope: [:level_to, :hotel_id] }
  validates :amount, numericality: true, allow_nil: true

  def as_json(opts = {})
    json = super(opts)
    Hash[*json.map { |k, v| [k, v.to_s || ''] }.flatten]
  end
end
