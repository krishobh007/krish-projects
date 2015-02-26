class ChargeGroup < ActiveRecord::Base
  attr_accessible :charge_group, :description, :hotel_id

  has_and_belongs_to_many :charge_codes, join_table: 'charge_groups_codes'
  belongs_to :hotel

  has_many :addons

  validates :charge_group, presence: true, uniqueness: { scope: [:hotel_id], case_sensitive: false }
end
