class ContractNight < ActiveRecord::Base
  attr_accessible :rate_id, :month_year, :no_of_nights
  belongs_to :rate

  validates :rate, :month_year, presence: true
  validates :no_of_nights, format: { with: /^[0-9]+$/ } , allow_blank: true
end
