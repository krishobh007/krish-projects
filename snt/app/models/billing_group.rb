class BillingGroup < ActiveRecord::Base
  attr_accessible :name, :description, :hotel_id

  belongs_to :hotel
  validates :name, presence: true
  validates_uniqueness_of :name, scope: [:hotel_id]
  has_and_belongs_to_many :charge_codes, join_table: 'charge_codes_billing_groups'

  validate :has_charge_codes?

  def has_charge_codes?
    self.errors.add :base, "At least one charge code should be selected." if self.charge_codes.blank?
  end
end
