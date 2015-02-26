class InventoryDetail < ActiveRecord::Base
  attr_accessible :hotel_id, :rate_id, :room_type_id, :date, :sold

  belongs_to :hotel
  belongs_to :rate
  belongs_to :room_type
  has_many :hourly_inventory_details
  validates :hotel, :rate, :room_type, :date, :sold, presence: true
  validates :sold, numericality: { :greater_than_or_equal_to => 0 }
  validates :hotel_id, uniqueness: { scope: [:rate_id, :room_type_id, :date] }

  scope :between_dates, ->(from_date, to_date) { where('? <= date and date <= ?', from_date, to_date) }
  
  def self.record!(rate_id, room_type_id, hotel_id, day, increment = true)
    hotel = Hotel.find(hotel_id)
    unless hotel.is_third_party_pms_configured?
      inventory = self.find_by_rate_id_and_room_type_id_and_hotel_id_and_date(rate_id, room_type_id, hotel_id, day) if rate_id.present? && room_type_id.present?
      if inventory.present?
        sold = inventory.sold
        increment ? inventory.update_attributes(sold: sold+1) : inventory.update_attributes(sold: sold-1)
      else
        self.create!(rate_id: rate_id, room_type_id: room_type_id, hotel_id: hotel_id, date: day, sold: 1) if increment
      end
    else
      logger.debug "Inventory count updated only for standalone hotels"
    end
  end
  
  
end
