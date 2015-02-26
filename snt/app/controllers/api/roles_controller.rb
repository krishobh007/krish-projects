class Api::RolesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  # GET /roles
  # GET /roles.json
  def index
    # As per the Gops comment, we should not check the connected hotels check.
    # If hotel is defined pms_type, treated as conected else list all roles.
    if current_hotel && current_hotel.pms_type
      # CICO-9840 - Limiting roles to 3
      @roles = Role.where(name: ['front_office_staff', 'floor_&_maintenance_staff', 'hotel_admin'])
                   .group(:name)
    else
      @roles = Role.where('name <> "admin" && name <> "guest" && name <> "api_user"') # roles are system specific as per Phase 1 (Sprint 15)
    end
  end

  # PUT /roles
  def update
    @hotel_role = current_hotel.hotels_roles.find_or_initialize_by_role_id(params[:id])
    @hotel_role.default_dashboard_id = Ref::Dashboard.find(params[:dashboard_id]).id if params[:dashboard_id]
    @hotel_role.save || render(json: @hotel_role.errors.full_messages, status: :unprocessable_entity)
  end
end
