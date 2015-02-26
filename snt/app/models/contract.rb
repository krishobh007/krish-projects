class Contract < ActiveRecord::Base
  attr_accessible :rate_id, :account_id, :contract_name, :begin_date,  :end_date,
                  :is_fixed_rate, :is_rate_shown_on_guest_bill, :based_on_type,
                  :based_on_value, :based_on_rate_id

  belongs_to :account
  belongs_to :rate
  has_many :contract_nights

  validates :contract_name, uniqueness: { scope: :account_id }
  validates :contract_name, presence: true
  
  scope :current, proc { |business_date| where('begin_date <= ? AND end_date >= ?', business_date, business_date) }
  scope :future, proc { |business_date| where('begin_date > ?', business_date) }
  scope :history, proc { |business_date| where('end_date < ?', business_date) }
end
