class CampaignsRecepient < ActiveRecord::Base
  attr_accessible :campaign_id, :guest_detail_id

  belongs_to :campaign
  belongs_to :guest_detail
end
