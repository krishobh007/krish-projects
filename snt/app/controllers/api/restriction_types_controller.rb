class Api::RestrictionTypesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  # List addons for the hotel
  def index
    @restriction_types = Ref::RestrictionType.page(params[:page]).per(params[:per_page])
  end

  # Activates or deactivates an addon for a hotel
  def activate
    restriction_type = Ref::RestrictionType.find(params[:id])
    currently_assigned = restriction_type.activated?(current_hotel)
    if params[:status]
      current_hotel.restriction_types << restriction_type unless currently_assigned
    else
      if currently_assigned
        # Deactivate the restriction type for the hotel(Rate Restrictions)
        current_hotel.rate_restrictions.with_type(restriction_type).destroy_all

        # Deactivate the restriction type for the hotel(Room Rate Restrictions)
        current_hotel.room_rate_restrictions.with_type(restriction_type).destroy_all
        
        current_hotel.restriction_types.destroy(restriction_type)
        
      end
    end
  end
end
