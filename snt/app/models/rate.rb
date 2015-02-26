class Rate < ActiveRecord::Base
  BASED_ON_TYPES = %w(amount percent)

  attr_accessible :hotel_id, :rate_desc, :parent_rate_id, :market_code, :currency_code_id, :currency_code, :external_id, :rate_name,
  :rate_code, :is_active, :based_on_rate_id, :based_on_type, :based_on_value, :rate_type_id, :begin_date, :promotion_code,
  :charge_code_id, :end_date, :market_segment_id, :source_id, :is_commission_on, :is_suppress_rate_on,
  :is_discount_allowed_on, :deposit_policy_id, :account_id, :is_fixed_rate, :is_rate_shown_on_guest_bill, :cancellation_policy_id,
  :use_rate_levels, :hotel, :is_hourly_rate
  attr_accessor :room_types_required

  belongs_to :hotel
  belongs_to :account
  belongs_to :rate_type
  belongs_to :based_on_rate, class_name: 'Rate'
  has_enumerated :currency_code, class_name: 'Ref::CurrencyCode'

  has_many :rates_room_types, dependent: :destroy
  has_many :room_types, through: :rates_room_types

  has_many :date_ranges, class_name: 'RateDateRange', dependent: :destroy
  has_many :sets, through: :date_ranges, class_name: 'RateSet'
  has_many :room_rates, through: :sets

  has_many :reservation_daily_instances
  has_many :rates_addons, class_name: 'RatesAddon'
  has_many :addons, through: :rates_addons
  has_many :reservations, through: :reservation_daily_instances

  has_many :contract_nights

  belongs_to :market_segment
  belongs_to :source
  belongs_to :charge_code
  belongs_to :deposit_policy, foreign_key: 'deposit_policy_id', class_name: 'Policy'
  belongs_to :cancellation_policy, foreign_key: 'cancellation_policy_id', class_name: 'Policy'

  has_many :based_on_rates, class_name: 'Rate', foreign_key: 'based_on_rate_id'

  has_many :rate_restrictions
  has_many :room_rate_restrictions

  validates :hotel, :rate_name, :rate_desc, presence: true
  validates :charge_code_id, :currency_code, presence: true, unless: :external_pms?
  validates :rate_code, uniqueness: { scope: [:hotel_id, :account_id], case_sensitive: false }, if: :external_pms?

  validates :rate_name, uniqueness: { scope: [:hotel_id, :account_id], case_sensitive: false }, unless: :external_pms?
  validates :rate_type, presence: true, unless: :external_pms?
  validates :room_types, length: { minimum: 1 }, if: :room_types_required
  validates :based_on_rates, length: { is: 0 }, if: :based_on_rate_id

  validates :based_on_rate, :begin_date, :end_date, presence: true, if: :contracted?
  validates :based_on_value, allow_nil: true, numericality: { message: :allow_only_numbers }

  validate :not_based_on_self
  validate :based_on_details
  validate :validate_based_on_value_type, if: :based_on_details_required?
  validate :based_on_rate_not_parent


  before_validation :check_rate_code
  before_destroy :validate_not_in_use

  validate :parent_end_date, if: :contracted?

  # As per CICO-9481, Only one contract can be created for Hourly Rate.
  # Since on Diary Screen, we are listing only one Rate, which should be hourly.
  validate :no_overlaps, if: :based_on_rate_is_hourly?
   
    
  def check_rate_code
    self.rate_code = rate_name unless external_pms? && rate_code.present?
  end

  # Checks whether the external pms is defined for the hotel or not
  def external_pms?
    hotel.andand.pms_type.present?
  end

  # Validates whether based on value is provided with - sign
  def validate_based_on_value(rate_value)
    if rate_value.present? && (rate_value.to_i < 0)
      errors.add(:based_on_value, I18n.t(:invalid_rate_adjustment_amount))
    end
  end

  # Validates that the rate is not in use before destroying it
  def validate_not_in_use
    if reservation_daily_instances.count > 0 || based_on_rates.count > 0
      errors.add(:base, I18n.t(:destroy_unallowed))
      return false
    end
  end

  # Validate that the based on rate is not equal to itself
  def not_based_on_self
    errors.add(:based_on_rate_id, :self_reference) if based_on_rate_id == id && persisted?
  end

  #---------    Method to validate end date for contracts       -------#
  def parent_end_date
    if based_on_rate.present?
      if based_on_rate.end_date.present?
        errors.add(:end_date, I18n.t(:rate_ends_prior_to_contract, end_date: ApplicationController.helpers.formatted_date(based_on_rate.end_date)) ) if based_on_rate.end_date < end_date
      end
    end
  end

  # Validate that the based on details are correct, if a based on rate is selected
  def based_on_details
    if based_on_rate
      # Marks as invalid if any of the room types do not exist in the based on room type
      errors.add(:room_types, :not_subset) if (room_types - based_on_rate.room_types).present?
    end
  end

  def based_on_rate_not_parent
    errors.add(:based_on_rate_id, :already_parent) if based_on_rate && based_on_rate.based_on_rate
  end

  # Determines if the rate is accessible by the hotel
  def accessible?(current_hotel)
    hotel_id == current_hotel.id
  end

  # Determines if the rate is contracted
  def contracted?
    !external_pms? && account_id
  end

  def validate_based_on_value_type
    is_based_on_value_valid = based_on_value.present?  && based_on_type.present? && based_on_type.in?(BASED_ON_TYPES)
    errors.add(:based_on_value, :required) unless is_based_on_value_valid
  end

  def based_on_rate_is_hourly?
    based_on_rate && based_on_rate.is_hourly_rate
  end

  # Limit to active rates
  scope :active, -> { where(is_active: true) }
  scope :nightly, -> { where(is_hourly_rate: false) }
  scope :end_date_passed, lambda {|business_date| where('end_date IS NOT NULL AND end_date < ?', business_date)}
  scope :contracts_with_end_date_exceeding, lambda {|end_date| where('account_id IS NOT NULL AND end_date IS NOT NULL AND end_date > ?', end_date)}

  scope :contract_rates, lambda {
    joins(:rate_type).where('account_id IS NULL AND name in (?)', [Setting.contract_rate_types[:corporate_rates], Setting.contract_rate_types[:government_rates], Setting.contract_rate_types[:consortia_rates]]) }

    scope :non_contract, -> { where(account_id: nil).order('rates.is_active DESC') }
    scope :fixed, -> { where(is_fixed_rate: true) }
    scope :not_fixed, -> { where(is_fixed_rate: false) }

  # Gets all rates that are fully configured, meaning they have at least one room type and room rate
  scope :fully_configured, -> { has_room_types.has_room_rates }

  scope :has_room_types, lambda {
    where('(select count(*) from rates_room_types rrt, room_types rt where rrt.rate_id = rates.id and rrt.room_type_id = rt.id and ' \
      'rt.is_pseudo = false) > 0')
  }
  scope :has_room_rates, lambda {
    where('(select count(*) from room_rates, rate_sets, rate_date_ranges where room_rates.rate_set_id = rate_sets.id and
      rate_sets.rate_date_range_id = rate_date_ranges.id and rate_date_ranges.rate_id = rates.id) > 0')
  }

  scope :linked, -> { includes(:rate_type).merge(RateType.linkable) }
  scope :copied, -> { includes(:rate_type).merge(RateType.copyable) }

  # Join the based on rate
  scope :join_based_on, -> { joins('LEFT OUTER JOIN rates AS based_on_rates ON rates.based_on_rate_id = based_on_rates.id') }

  # Return rates that have room rates defined for the date
  scope :configured_on_date, ->(date) { includes(:room_rates).merge(RoomRate.for_date(date)) }

  # Search by rate name, based on rate name, or rate type name
  scope :search, lambda { |query|
    results = scoped

    if query.present?
      sql = ['rates.rate_name', 'based_on_rates.rate_name', 'rate_types.name'].map  { |column| "lower(#{column}) LIKE :query" }.join(' OR ')
      results = results.join_based_on.includes(:rate_type).where(sql, query: "%#{query.downcase}%")
    end

    results
  }

  # Sort by the selected field and direction
  scope :sort_by, lambda { |sort_field, sort_dir|
    sort_order = sort_dir != 'false' ? 'asc' : 'desc'

    results = scoped

    case sort_field
    when 'based_on'
      results = results.join_based_on.order("based_on_rates.rate_name #{sort_order}")
    when 'rate_type'
      results = results.includes(:rate_type).order("rate_types.name #{sort_order}")
    when 'status'
      results = results.order("rates.is_active #{sort_order}")
    end

    results.order("rates.rate_name #{sort_order}")
  }

  scope :current_between, proc { |from_date, to_date| where('begin_date <= ? AND end_date >= ?', from_date, to_date) }

  scope :current, proc { |business_date| where('begin_date <= ? AND end_date >= ?', business_date, business_date) }
  scope :future, proc { |business_date| where('begin_date > ?', business_date) }
  scope :history, proc { |business_date| where('end_date < ?', business_date) }

  scope :overlapping, lambda { |begin_date, end_date|
    where('(rates.begin_date <= :begin_date and rates.end_date >= :begin_date) or
     (rates.begin_date <= :end_date and rates.end_date >= :end_date) or
     (rates.begin_date >= :begin_date and rates.end_date <= :end_date) or
     (rates.begin_date is null and rates.end_date is null) or
     (rates.begin_date is null and rates.end_date >= :begin_date) or
     (rates.end_date is null and rates.begin_date <= :end_date)',
     begin_date: begin_date, end_date: end_date)
  }

  scope :not_expired, ->(date) { where('rates.end_date >= ? or rates.end_date is null', date) }

  scope :include_public_only, -> { includes(:rate_type).merge(RateType.include_public_only) }

  
  # For the date, room type, and occupancy type, get the rate amount, either from the room custom rates (rate manager) or the room rates (rate setup)
  def amounts(date, room_type)
    room_rates.for_date_and_room_type(date, room_type).first.andand.amounts(date)
  end

  

  def is_activation_allowed
   end_date.present? ? (end_date > self.hotel.active_business_date) : true
 end

 def calculate_rate_amount(date, room_type, adults, children)
  amount_hash = amounts(date, room_type)
  rate = nil

  if occupancy_counts_valid(adults, children, amount_hash)
    rate = amount_hash[:single_amount] if adults == 1
    rate = amount_hash[:double_amount] if adults >= 2
    rate += amount_hash[:extra_adult_amount] * (adults - 2) if adults > 2
    rate += amount_hash[:child_amount] * children if children > 0
  end

  rate
