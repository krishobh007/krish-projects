class Api::UsersController < ApplicationController
  before_filter :check_session
  before_filter :check_business_date
  respond_to :json

  # List the reports
  def active
    @users = current_hotel.users.active.with_staff_role.includes(:staff_detail).order(:first_name, :last_name)
    if params[:journal] == "true"
      @users << User.new({department_id: nil})
    end
  end

   def current_user_hotels
    result = {}
    result[:current_hotel_id] = current_hotel.id
    result[:hotel_list] = []
    current_user.hotels.each do |hotel|
            result[:hotel_list] << {
                            hotel_id: hotel.id,
                            hotel_name: hotel.name
                          }
    end
    render json: result
  end

end
