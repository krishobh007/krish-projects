class RatesAddon < ActiveRecord::Base
  attr_accessible :rate_id, :addon_id,  :is_inclusive_in_rate
  belongs_to :addon
  belongs_to :rate
  #validates :rate, :addon, presence: true
end
