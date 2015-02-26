class Group < ActiveRecord::Base
  attr_accessible :hotel_id, :name, :group_code, :begin_date, :end_date, :rate_id, :company_id, :travel_agent_id
  belongs_to :hotel, counter_cache: true

  has_many :sb_posts, class_name: 'SbPost'
  has_many :reservation_daily_instances, class_name: 'ReservationDailyInstance'
  accepts_nested_attributes_for :hotel

  # validation
  validates :hotel_id, numericality: true
  validates :name, presence: true
  validates :group_code, presence: true, uniqueness: { scope: :hotel_id, case_sensitive: false }
  
end
