class Api::AvailabilityController < ApplicationController
  before_filter :check_session
  before_filter :retrieve_paginated_dates, only: [:index, :house]
  after_filter :load_business_date_info
  before_filter :check_business_date

  # Lists the hotel's availability details for the room type, rate, or house level between the date range
  def index
    @room_types = current_hotel.room_types.is_not_pseudo
    # include_public_only is an additonal scope added
    # Logic - This will exclude the Rate TYPE from all Reservations screen [GOVERNMENT, GROUP,  CONSORTIA,CORPORATE]
    # This is hardcoded scope for now, future sprint will handle dynamic request parameters
    # List only Fully Configured Rate in Reservation Search screen - See 5218
    @rates = current_hotel.rates.active.nightly.fully_configured.include_public_only.not_expired(params[:to_date]).non_contract
    # List of Out of Order/Out Of Service Rooms
    @out_of_order_rooms = current_hotel.rooms.exclude_pseudo.with_hk_status(:OO).count
    if params[:room_type_id].present?
      @room_types = @room_types.where(id: params[:room_type_id])
      @rates = @rates.where(id: params[:rate_id]) if params[:rate_id].present?
    end

    if params[:company_id]
      company = Account.find(params[:company_id])
      @rates += company.rates.current_between(@dates.first, @dates.last)
    end

    if params[:travel_agent_id]
      travel_agent = Account.find(params[:travel_agent_id])
      @rates += travel_agent.rates.current_between(@dates.first, @dates.last)
    end

    @room_type_room_count = current_hotel.rooms.exclude_pseudo.group(:room_type_id).count

    options = { rates: @rates, room_types: @room_types, override_restrictions: params[:override_restrictions] == 'true',
                room_type_room_count: @room_type_room_count }

    @availability = Availability.new(current_hotel, @dates, options).data

    @tax_codes = current_hotel.charge_codes.where(charge_code_type_id: Ref::ChargeCodeType[:TAX].id)
    @upsell_room_levels = UpsellRoomLevel.where(room_type_id: @room_types.map(&:id))
  end

  # Lists the hotel's availability details for the house level between the date range
  def house
    options = { override_restrictions: params[:override_restrictions] == 'true' }
    @availability = Availability.new(current_hotel, @dates, options).data
  end

  private

  # Obtains paginated dates
  def retrieve_paginated_dates
    fail I18n.t('availability.date_range_required') if !params.key?(:from_date) || !params.key?(:to_date)

    from_date_orig = Date.parse(params[:from_date])
    to_date_orig = Date.parse(params[:to_date])
    # Setting Per page count since Kaminari returns only maximum of 25 counts
    unless params[:per_page].present?
      params[:per_page] = (to_date_orig - from_date_orig).to_i + 1  
    end
    @dates = Kaminari.paginate_array((from_date_orig..to_date_orig).to_a).page(params[:page]).per(params[:per_page])
  end
end
