class Permission < ActiveRecord::Base
  attr_accessible :name

  has_many :role_permissions, class_name: 'RolePermission'
  has_many :roles, through: :role_permissions

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
