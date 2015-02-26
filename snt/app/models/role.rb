class Role < ActiveRecord::Base
  attr_accessible :name, :hotel_id, :default_dashboard

  has_many :role_permissions, class_name: 'RolePermission'
  has_many :permissions, through: :role_permissions
  has_many :entities, through: :role_permissions
  has_and_belongs_to_many :users, join_table: 'users_roles'
  has_many :hotels, through: :hotels_roles
  has_many :hotels_roles

  validates :name, uniqueness: { scope: :hotel_id, case_sensitive: false }

  # get system-specific admin role
  def self.admin
    Role.where(name: 'admin', hotel_id: nil).first
  end

  # get system-specific hotel_admin role
  def self.hotel_admin
    Role.where(name: 'hotel_admin', hotel_id: nil).first
  end

  # get system-specific front_office_staff role
  def self.front_office_staff
    Role.where(name: 'front_office_staff', hotel_id: nil).first
  end

  # get system-specific floor_&_maintenance_staff role
  def self.floor_and_maintenance_staff
    Role.where(name: 'floor_&_maintenance_staff', hotel_id: nil).first
  end

  # get system-specific floor_&_maintenance_manager role
  def self.floor_and_maintenance_manager
    Role.where(name: 'floor_&_maintenance_manager', hotel_id: nil).first
  end

  # get system-specific reservation_staff role
  def self.reservation_staff
    Role.where(name: 'reservation_staff', hotel_id: nil).first
  end

   # get system-specific reservation_staff role
  def self.accounting_staff
    Role.where(name: 'accounting_staff', hotel_id: nil).first
  end

  # get system-specific manager role
  def self.manager
    Role.where(name: 'manager', hotel_id: nil).first
  end

  # get system-specific guest role
  def self.guest
    Role.where(name: 'guest', hotel_id: nil).first
  end

  # get system-specific guest role
  def self.api_user
    Role.where(name: 'api_user', hotel_id: nil).first
  end

  def self.revenue_manager
    Role.where(name: 'revenue_manager', hotel_id: nil).first
  end

  def default_dashboard(hotel_id)
    self.hotels_roles.find_by_hotel_id(hotel_id).andand.default_dashboard
  end
end
