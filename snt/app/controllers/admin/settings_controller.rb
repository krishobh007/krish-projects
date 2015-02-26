class Admin::SettingsController < ApplicationController

  layout false
  before_filter :check_session

 #   *****     Method to render the settings page base view    *****   #
 def settings
    data = {}
    data[:admin_role] = current_user.hotel_admin? ? "hotel-admin" : "snt-admin"
    data[:hotel_id] = current_hotel.id if current_user.hotel_admin?
    data[:is_pms_configured] =  current_hotel.pms_type.present? if current_user.hotel_admin?
    render :locals => { :status => SUCCESS, :data => data, :errors => [] }
  end

 #  *****     Method to render the settings menu items    *****   #
  def menu_items
      data = AdminMenu.get_menu_hash(current_user, current_hotel)
      data["hotel_list"] = current_user.hotels.where("hotel_id != ? ",current_hotel.id).select("hotel_id as hotel_id, name as hotel_name") if current_user.hotel_admin?
      data["current_hotel"] = current_hotel.name if current_user.hotel_admin?
      respond_to do |format|
        format.html
        format.json { render json: { :status => SUCCESS, :data => data, :errors => [] } }
      end
  end


end