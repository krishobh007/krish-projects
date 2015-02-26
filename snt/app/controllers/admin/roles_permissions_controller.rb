class Admin::RolesPermissionsController < ApplicationController
  before_filter :check_session

  layout 'admin'
  def index
    @roles = current_hotel.roles.where('roles.name <> "admin"')
    data = {}
    data[:permissions] = Permission.all.map do |permission|
      {
        value: permission.id.to_s,
        name: permission.name
      }
    end
    data[:roles] = @roles.map do |role|
      {
        value: role.id.to_s,
        name: role.name.titleize,
        is_hoteladmin: role.name == 'hotel_admin',
        assigned_permissions: role.permissions.pluck(:id).map(&:to_s)
      }
    end
    respond_to do |format|
      format.html { render partial: 'permission', locals: { data: data,  errors: [] } }
      format.json { render json: data  }
    end
  end

  def save_permissions
    @role = Role.find(params[:value])
    if params[:permissions]
      @role.permissions.delete_all
      @role.permissions << Permission.where('id in (?)', params[:permissions].to_a)
      status, errors = SUCCESS, []
    else
      status, errors = FAILURE, ['Invalid parameters']
    end
    unless @role
      status, errors = FAILURE, ['Role not found']
    end
    respond_to do |format|
      format.json { render json: { status: status, data: {}, errors: errors }  }
    end
  end

  def add_permission
    params[:permissions] = params[:permissions].split(',')

    for permission in params[:permissions] do
      @role_permission = RolePermission.new
      @role_permission.permission_id = permission
      @role_permission.role_id = params[:role_id]
      if current_user.hotel_admin?
        @role_permission.hotel_id = current_user.hotel.id
      end
      @role_permission.save
    end

    render json: { success: 'Added Permissions for Role' }
  end

  def remove_permission
    params[:permissions] = params[:permissions].split(',')

    for permission in params[:permissions] do
      @role_permission = RolePermission.find_by_role_id_and_permission_id(params[:role_id],  permission)
      @role_permission.destroy
    end

    render json: { success: 'Removed Permission for Role' }
  end

  def get_permissions
    @roles_permissions = RolePermission.where(role_id: params[:role_id])
    render json: @roles_permissions
  end
end
