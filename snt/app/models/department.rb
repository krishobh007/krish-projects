class Department < ActiveRecord::Base
  attr_accessible :description, :name, :hotel_id

  validates :name, :hotel_id, presence: true
  validates :name, uniqueness: { scope: :hotel_id, case_sensitive: false }

  belongs_to :hotel

  has_many :users
end
