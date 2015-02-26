class HotelsRole < ActiveRecord::Base
  attr_accessible :hotel_id, :role_id, :default_dashboard_id, :is_active
  belongs_to :role
  belongs_to :hotel
  has_enumerated :default_dashboard, class_name: 'Ref::Dashboard'
  validates :default_dashboard_id, presence: true
end