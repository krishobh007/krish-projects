class Api::HotelsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date

  # Returns a hash of the hotel's statistic information
  def hotel_statistics
     #begin
      if current_user.admin?
        fail 'Access denied. No hotel selected'
      end

      @hotel = params[:hotel_code].present? ? Hotel.find_by_code(params[:hotel_code]) : current_hotel

      unless @hotel
        fail 'Hotel name of current user not found in the database'
      end

      business_date = @hotel.active_business_date
      @is_upsell_on = current_hotel.settings.upsell_is_on
      vip_checkin_count = business_date ? @hotel.vip_checkin_count(business_date) : nil
      guest_review_score = business_date ? @hotel.average_review_score(business_date) : nil
      data = {
              due_in_count: Reservation.due_in_list(@hotel.id).count,
              due_out_count: Reservation.due_out_list(@hotel.id).count,
              inhouse_count: Reservation.inhouse_list(@hotel.id).count,
              vip_checkin_count: vip_checkin_count,
              guest_review_score: guest_review_score
            }
      if @is_upsell_on
        actual_upsell = business_date ? @hotel.total_upsell_revenue(business_date) : nil
        rooms_upsold = business_date ? @hotel.total_upsell_rooms_sold(business_date) : nil
        data = data.merge(
          upsell_target: current_hotel.settings.upsell_total_target_amount,
          rooms_for_upsell: current_hotel.settings.upsell_total_target_rooms,
          actual_upsell: actual_upsell,
          rooms_upsold: rooms_upsold
        )
      end

      respond_to do |format|
        format.json { render json: {
            status: SUCCESS,
            data: data
          }
        }
      end
    #rescue Exception => ex
    #  render text: ex.message, status: :not_found
    #end
  end

  def rover_header_info
    @hotel = params[:hotel_code].present? ? Hotel.find_by_code(params[:hotel_code]) : current_hotel
    @is_late_checkout_on = @hotel.settings.late_checkout_is_on
    business_date = @hotel.active_business_date
    @late_checkout_count = @hotel.reservations.is_late_checkout(business_date).count if @is_late_checkout_on
    @is_queue_rooms_on = @hotel.settings.is_queue_rooms_on
    @queued_rooms_count = @hotel.reservations.queued(business_date).count if @is_queue_rooms_on
    render json: {
      status: SUCCESS,
      data: {
        first_name: current_user.detail.first_name,
        last_name: current_user.detail.last_name,
        business_date: business_date,
        is_pms_configured: @hotel.pms_type.present?,
        late_checkout_count: @late_checkout_count,
        queue_rooms_count: @queued_rooms_count,
        logo: @hotel.andand.icon.andand.url,
        currency_code: @hotel.default_currency.andand.symbol,
        user_role: current_user.roles.first.name.titleize,
        is_staff: current_user.hotel_staff?
        },
      errors: []
    }
  end


  def get_black_listed_emails
    
  end

  def save_blacklisted_emails
    @email = current_hotel.black_listed_emails.create!(email: params[:email])
  rescue ActiveRecord::RecordInvalid => ex
    render(json: [ex.message], status: :unprocessable_entity)
  end


  def delete_email
    current_hotel.black_listed_emails.find(params[:id]).delete
  end


end
