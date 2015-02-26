class Admin::DashboardController < ApplicationController
  layout 'admin-dynamic'
  before_filter :check_session
  def index
      unless current_user.admin?
        fail 'Access Denied'
      end
      hotel_admin_menu = AdminMenu.get_menu_hash(current_user, current_hotel = nil)
    # @hotel_admin_menu = json2hash("hotel_admin/hotel_admin_menus.json")
      render locals: { data: hotel_admin_menu, errors: [] }
  end
end
