class Entity < ActiveRecord::Base
  attr_accessible :name, :display_name

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
