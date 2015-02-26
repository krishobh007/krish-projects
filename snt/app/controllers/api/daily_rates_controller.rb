class Api::DailyRatesController < ApplicationController
  before_filter :check_session
  before_filter :retrieve_paginated_dates, only: [:index, :show]
  after_filter :load_business_date_info
  before_filter :check_business_date
  # List rate details for each day in the query, including restriction information
  def index
    rate_type_ids = params[:rate_type_ids] || []
    rate_ids = params[:rate_ids] || []
    name_card_ids = params[:name_card_ids] || []

    @rates = current_hotel.rates.active.fully_configured.not_expired(params[:from_date])
             .not_fixed.order(:rate_name)

    restrictions = current_hotel.room_rate_restrictions.where('? <= date and date <= ?', @dates.first, @dates.last)

    if rate_ids.present?
      @rates = @rates.where(id: rate_ids)
      restrictions = restrictions.where(rate_id: rate_ids)
    elsif rate_type_ids.present?
      @rates = @rates.where(rate_type_id: rate_type_ids)
      @restrictions = restrictions.includes(:rate).where('rates.rate_type_id' => rate_type_ids)
    end

    @rates = @rates.where(account_id: name_card_ids) if name_card_ids.present?

    @rates = @rates.includes(:room_types).where('room_types.is_pseudo = false')
    @restrictions_hash = build_restrictions_hash(restrictions)
  end

  # Show the rate details
  def show
    @rate = Rate.find(params[:id])
  end

  # Create the rate details
  def create
    selected_rate = current_hotel.rates.find_by_id(params[:rate_id])
    selected_room_type = current_hotel.room_types.find_by_id(params[:room_type_id])

    params[:details].andand.each do |detail|
      fail I18n.t('daily_rates.date_range_required') if !detail.key?(:from_date) || !detail.key?(:to_date)

      from_date = Date.parse(detail[:from_date])
      to_date = Date.parse(detail[:to_date])

      # Get a list of rates for the hotel unless one is passed in
      rates = selected_rate ? [selected_rate] : current_hotel.rates.active.fully_configured.not_expired(detail[:from_date]).not_fixed
      (from_date..to_date).to_a.each do |date|
        if (detail.key?(:single) && detail.key?(:double) && detail.key?(:extra_adult) && detail.key?(:child)) || detail.key?(:nightly)
          room_rates(date, selected_rate, selected_room_type).each do |room_rate|
            # As per story CICO-9555, for nightly we will keep the value from nightly hash.
            detail[:single] = detail[:nightly] if rates.first.is_hourly_rate
            room_rate.apply_custom_rates!(date, detail[:single], detail[:double], detail[:extra_adult], detail[:child])
          end
        end

        rates.each do |rate|
          room_types = selected_room_type ? [selected_room_type] : rate.room_types.is_not_pseudo

          room_types.each do |room_type|
            apply_restrictions!(date, rate, room_type, detail[:restrictions])
          end
        end
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

  private

  # Obtains paginated dates
  def retrieve_paginated_dates
    fail I18n.t('daily_rates.date_range_required') if !params.key?(:from_date) || !params.key?(:to_date)

    from_date_orig = Date.parse(params[:from_date])
    to_date_orig = Date.parse(params[:to_date])
    @dates = Kaminari.paginate_array((from_date_orig..to_date_orig).to_a).page(params[:page]).per(params[:per_page])
  end

  # Obtain the room rates for the provided room type, rate, or house parameters
  def room_rates(date, rate, room_type)
    if rate
      if room_type
        # ROOM TYPE LEVEL
        rate.room_rates.for_date_and_room_type(date, room_type)
      else
        # RATE LEVEL
        rate.room_rates.for_date(date)
      end
    else
      # HOUSE LEVEL
      current_hotel.room_rates.for_date(date)
    end
  end

  # Apply restrictions
  def apply_restrictions!(date, rate, room_type, restriction_details)
    restriction_details.andand.each do |restriction_detail|
      # Ignore if the restriction is already at the rate level
      unless rate.rate_restrictions.with_type(restriction_detail[:restriction_type_id]).exists?
        adding = restriction_detail[:action] == 'add'

        # Find an existing restriction, if one exists
        restriction = RoomRateRestriction.where(date: date, room_type_id: room_type.id, rate_id: rate.id,
                                                type_id: restriction_detail[:restriction_type_id]).first

        if restriction
          if adding
            # Update the existing restriction
            restriction.update_attributes!(days: restriction_detail[:days])
          else
            # Delete the existing restriction
            restriction.destroy
          end
        else
          if adding
            # Create the restriction
            rate.room_rate_restrictions.create!(hotel_id: current_hotel.id, date: date, room_type_id: room_type.id,
                                                type_id: restriction_detail[:restriction_type_id], days: restriction_detail[:days])
          end
        end
      end
    end
  end

  # Construct the hash with given restrictions based on date level, rate level and room type level.
  # All restrictions will manage in the build_restictions hash method.
  
  def build_restrictions_hash(restrictions)
    restrictions = restrictions.to_a.map(&:serializable_hash)

    hashed_restrictions = {}

    restrictions.each do |restriction|

      hashed_restrictions[restriction['date']] = {} unless hashed_restrictions.key?(restriction['date'])

      date_restrictions = hashed_restrictions[restriction['date']]

      date_restrictions[restriction['rate_id']] = {} unless date_restrictions.key?(restriction['rate_id'])

      rate_restrictions = date_restrictions[restriction['rate_id']]

      rate_restrictions[restriction['room_type_id']] = [] unless rate_restrictions.key?(restriction['room_type_id'])

      room_type_restrictions = rate_restrictions[restriction['room_type_id']]
      room_type_restrictions.append(restriction) # TODO: Check if we need to add relevant data only.
    end
    hashed_restrictions
  end
end
