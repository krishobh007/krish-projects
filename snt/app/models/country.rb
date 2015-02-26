class Country < ActiveRecord::Base
  attr_accessible :name, :code

  validates :name, :code, presence: true, uniqueness: { case_sensitive: false }
end
