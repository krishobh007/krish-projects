class RoomRate < ActiveRecord::Base
  attr_accessible :rate_set_id, :rate_set, :room_type_id, :room_type, :single_amount, :double_amount, 
                  :extra_adult_amount, :child_amount,  :day_hourly_incr_amount, :night_hourly_incr_amount

  belongs_to :rate_set, inverse_of: :room_rates
  belongs_to :room_type

  has_many :room_custom_rates
  has_many :hourly_room_rates, dependent: :destroy
  validates :rate_set, :room_type, presence: true
  validates :single_amount, :double_amount, :extra_adult_amount, :child_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :rate_set_id, uniqueness: { scope: [:room_type_id] }

  # after_create :create_based_on_room_rates!
  # after_update :update_based_on_room_rates!

  # After destroying, destroy all based on room rates
  after_destroy do |record|
    record.based_on_room_rates.destroy_all unless record.based_on_rate
  end

  # Create the room rate on the based on rates
  def create_based_on_room_rates!(hourly_room_rates_hash)
    unless based_on_rate
      rate_set.based_on_sets.each do |child_set|
        rate = child_set.rate_date_range.rate
        child_single_amount = rate.is_hourly_rate ? single_amount : rate.calculate_based_on_amount(single_amount)
        child_double_amount = rate.calculate_based_on_amount(double_amount)
        child_extra_adult_amount = rate.calculate_based_on_amount(extra_adult_amount)
        child_child_amount = rate.calculate_based_on_amount(child_amount)
        child_day_hourly_incr_amount = day_hourly_incr_amount
        child_night_hourly_incr_amount = night_hourly_incr_amount
        new_room_rate = child_set.room_rates.create!(room_type_id: room_type_id, single_amount: child_single_amount, double_amount: child_double_amount,
                                                     extra_adult_amount: child_extra_adult_amount, child_amount: child_child_amount,
                                                     day_hourly_incr_amount: child_day_hourly_incr_amount,
                                                     night_hourly_incr_amount: child_night_hourly_incr_amount)
        new_room_rate.hourly_room_rates.create!(hourly_room_rates_hash) if rate.is_hourly_rate
      end
    end
  end

  # Update the room rate on the based on rates
  def update_based_on_room_rates!(hourly_room_rates_hash)
    unless based_on_rate
      based_on_room_rates.each do |child_room_rate|
        rate = child_room_rate.rate_set.rate_date_range.rate

        child_single_amount = rate.is_hourly_rate ? single_amount : rate.calculate_based_on_amount(single_amount)
        child_double_amount = rate.calculate_based_on_amount(double_amount)
        child_extra_adult_amount = rate.calculate_based_on_amount(extra_adult_amount)
        child_child_amount = rate.calculate_based_on_amount(child_amount)
        child_day_hourly_incr_amount = day_hourly_incr_amount
        child_night_hourly_incr_amount = night_hourly_incr_amount

        child_room_rate.update_attributes!(room_type_id: room_type_id, single_amount: child_single_amount, double_amount: child_double_amount,
                                           extra_adult_amount: child_extra_adult_amount, child_amount: child_child_amount,
                                           day_hourly_incr_amount: child_day_hourly_incr_amount,
                                           night_hourly_incr_amount: child_night_hourly_incr_amount)
        child_room_rate.hourly_room_rates.create!(hourly_room_rates_hash) if rate.is_hourly_rate
      end
    end
  end

  # Gets the equivalent room_rates from the based on child rates
  def based_on_room_rates
    date_range = rate_set.rate_date_range
    child_rate_ids = date_range.rate.based_on_rates.linked.select(:id).map(&:id)

    RoomRate.includes(rate_set: :rate_date_range).where('rate_date_ranges.rate_id' => child_rate_ids)
      .where('? <= rate_date_ranges.begin_date and rate_date_ranges.end_date <= ?', date_range.begin_date, date_range.end_date)
      .where('rate_sets.name = ?', rate_set.name)
      .where(room_type_id: room_type_id_was)
  end

  # Returns the room rate for a specific date and room type
  scope :for_date_and_room_type, lambda { |date, room_type|
    for_date(date).where('room_rates.room_type_id' => room_type.id)
  }

  # Returns the room rate for a specific date and room type
  scope :for_date, lambda { |date|
    weekday = date.to_date.andand.strftime('%A').downcase
    where('rate_date_ranges.begin_date <= :date and :date <= rate_date_ranges.end_date', date: date).where("rate_sets.#{weekday}")
  }

  scope :between_dates, lambda { |from_date, to_date|
    includes(rate_set: :rate_date_range).where('rate_date_ranges.begin_date <= ? and ? <= rate_date_ranges.end_date', from_date, to_date)
  }

  # Exclude pseudo room type listing from Rate Manger screen.
  scope :exclude_pseudo, -> { joins(:room_type).where('room_types.is_pseudo = false') }

  scope :without_room_types, ->(room_type_ids) { where('room_type_id not in (?) ', room_type_ids) }

  # Apply a custom rate to the date
  def apply_custom_rates!(date, single, double, extra_adult, child)

    room_custom_rate = room_custom_rates.where(date: date).first
    room_custom_rate = room_custom_rates.build(date: date) unless room_custom_rate
    
    # get customized rate amount if exists, else original rate amount
    current_values = {}
    [:single_amount, :double_amount, :extra_adult_amount, :child_amount].each do |occupancy_type|
      current_values[occupancy_type] = room_custom_rate.andand[occupancy_type] || self[occupancy_type]
    end

    room_custom_rate.single_amount = calculate_amount(current_values[:single_amount], single)
    room_custom_rate.double_amount = calculate_amount(current_values[:double_amount], double)
    room_custom_rate.extra_adult_amount = calculate_amount(current_values[:extra_adult_amount], extra_adult)
    room_custom_rate.child_amount = calculate_amount(current_values[:child_amount], child)
    room_custom_rate.save!
  end

  # Gets the true room rates, which may have been customized
  def amounts(date)
    values = {}

    custom_room_rate = room_custom_rates.where(date: date).first

    [:single_amount, :double_amount, :extra_adult_amount, :child_amount].each do |occupancy_type|
      values[occupancy_type] = custom_room_rate.andand[occupancy_type] || self[occupancy_type]
    end

    values
  end
  
  # Get the true nightly rate (strictly for hourly), which may have been customized
  def hourly_amount(date)
    custom_room_rate = room_custom_rates.where(date: date).first
    single_amount =  custom_room_rate.andand.single_amount ? custom_room_rate.single_amount : self[:single_amount]
  end

  # Returns the based on rate
  def based_on_rate
    rate_set.rate_date_range.rate.based_on_rate
  end

  private

  # Calculate the amount using the type
  def calculate_amount(current_amount, details)
    if current_amount && details.andand[:value]
      type = details[:type]

      if type == 'amount_new'
        details[:value]
      elsif type == 'amount_diff'
        current_amount + details[:value]
      else
        current_amount + (current_amount * details[:value] / 100)
      end
    end
  end

  # Validates the details against the based on rate
  def based_on_details
    if based_on_rate
      # Marks as invalid if the room rate is not the same as one of the based on rate date range set rates
      errors.add(:base, :not_same) unless based_on_room_rate
    end
  end
end
