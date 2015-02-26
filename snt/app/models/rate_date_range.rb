class RateDateRange < ActiveRecord::Base
  attr_accessible :begin_date, :end_date, :rate_id

  belongs_to :rate
  has_many :sets, class_name: 'RateSet', inverse_of: :rate_date_range, dependent: :destroy
  
  validates :begin_date, :end_date, :rate, presence: true
  validate :no_overlaps
  validate :begin_less_than_end
  validate :based_on_details
  validate :addons_within_range

  after_create :create_based_on_date_ranges!
  after_update :update_based_on_date_ranges!

  # After destroying, destroy all based on date ranges
  after_destroy do |record|
    record.based_on_date_ranges.destroy_all unless record.based_on_rate
  end

  # Create the date range on the based on rates
  def create_based_on_date_ranges!
    unless based_on_rate
      rate.based_on_rates.each do |child_rate|
        child_rate.date_ranges.create!(begin_date: begin_date, end_date: end_date)
      end
    end
  end

  # Update the date range on the based on rates
  def update_based_on_date_ranges!
    unless based_on_rate
      based_on_date_ranges.each do |child_date_range|
        child_date_range.update_attributes!(begin_date: begin_date, end_date: end_date)
      end
    end
  end

  def no_overlaps
    overlapping_ranges = rate.date_ranges.overlapping(begin_date, end_date)
    overlapping_ranges = overlapping_ranges.where('id != ?', id) if persisted?

    errors[:base] << I18n.t(:rate_date_range_overlap) if overlapping_ranges.exists?
  end

  # Validates that the begin date is less than the end date
  def begin_less_than_end
    errors.add(:begin_date, :less_than_end) if begin_date > end_date
  end

  # Validates the details against the based on rate (unless rate type is promotion)
  def based_on_details
    if based_on_rate && !rate.rate_type.promotion?
      # Marks as invalid if the date range is not inclusive in the based on rate's date ranges
      errors.add(:base, :not_subset) unless based_on_date_range
    end
  end

  # Returns the based on rate
  def based_on_rate
    rate.based_on_rate
  end

  # Returns the equivalent based on rate's date range
  def based_on_date_range
    based_on_rate.date_ranges.where('begin_date <= ? and ? <= end_date', begin_date, end_date).first if based_on_rate
  end

  def based_on_date_ranges
    child_rate_ids = rate.based_on_rates.linked.select(:id).map(&:id)
    RateDateRange.where(rate_id: child_rate_ids).where('? <= begin_date and end_date <= ?', begin_date_was, end_date_was)
  end

  def addons_within_range
    no_overlap_addons = rate.addons.no_overlaps(begin_date, end_date)
    errors[:base] << I18n.t(:addons_do_not_match_rate_date_range) if no_overlap_addons.exists?
  end

  scope :overlapping, lambda { |begin_date, end_date|
    where('(begin_date <= :begin_date and end_date >= :begin_date) or
           (begin_date <= :end_date and end_date >= :end_date) or
           (begin_date >= :begin_date and end_date <= :end_date)', begin_date: begin_date, end_date: end_date)
  }

  scope :no_overlap_date_ranges , lambda { |begin_date, end_date|
    where('(begin_date < :begin_date) or
           (end_date > :end_date)', begin_date: begin_date, end_date: end_date)
  }
end
