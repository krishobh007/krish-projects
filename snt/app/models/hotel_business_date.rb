class HotelBusinessDate < ActiveRecord::Base
  attr_accessible :business_date, :hotel_id, :status

  STATUSES = %w(OPEN CLOSED)

  belongs_to :hotel

  validates :business_date, :hotel_id, :status, presence: true
  validates :business_date, uniqueness: { scope: :hotel_id }
  validates :status, inclusion: { in: STATUSES }

  scope :is_open, -> { where(status: 'OPEN') }
  scope :is_closed, -> { where(status: 'CLOSED') }

  # Find all open business dates for hotels that are not equal to the current date in the hotel's time zone
  def self.outdated
    HotelBusinessDate.is_open.select do |hotel_business_date|
      Time.zone = hotel_business_date.hotel.tz_info
      hotel_business_date.business_date != Date.parse(Time.zone.now.to_s)
    end
  end
end
