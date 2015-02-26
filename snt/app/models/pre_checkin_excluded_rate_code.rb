class PreCheckinExcludedRateCode < ActiveRecord::Base
  attr_accessible :rate_id
  belongs_to :hotel
end
