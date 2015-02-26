class Item < ActiveRecord::Base
  attr_accessible :charge_code_id, :description, :hotel_id, :unit_price, :is_favorite

  belongs_to :hotel
  belongs_to :charge_code
  has_many :financial_transactions

  has_one :image, class_name: 'Image', as: :image_attachable

  validates :charge_code_id, :unit_price, :description, :hotel_id, presence: true
  validates :description, uniqueness: { scope: :hotel_id, case_sensitive: false }
  validates :unit_price, numericality: true

  before_validation :default_values

  def default_values
    self.unit_price ||= 0
  end
end
