class PreCheckinExcludedBlockCode < ActiveRecord::Base
  attr_accessible :group_id
  belongs_to :hotel
end
