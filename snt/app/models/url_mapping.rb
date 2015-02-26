class UrlMapping < ActiveRecord::Base
  attr_accessible :url, :hotel_chain_id
  belongs_to :hotel_chain

  validates :url, uniqueness: { case_sensitive: false }, presence: true
end
