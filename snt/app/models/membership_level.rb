class MembershipLevel < ActiveRecord::Base
  attr_accessible :membership_type_id, :membership_type, :membership_level, :is_inactive, :description

  has_many :guest_memberships
  has_one :membership_type, as: :property

  validates :membership_level, uniqueness: { scope: [:membership_type_id], case_sensitive: false }
  validates :membership_level, :membership_type_id, presence: true
end
