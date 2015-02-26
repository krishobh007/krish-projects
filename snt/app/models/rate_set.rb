class RateSet < ActiveRecord::Base
  attr_accessible :rate_date_range_id, :rate_date_range, :name, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday,
                  :day_min_hours, :day_max_hours, :day_checkout_cut_off_time,
                  :night_start_time, :night_end_time, :night_checkout_cut_off_time

  belongs_to :rate_date_range, inverse_of: :sets
  has_many :room_rates, inverse_of: :rate_set, dependent: :destroy

  validates :rate_date_range, :name, presence: true
  validates :name, uniqueness: { scope: [:rate_date_range_id], case_sensitive: false }
  validates :day_min_hours, :day_max_hours, numericality: {
    greater_than_or_equal_to: 1, less_than_or_equal_to: 24
  }, allow_nil: true
  validate :no_overlaps
  validate :day_is_selected
  validate :based_on_details

  after_create :create_based_on_sets!
  after_update :update_based_on_sets!

  # After destroying, destroy all based on sets
  after_destroy do |record|
    record.based_on_sets.destroy_all unless record.based_on_rate
  end

  # Create the set on the based on rates
  def create_based_on_sets!
    unless based_on_rate
      rate_date_range.based_on_date_ranges.each do |child_date_range|
        child_date_range.sets.create!(name: name, sunday: sunday, monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday,
                                      friday: friday, saturday: saturday)
      end
    end
  end

  # Update the set on the based on rates
  def update_based_on_sets!
    unless based_on_rate
      based_on_sets.each do |child_set|
        child_set.update_attributes!(name: name, sunday: sunday, monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday,
                                     friday: friday, saturday: saturday)
      end
    end
  end

  # Adds errors if the day is repeated across multiple sets in the same date range
  def no_overlaps
    invalid = false

    sets = rate_date_range.sets
    sets = sets.where('id != ?', id) if persisted?

    sets.each do |set|
      if set.name != name
        [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday].each do |day|
          invalid ||= set[day] && self[day]
        end
      end
    end

    errors[:base] << I18n.t(:rate_set_overlap) if invalid
  end

  # Ensures at least one day is selected
  def day_is_selected
    sunday || monday || tuesday || wednesday || thursday || friday || saturday
  end

  # Validates the details against the based on rate (unless rate type is promotion)
  def based_on_details
    if based_on_rate && !rate_date_range.rate.rate_type.promotion?
      # Marks as invalid if the set is not the same as one of the based on rate date range sets
      errors.add(:base, :not_same) unless based_on_set
    end
  end

  # Returns the based on rate
  def based_on_rate
    rate_date_range.rate.based_on_rate
  end

  # Returns the based on date range
  def based_on_date_range
    rate_date_range.based_on_date_range
  end

  # Returns the equivalent based on rate date range's set
  def based_on_set
    if based_on_date_range
      based_on_date_range.sets.where(name: name, sunday: sunday, monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday,
                                     friday: friday, saturday: saturday).first
    end
  end

  # Gets the equivalent sets from the based on child rates
  def based_on_sets
    child_rate_ids = rate_date_range.rate.based_on_rates.linked.select(:id).map(&:id)
    RateSet.includes(:rate_date_range).where('rate_date_ranges.rate_id' => child_rate_ids)
      .where('? <= rate_date_ranges.begin_date and rate_date_ranges.end_date <= ?', rate_date_range.begin_date, rate_date_range.end_date)
      .where(name: name_was)
  end

  # Sort by the weekdays that are selected
  scope :sorted, lambda {
    order('CASE '\
      'when rate_sets.monday then 1 ' \
      'when rate_sets.tuesday then 2 ' \
      'when rate_sets.wednesday then 3 ' \
      'when rate_sets.thursday then 4 ' \
      'when rate_sets.friday then 5 ' \
      'when rate_sets.saturday then 6 ' \
      'when rate_sets.sunday then 7 ' \
      'else 8 END')
  }
end
