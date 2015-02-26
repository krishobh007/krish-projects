class Api::RateSetsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  before_filter :retrieve, only: [:show, :update, :destroy]
  before_filter :retrieve_date_range, only: [:create]
  before_filter :update_day_false,  only: [:create]
  # Create a set
  def create
    RateSet.transaction do
      @set = @date_range.sets.create!(rate_set_params)
      params[:room_rates].each do |room_rate|
        room_rate[:single] = room_rate[:nightly_rate] if @set.rate_date_range.rate.is_hourly_rate?
        saved_room_rate = @set.room_rates.create!(room_type_id: room_rate[:id], single_amount: room_rate[:single], double_amount: room_rate[:double],
                                                  extra_adult_amount: room_rate[:extra_adult], child_amount: room_rate[:child], 
                                                  day_hourly_incr_amount: room_rate[:day_per_hour],
                                                  night_hourly_incr_amount: room_rate[:night_per_hour])
        # TODO This applicable to only for hourly
        
        saved_room_rate.hourly_room_rates.create!(format_hour_to_utc(room_rate[:hourly_room_rates])) if room_rate[:hourly_room_rates].present?
        saved_room_rate.create_based_on_room_rates!(format_hour_to_utc(room_rate[:hourly_room_rates])) if room_rate[:hourly_room_rates].present?
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    puts "message #{e.record.errors.full_messages}"
    render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

  # Show the rate set
  def show
  end

  # Update an existing set
  def update

    RateSet.transaction do
      @set.room_rates.each do |room_rate|
        room_rate.hourly_room_rates.destroy_all
      end
      @set.room_rates.destroy_all
      params[:room_rates].each do |room_rate|
        room_rate[:single] = room_rate[:nightly_rate] if @set.rate_date_range.rate.is_hourly_rate?
        saved_room_rate = @set.room_rates.create!(room_type_id: room_rate[:id], single_amount: room_rate[:single], double_amount: room_rate[:double],
                                                  extra_adult_amount: room_rate[:extra_adult], child_amount: room_rate[:child],
                                                  day_hourly_incr_amount: room_rate[:day_per_hour],
                                                  night_hourly_incr_amount: room_rate[:night_per_hour])
        # TODO This applicable to only for hourly

        saved_room_rate.hourly_room_rates.create!(format_hour_to_utc(room_rate[:hourly_room_rates]))  if room_rate[:hourly_room_rates].present?
        saved_room_rate.create_based_on_room_rates!(format_hour_to_utc(room_rate[:hourly_room_rates])) if room_rate[:hourly_room_rates].present?
      end

      @set.update_attributes!(rate_set_params)
    end
  rescue ActiveRecord::RecordInvalid => e
    render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

  # Destroys a set
  def destroy
    date_range = @set.rate_date_range

    # If the date range only has one set, destroy it as well. Otherwise just destroy the set.
    if date_range.sets.count == 1
      date_range.destroy || render(json: date_range.errors.full_messages, status: :unprocessable_entity)
    else
      @set.destroy || render(json: @set.errors.full_messages, status: :unprocessable_entity)
    end
  end

  private

  # Retrieve the selected set
  def retrieve
    @set = RateSet.find(params[:id])
    fail I18n.t(:access_denied) unless @set.rate_date_range.rate.accessible?(current_hotel)
  end

  def retrieve_date_range
    @date_range = RateDateRange.find(params[:rate_date_range_id])
    fail I18n.t(:access_denied) unless @date_range.rate.accessible?(current_hotel)
  end

  def rate_set_params
    {
      name: params[:name],
      sunday: params[:sunday],
      monday: params[:monday],
      tuesday: params[:tuesday],
      wednesday: params[:wednesday],
      thursday: params[:thursday],
      friday: params[:friday],
      saturday: params[:saturday],
      day_min_hours: params[:day_min_hours],
      day_max_hours: params[:day_max_hours],
      day_checkout_cut_off_time: params[:day_checkout_cutoff_time] ? getDatetime(params[:day_checkout_cutoff_time], current_hotel.tz_info) : nil,
      night_start_time: params[:night_start_time] ? getDatetime(params[:night_start_time], current_hotel.tz_info) : nil,
      night_end_time: params[:night_end_time] ? getDatetime(params[:night_end_time], current_hotel.tz_info) : nil,
      night_checkout_cut_off_time: params[:night_checkout_cutoff_time] ? getDatetime(params[:night_checkout_cutoff_time], current_hotel.tz_info) : nil
    }
  end
  # CICO-8566 - UI required to set the false parameter first to create the new set-Avoid validation
  def update_day_false
    update_attr = {}
    rate_set_params.each do |key, value|
      next if key == :name
      update_attr[key] = false if value
    end
    if @date_range
      @date_range.sets.update_all(update_attr) unless update_attr.empty?
    else
      @set.rate_date_range.update_all(update_attr)
    end
  end
  
  def format_hour_to_utc(hourly_room_rates)
    hourly_room_rates.map { |h_rate| 
      {
        :amount => h_rate[:amount],
        :hour => getDatetime('%2d:00' % h_rate[:hour].to_i, current_hotel.tz_info).utc.hour
      }
    }
  end
  
  def getDatetime(date_time, tz_info)
    ActiveSupport::TimeZone[tz_info].parse(date_time.to_s)
  end

end
