class HotelBrand < ActiveRecord::Base
  attr_accessible :icon_content_type, :icon_file_name, :icon_file_size, :name, :hotel_chain_id, :hotel_chain, :is_inactive
  belongs_to :hotel_chain

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :hotel_chain_id, presence: true

  # If hotel_brand deleted, the hotel_brand.is_inactive = true
  default_scope { where('is_inactive=false') }
end