end

def occupancy_counts_valid(adults, children, amount_hash)
  amount_hash && ((amount_hash[:single_amount] && adults == 1) || (amount_hash[:double_amount] && adults >= 2)) &&
  (adults <= 2 || amount_hash[:extra_adult_amount]) && (children == 0 || amount_hash[:child_amount])
end

  # Determines if the based on type and value are required
  def based_on_details_required?
    based_on_rate && rate_type && (account_id || (!rate_type.government? && !rate_type.consortia? && !rate_type.corporate?))
  end

  # Copies the room types, date ranges, sets, and room rates from the based on rate
  def copy_based_on_rate!
    if based_on_rate
      # Cascade delete any existing room types, date ranges, sets, or room rates
      date_ranges.destroy_all
      room_types.destroy_all

      # Save the new rate
      save!

      self.room_types = based_on_rate.room_types
      hotel_business_date = hotel.active_business_date
      # Copy the date ranges
      # Condition -01 Ignore sets & date range if begin_date less than hotel_business_date
      # Conditon -02 if business date included in any date range, so the begin_date should be start with
      # hotel business date - See CICO-7844
      based_on_rate.date_ranges.each do |based_on_date_range|
        business_date_in_date_range = (based_on_date_range.begin_date .. based_on_date_range.end_date) === hotel_business_date
        valid_date =  based_on_date_range.begin_date >= hotel_business_date  || business_date_in_date_range
        if valid_date
          begin_date = business_date_in_date_range ? hotel_business_date : based_on_date_range.begin_date
          date_range = date_ranges.create!(begin_date: begin_date, end_date: based_on_date_range.end_date)

          # Copy the sets
          based_on_date_range.sets.each do |based_on_set|
            set = date_range.sets.create!(name: based_on_set.name, sunday: based_on_set.sunday, monday: based_on_set.monday,
                                          tuesday: based_on_set.tuesday, wednesday: based_on_set.wednesday, thursday: based_on_set.thursday,
                                          friday: based_on_set.friday, saturday: based_on_set.saturday,
                                          day_min_hours: based_on_set.day_min_hours, day_max_hours: based_on_set.day_max_hours,
                                          day_checkout_cut_off_time: based_on_set.day_checkout_cut_off_time,
                                          night_start_time: based_on_set.night_start_time, night_end_time: based_on_set.night_end_time,
                                          night_checkout_cut_off_time: based_on_set.night_checkout_cut_off_time)

            # Copy the room rates and calculate their based on amounts
            based_on_set.room_rates.each do |based_on_room_rate|
              single_amount = calculate_based_on_amount(based_on_room_rate.single_amount)
              double_amount = calculate_based_on_amount(based_on_room_rate.double_amount)
              extra_adult_amount = calculate_based_on_amount(based_on_room_rate.extra_adult_amount)
              child_amount = calculate_based_on_amount(based_on_room_rate.child_amount)
              day_hourly_incr_amount = based_on_room_rate.day_hourly_incr_amount
              night_hourly_incr_amount = based_on_room_rate.night_hourly_incr_amount
              new_room_rate = set.room_rates.create!(room_type_id: based_on_room_rate.room_type_id,
                                                     single_amount: single_amount, double_amount: double_amount,
                                                     extra_adult_amount: extra_adult_amount, child_amount: child_amount,
                                                     day_hourly_incr_amount: day_hourly_incr_amount,
                                                     night_hourly_incr_amount: night_hourly_incr_amount)
              based_on_room_rate.hourly_room_rates.each do |based_on_hourly_room_rate|
                new_room_rate.hourly_room_rates.create!(hour: based_on_hourly_room_rate.hour,
                                                        amount: based_on_hourly_room_rate.amount) if is_hourly_rate
              end
            end
          end
        end
      end
    end
  end

  def sync_based_on_room_rates!
    room_type_ids = room_types.pluck('room_types.id')

    based_on_rates.linked.each do |child_rate|
      child_rate.room_rates.without_room_types(room_type_ids).destroy_all
      child_rate.room_types = room_types
      child_rate.save!
    end
  end

  # Calculate the based on amount via the amount or percentage difference
  def calculate_based_on_amount(amount)
    new_amount = nil

    if amount && based_on_type && based_on_value
      if based_on_type == 'amount'
        new_amount = amount + based_on_value
      else
        new_amount = amount + amount * based_on_value / 100
      end

      new_amount = 0.0 if new_amount < 0
    end

    new_amount
  end

  # Adds or removes rate restrictions based on the the input parameters
  def update_rate_restrictions!(params)
    params.each do |key, value|
      type = key.upcase

      rate_restriction = rate_restrictions.with_type(type).first

      if value.present?
        # Add or update the rate restriction
        if rate_restriction
          rate_restriction.update_attributes!(days: value)
        else
          rate_restrictions.create!(hotel_id: hotel_id, type_id: Ref::RestrictionType[type].id, days: value)
        end

        # Remove all associated room rate restrictions
        room_rate_restrictions.with_type(type).destroy_all
      else
        # Remove the rate restriction
        rate_restrictions.with_type(type).destroy_all
      end
    end
  end

  # Minimum stay length restriction at rate level
  def min_stay_length
    rate_restrictions.with_type(:MIN_STAY_LENGTH).first.andand.days
  end

  # Maximum stay length restriction at rate level
  def max_stay_length
    rate_restrictions.with_type(:MAX_STAY_LENGTH).first.andand.days
  end

  # Minimum advanced booking restriction at rate level
  def min_advanced_booking
    rate_restrictions.with_type(:MIN_ADV_BOOKING).first.andand.days
  end

  # Maximum advanced booking restriction at rate level
  def max_advanced_booking
    rate_restrictions.with_type(:MAX_ADV_BOOKING).first.andand.days
  end

  def fetch_hourly_roomrates_data(date, room_type, begin_time)

    amount_hash = room_rates.for_date_and_room_type(date, room_type).joins(:hourly_room_rates)
    .select('single_amount, day_hourly_incr_amount, night_hourly_incr_amount,
    day_min_hours, day_max_hours,
    day_checkout_cut_off_time,
    night_start_time,
    night_end_time,
    night_checkout_cut_off_time,
    hour, amount').where('hour = ?',begin_time.strftime("%H")).first
    return amount_hash
  
  end
  
  def adjust_roomrates_data(date, room_type, begin_time, end_time, amount_hash)
    time_zone_converted_hash = {}
 
    day_checkout_cut_off_time = amount_hash.day_checkout_cut_off_time.in_time_zone(hotel.tz_info).andand.strftime("%H:%M") if (amount_hash.day_checkout_cut_off_time).present?  
    night_checkout_cut_off_time = amount_hash.night_checkout_cut_off_time.in_time_zone(hotel.tz_info).andand.strftime("%H:%M") if (amount_hash.night_checkout_cut_off_time).present?
    begin_time = begin_time.in_time_zone(hotel.tz_info)
    end_time = end_time.in_time_zone(hotel.tz_info)

    # As per Nicole comments on 9481  BEGIN
    
    night_start_datetime = nil
    night_end_datetime =  nil

    if amount_hash.night_start_time
      night_start_time = amount_hash.night_start_time.in_time_zone(hotel.tz_info).andand.strftime("%H:%M")
      night_start_datetime = begin_time.change({
      :hour => night_start_time.split(':')[0].to_i, 
      :min => night_start_time.split(':')[1].to_i
    })
    end  

    if amount_hash.night_end_time
      night_end_time = amount_hash.night_end_time.in_time_zone(hotel.tz_info).andand.strftime("%H:%M")
      night_end_datetime = begin_time.change({
      :hour => night_end_time.split(':')[0].to_i, 
      :min => night_end_time.split(':')[1].to_i
    })
    end

    # As per Nicole comments on 9481  END
   
    if amount_hash.day_checkout_cut_off_time
      day_cutt_off_datetime = begin_time.change({
        :hour => day_checkout_cut_off_time.split(':')[0].to_i, 
        :min => day_checkout_cut_off_time.split(':')[1].to_i
      })
      day_cutt_off_datetime = (day_cutt_off_datetime.hour < 12) ? (day_cutt_off_datetime + 24.hour) : day_cutt_off_datetime
    end
    
    if amount_hash.night_checkout_cut_off_time
      night_cutt_off_datetime = begin_time.change({
        :hour => night_checkout_cut_off_time.split(':')[0].to_i, 
        :min => night_checkout_cut_off_time.split(':')[1].to_i
      })
      night_cutt_off_datetime = (night_cutt_off_datetime.hour < 12) ? (night_cutt_off_datetime + 24.hour) : night_cutt_off_datetime
    end

    if (night_start_datetime && night_start_datetime.hour < 12)
     night_start_datetime += 24.hour
    end

    if (night_end_datetime && night_end_datetime.hour < 12)
      night_end_datetime += 24.hour
    end

    region_for_restriction = (0..(night_end_datetime.hour-0.1))
    
    if (region_for_restriction.include? begin_time.hour)
      altered_night_start_datetime = night_start_datetime - 1.day
      altered_night_end_datetime = night_end_datetime - 1.day
      altered_day_cutt_off_datetime = day_cutt_off_datetime - 1.day
      altered_night_cutt_off_datetime = night_cutt_off_datetime - 1.day
    end
    
    # check whether arrival date is less than night end time, then apply restriction for previous date
    if altered_night_end_datetime
      date = (date - 1.day) if (begin_time < altered_night_end_datetime)
    end
    
    single_amount = single_amount_for(date, room_type, amount_hash.single_amount)
    day_hourly_incr_amount = amount_hash.day_hourly_incr_amount
    night_hourly_incr_amount = amount_hash.night_hourly_incr_amount
    day_checkout_cut_off_time = altered_day_cutt_off_datetime ? altered_day_cutt_off_datetime : day_cutt_off_datetime
    night_checkout_cut_off_time = altered_night_cutt_off_datetime ? altered_night_cutt_off_datetime : night_cutt_off_datetime
    night_start_time = altered_night_start_datetime ? altered_night_start_datetime : night_start_datetime
    night_end_time = altered_night_end_datetime ? altered_night_end_datetime : night_end_datetime
    
    time_zone_converted_hash[:single_amount] = single_amount
    time_zone_converted_hash[:day_hourly_incr_amount] = day_hourly_incr_amount
    time_zone_converted_hash[:night_hourly_incr_amount] = night_hourly_incr_amount
    time_zone_converted_hash[:day_min_hours] = amount_hash.day_min_hours
    time_zone_converted_hash[:day_max_hours] = amount_hash.day_max_hours
    time_zone_converted_hash[:hour] = amount_hash.hour
    time_zone_converted_hash[:amount] = amount_hash.amount 
    time_zone_converted_hash[:day_checkout_cut_off_time] =day_checkout_cut_off_time
    time_zone_converted_hash[:night_checkout_cut_off_time] = night_checkout_cut_off_time
    time_zone_converted_hash[:night_start_time] = night_start_time
    time_zone_converted_hash[:night_end_time] = night_end_time
    return time_zone_converted_hash
  end
  
  
  # CICO-9555 Handle hourly rate calculation, taking into account the rate manager values. 
  # This will get the nightly rate either from the rate manager or from rate set up, if the date matches. 
  def single_amount_for(date, room_type, single_amount)
    # Check whether restriction is present in selected date for selected room type
    is_restricted = hourly_restriction_check(date, room_type)
    return -1 if is_restricted == true
    room_rates.for_date_and_room_type(date, room_type).first.andand.hourly_amount(date)
  end
  
  def hourly_restriction_check(date, room_type)
    is_restricted = false
    business_date = self.hotel.active_business_date
    applied_restrictions = self.room_rate_restrictions.where(date: date, room_type_id: room_type.id)
    applied_restriction_type_ids = applied_restrictions.pluck(:type_id)
    min_advance_booking_restriction = applied_restrictions.where(type_id: Ref::RestrictionType[:MIN_ADV_BOOKING].id).first
    max_advance_booking_restriction = applied_restrictions.where(type_id: Ref::RestrictionType[:MAX_ADV_BOOKING].id).first
    
    if (applied_restriction_type_ids.include?(Ref::RestrictionType[:CLOSED].id) || 
        applied_restriction_type_ids.include?(Ref::RestrictionType[:CLOSED_ARRIVAL].id) || 
        applied_restriction_type_ids.include?(Ref::RestrictionType[:CLOSED_DEPARTURE].id))
      is_restricted = true
    end
    
    # There will be case where min and max booking restriction days is null. We will be handling this by setting number of days to 0.
    min_restricted_days = min_advance_booking_restriction.andand.days ? min_advance_booking_restriction.andand.days : 0
    max_restricted_days = max_advance_booking_restriction.andand.days ? max_advance_booking_restriction.andand.days : 0
    
    if applied_restriction_type_ids.include?(Ref::RestrictionType[:MIN_ADV_BOOKING].id) && (date - business_date) < min_restricted_days
      is_restricted = true
    end 
    
    if applied_restriction_type_ids.include?(Ref::RestrictionType[:MAX_ADV_BOOKING].id) && (date - business_date) > max_restricted_days
      is_restricted = true
    end

    is_restricted
  end

  # Hourly Rate Calcuation Based on Rule Defined
  def calculate_hourly_rate_amount(date, room_type, begin_time, end_time)

    # Make sure that handle this calcuation only for hourly rate
    begin
      output_rate = 0
      amount_hash =  fetch_hourly_roomrates_data(date, room_type, begin_time)
      # Check if the configuration indicates only-daytime style. #CICO-9481
      if (amount_hash.night_start_time == nil || amount_hash.night_end_time == nil || amount_hash.night_start_time == amount_hash.night_end_time)
        begin_time = begin_time.in_time_zone(hotel.tz_info)
        end_time = end_time.in_time_zone(hotel.tz_info)
        single_amount = single_amount_for(date, room_type, amount_hash.single_amount)
        return -1 if single_amount == -1
        final_output_rate = day_rate_computation(begin_time, end_time, amount_hash)
        return final_output_rate
      end
      # To-do restriction. Cross check
      
      # There are complex time adjustments required
      amount_hash = adjust_roomrates_data(date, room_type, begin_time, end_time, amount_hash)
      begin_time = begin_time.in_time_zone(hotel.tz_info)
      end_time = end_time.in_time_zone(hotel.tz_info)

      single_amount = amount_hash[:single_amount]
      day_hourly_incr_amount = amount_hash[:day_hourly_incr_amount]
      night_hourly_incr_amount = amount_hash[:night_hourly_incr_amount]
      night_start_datetime = amount_hash[:night_start_time]
      night_end_datetime = amount_hash[:night_end_time]
      day_cutt_off_datetime = amount_hash[:day_checkout_cut_off_time]
      night_cutt_off_datetime = amount_hash[:night_checkout_cut_off_time]
      day_min_hours = (amount_hash[:day_min_hours]).to_f > 0 ? (amount_hash[:day_min_hours]).to_f : 1
      day_max_hours = amount_hash[:day_max_hours]
      amount = amount_hash[:amount]
      hour = amount_hash[:hour]

      # Handle optional cases
      day_hourly_incr_amount = night_hourly_incr_amount if day_hourly_incr_amount.nil?
      night_hourly_incr_amount = day_hourly_incr_amount if night_hourly_incr_amount.nil?
      night_cutt_off_datetime = night_end_datetime if night_cutt_off_datetime.nil?
      day_cutt_off_datetime = night_start_datetime if day_cutt_off_datetime.nil?

      nightly_component = has_nightly_component(begin_time, end_time, amount_hash)
      return -1 if single_amount == -1 && nightly_component
      nightly_charge = 0
      additional_hours = 0
      hours_after_night = 0
      # Check if nightly component is present inside the requested time slot, if not, get the day rate
      if (!nightly_component)
        final_output_rate = day_rate_computation(begin_time, end_time, amount_hash)
        return final_output_rate
      else
        begin
          hours_before_night = (night_start_datetime - begin_time)/3600
          hours_before_night = 0 if hours_before_night < 0
          nightly_charge += single_amount if end_time > day_cutt_off_datetime
          if end_time > night_cutt_off_datetime && end_time <= day_cutt_off_datetime+1.day
            hours_after_night = (end_time - night_cutt_off_datetime)/3600
          else
            begin_time = night_cutt_off_datetime
          end
          # As per CICO-11590 qa failure comments replacing night_end time with night_cuttoff_datetime
          hours_after_night = 0 if hours_after_night < 0
          additional_hours += hours_before_night + hours_after_night
          night_start_datetime += 1.day
          night_cutt_off_datetime += 1.day
          day_cutt_off_datetime += 1.day
        end while (end_time > day_cutt_off_datetime)

          output_rate = (single_amount == -1) ? 0 : nightly_charge + (additional_hours * night_hourly_incr_amount)
          # As per CICO-9481 - If contract rate we need to calculate based on value from the total rate
          final_output_rate = contracted? ? calculate_based_on_amount(output_rate) : output_rate

          return final_output_rate
      end

    #Exception handling, return -1
    rescue Exception => ex
      puts ex.message, ex.backtrace
    end
  end

  def has_nightly_component(begin_time, end_time, amount_hash)
    night_start_datetime = amount_hash[:night_start_time] 
    night_end_datetime = amount_hash[:night_end_time]
    day_cutt_off_datetime = amount_hash[:day_checkout_cut_off_time]
    return true if (begin_time >= night_start_datetime) && (begin_time < night_end_datetime)
    return true if (day_cutt_off_datetime && end_time > day_cutt_off_datetime)
    return false
  end

  def day_rate_computation(begin_time, end_time, amount_hash)
    day_min_hours = amount_hash[:day_min_hours] ? (amount_hash[:day_min_hours]).to_f : 1
    #TODO: Need to cross check 24 hour case. We can create multi day reservation.
    day_max_hours = amount_hash[:day_max_hours] ? (amount_hash[:day_max_hours]).to_f : 24
    day_hourly_incr_amount = amount_hash[:day_hourly_incr_amount] ? amount_hash[:day_hourly_incr_amount] : 0
    amount = amount_hash[:amount]

    duration = (end_time - begin_time)/3600
    if(duration > day_min_hours) && (duration < day_max_hours)
      additional_hours = duration - day_min_hours
    elsif(duration >= day_max_hours)
      additional_hours = day_max_hours - day_min_hours
    else
      additional_hours = 0
    end
    output_rate = amount + (additional_hours * day_hourly_incr_amount)

    # As per CICO-9481 - If contract rate we need to calculate based on value from the total rate
    final_output_rate = contracted? ? calculate_based_on_amount(output_rate) : output_rate
    return final_output_rate
  end

  def no_overlaps
    if based_on_rate
      overlapping_ranges = account.rates.overlapping(begin_date, end_date)
      overlapping_ranges = overlapping_ranges.where('id != ?', id) if persisted?
      errors[:base] << I18n.t(:rate_date_range_overlap) if overlapping_ranges.exists?
    end
  end

  def overlapping_contracted_rate(contract_begin_date, contract_end_date)
    if (self.begin_date <= contract_begin_date and self.end_date >= contract_begin_date) or
     (self.begin_date <= contract_end_date and self.end_date >= contract_end_date) or
     (self.begin_date >= contract_begin_date and self.end_date <= contract_end_date) or
     (self.begin_date is null and self.end_date is null) or
     (self.begin_date is null and self.end_date >= contract_begin_date) or
     (self.end_date is null and self.begin_date <= contract_end_date)
     true
   else
    false
   end
  end

  def get_applicable_deposite_policy
    rate_deposite_policy = hotel.deposit_policies.where(apply_to_all_bookings: true).first
    rate_deposite_policy = deposit_policy unless rate_deposite_policy
    rate_deposite_policy
  end
end

