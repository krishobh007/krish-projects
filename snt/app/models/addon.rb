class Addon < ActiveRecord::Base
  
  attr_accessible :amount, :begin_date, :description, :end_date, :name, :hotel_id, :package_code, 
                  :amount_type_id, :post_type_id, :charge_group_id,
                  :charge_code_id, :rate_code_only, :is_active, :bestseller, :is_reservation_only,
                  :is_included_in_rate

  before_destroy :validate_not_in_use

  belongs_to :hotel
  belongs_to :charge_group
  belongs_to :charge_code

  has_enumerated :amount_type, class_name: 'Ref::AmountType'
  has_enumerated :post_type, class_name: 'Ref::PostType'

  has_many :reservations_addons, class_name: 'ReservationsAddon'
  has_many :reservations, through: :reservations_addons
  has_many :rates_addons, class_name: 'RatesAddon'
  has_many :rates, through: :rates_addons
  has_many :early_checkin_setups

  validates :name, :hotel,  presence: true
  # As per the discussion removed the validation for addons
  validates :amount, :numericality => {:allow_blank => true}

  validates :description, :charge_group, :charge_code, :amount_type, :post_type,
            presence: true, unless: :external_pms?

  validate :begin_less_than_end
  validate :rate_date_ranges_within_range

  def begin_less_than_end
    errors.add(:end_date, :less_than_begin) if begin_date && end_date && begin_date > end_date
  end

  scope :rate_inclusive_addons, -> { where('reservations_addons.is_inclusive_in_rate = true') }
  scope :rate_exclusive_addons, -> { where('reservations_addons.is_inclusive_in_rate = false') }
  scope :active, -> { where('is_active') }
  scope :bestseller, -> { where('bestseller') }
  scope :rate_only, -> { where('rate_code_only') }
  scope :not_rate_only, -> { where(rate_code_only: false) }
  scope :reservation_only, -> { where('is_reservation_only') }
  scope :not_reservation_only, -> { where(is_reservation_only: false) }
  scope :no_overlaps , lambda { |begin_date, end_date|
    where('(begin_date > :begin_date) or
           (end_date < :end_date)', begin_date: begin_date, end_date: end_date)
  }

  scope :search, lambda { |params, business_date|
    results = scoped

    results = results.active.not_expired(business_date) if params[:is_active] == 'true'
    results = results.bestseller if params[:is_bestseller] == 'true'
    results = results.rate_only if params[:is_rate_only] == 'true'
    results = results.not_rate_only if params[:is_not_rate_only] == 'true'
    results = results.reservation_only if params[:is_reservation_only] == 'true'
    results = results.not_reservation_only if params[:is_not_reservation_only] == 'true'
    results = results.where(charge_group_id: params[:charge_group_id]) if params[:charge_group_id].present?
    results = results.where('begin_date is null or begin_date <= ?', params[:from_date]) if params[:from_date].present?
    results = results.not_expired(params[:to_date]) if params[:to_date].present?

    results
  }

  scope :not_expired, ->(date) { where('end_date is null or end_date >= ?', date) }

  def external_pms?
    hotel.pms_type.present?
  end

  # Validates that the addon is not in use before destroying it
  def validate_not_in_use
    if reservations_addons.count > 0
      errors.add(:base, I18n.t(:destroy_unallowed))
      return false
    end
  end

  def rate_date_ranges_within_range
    no_overlap_exists = false

    if begin_date.present? || end_date.present?
      rates.each do |rate|
        no_overlap_rate_date_ranges = rate.date_ranges.no_overlap_date_ranges(begin_date, end_date)
        if no_overlap_rate_date_ranges.exists?
          no_overlap_exists = true
          break
        end
      end
    end

    errors[:base] << I18n.t(:rate_date_range_do_not_match_addon) if no_overlap_exists
  end

  def should_post?(bill)
    should_post = false
    if post_type === :NIGHT
      #check whether it has already been posted
      existing = bill.financial_transactions.find_by_charge_code_id_and_is_active(charge_code_id, true)
      should_post = true if !existing
    elsif post_type === :STAY
      should_post = true
    end
    should_post
  end

  def addon_amount(reservation)
    daily_instance = reservation.current_daily_instance
    if amount
      if amount_type === :ADULT
        post_amount = daily_instance.adults * amount if daily_instance.adults
      elsif amount_type === :CHILD
        post_amount = daily_instance.children * amount if daily_instance.children
      elsif amount_type === :PERSON
        post_amount = daily_instance.total_guests * amount if daily_instance.total_guests
      else
        post_amount = amount
      end
    end
    post_amount
  end

  # This does not include tax
  def total_charge_for_reservation(reservation)
    one_night_charge = addon_amount(reservation)
    if post_type === :STAY
      total_addon_charge = one_night_charge * (reservation.daily_instances.count - 1)
    else
      total_addon_charge = one_night_charge
    end
    total_addon_charge
  end

end
