class Admin::HotelAdminDashboardController < ApplicationController

  layout 'admin-dynamic'
  before_filter :check_session, :assert_hotel_admin

  def dashboard
    if current_user.is_housekeeping_only
      redirect_to staff_house_keeping_dashboard_url
      return
    end
    # Get all hotel-admin menus
    data = AdminMenu.get_menu_hash(current_user, current_hotel)

    # For Hotel Admin- List the loggedin user associated hotels list
    hotel_list = {}

    if current_hotel
      hotel_list['current_hotel'] = current_hotel.name
      hotel_list['current_hotel_id'] = current_hotel.id.to_s
    end
    hotel_list['hotel_list'] = current_user.hotels.select('hotel_id as hotel_id, name as hotel_name')
    render locals: { status: SUCCESS, data: data, hotel_list: hotel_list, errors: [] }
  end

  # Seting up the current_hotel, when change the hotel from hotel_admin screen.
  def update_current_hotel
    hotel_id = params[:hotel_id]
    errors = []
    if params[:hotel_id]
      hotel = Hotel.find(hotel_id)

      # calling the current_hotel method
      self.current_hotel = hotel if hotel
      session[:business_date] = hotel.active_business_date
      
      # CICO-9094 - Update user logged in timeout. 
      current_user.class.logged_in_timeout = hotel.get_auto_logout_delay
      
      status = SUCCESS
    else
      status = FAILURE
      errors << I18n.t(:invalid_parameters, attribute: '')
    end
    render json: { status: status, data: current_hotel.name, errors: [''] }
  end
end
