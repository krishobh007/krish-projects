# This controller should be removed once we migrate rover to angular completely
# Also remove templates view folder and all other related codes
class TemplatesController < ApplicationController
  before_filter :check_session

  def reports
    @is_late_checkout_on = current_hotel.settings.late_checkout_is_on
    @late_checkout_count = current_hotel.reservations.is_late_checkout(current_hotel.active_business_date).count
    render layout: false
  end
end
