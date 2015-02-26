class RolePermission < ActiveRecord::Base
  self.table_name = 'roles_permissions'

  attr_accessible :entity_id, :permission_id, :role_id, :value
  validates :role_id, uniqueness: { scope: :permission_id }
  belongs_to :entity
  belongs_to :permission
  belongs_to :role
end
