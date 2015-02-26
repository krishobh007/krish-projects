class ReservationDailyInstance < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  attr_accessible :reservation_id, :reservation_date, :status, :status_id, :room, :room_id, :room_type_id, :room_type, :original_room_type_id,
                  :rate_amount, :rate_id, :rate, :currency_code, :currency_code_id, :original_rate_amount, :market_segment, :adults,
                  :children, :children1, :children2, :children3, :children4, :children5, :children6, :cribs, :infants,
                  :extra_beds, :turndown_status, :is_due_out, :block_id, :company_id, :travel_agent_id, :group_id, :group, :skip_uniqueness_validation

  attr_accessor :skip_uniqueness_validation, :is_from_import

  belongs_to :reservation, touch: true
  belongs_to :group
  belongs_to :room

  belongs_to :rate
  belongs_to :room_type

  has_enumerated :status, class_name: 'Ref::ReservationStatus'
  has_enumerated :currency_code, class_name: 'Ref::CurrencyCode'

  validates :reservation_id, :reservation_date, :status_id, :room_type_id, :adults, presence: true
  validates :reservation_date, uniqueness: { scope: :reservation_id }, unless: :skip_uniqueness_validation
  validates :adults, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :children, :infants, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :rate_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }, unless: :departing_today?

  before_validation :set_original_fields

  # Set the original room type and rate amount if not set
  def set_original_fields
    if !original_room_type_id && room_type_id
      self.original_room_type_id = room_type_id
    end

    # if !original_rate_amount && rate_amount
    #   self.original_rate_amount = rate_amount
    # end
  end

  # Returns all daily instances that are outside of the arrival date and departure date
  scope :outlying, -> { includes(:reservation).where('reservation_date < reservations.arrival_date OR reservation_date > reservations.dep_date') }

  # Returns all daily instances that are outside of the arrival date and departure date, but including departure date
  scope :outlying_including_departure, -> { includes(:reservation).where('reservation_date < reservations.arrival_date OR reservation_date >= reservations.dep_date') }

  # get daily instances from current business date onwards
  scope :upcoming_daily_instances,  proc { |business_date|
    where('reservation_date >= ?', business_date)
  }

  # get daily instance on the current hotel business date
  scope :current_daily_instances,  proc { |business_date|
    where('reservation_date = ?', business_date)
  }

  # To findout the Total occupancy on the given date
  scope :active_between, proc { |from_date, to_date|
    where('reservation_date >= ? AND reservation_date <= ? AND (arrival_date = dep_date OR dep_date != reservation_date)', from_date, to_date)
    .with_status(:RESERVED, :CHECKEDIN, :CHECKEDOUT)
  }

  # To findout the Total occupancy on the given date with Status CHECKEDIN
  scope :inhouse_between, proc { |from_date, to_date|
    where('reservation_date >= ? AND reservation_date <= ? AND (arrival_date = dep_date OR dep_date != reservation_date)', from_date, to_date)
    .with_status(:CHECKEDIN)
  }

  # To findout the Actual/Expected Departures on the given date
  scope :departures_on, proc { |req_date, status|
    where('dep_date = ? AND reservation_date = ?', req_date, req_date)
    .with_status(status)
  }

  # To findout the Actual/Expected Arrivals on the given date
  scope :arrivals_on, proc { |req_date, status|
    where('arrival_date = ? AND reservation_date = ?', req_date, req_date)
    .with_status(status)
  }


  scope :exclude_dep_date, lambda {
    includes(:reservation).where('reservations.dep_date != reservation_date or reservations.dep_date = reservations.arrival_date')
  }

  scope :complimentary_rooms_between_dates, proc { |from_date, to_date|
    where('reservation_date >= ? AND reservation_date <= ? AND (arrival_date = dep_date OR dep_date != reservation_date)', from_date, to_date)
    .where('reservations.status_id not in (?, ?)', Ref::ReservationStatus[:NOSHOW].id, Ref::ReservationStatus[:CANCELED].id)
    .where('rate_amount = 0')
  }

  scope :between_dates, ->(from_date, to_date) { where('? <= reservation_date and reservation_date <= ?  AND (arrival_date = dep_date OR dep_date != reservation_date)', from_date, to_date)
    .where('reservations.status_id not in (?, ?)', Ref::ReservationStatus[:NOSHOW].id, Ref::ReservationStatus[:CANCELED].id)
  }

  # For hourly Statistics report
  # To find out occupancy during begin time and end time which has room assigned.
  scope :occupancy, proc { |begin_time, end_time|
    where('departure_time >= ? and arrival_time <= ? ',
          begin_time, end_time)
    .where('room_id is not null') # For Occupancy we will list only Room Number which is assigned to a reservation.
    .exclude_status(:CANCELED, :NOSHOW).uniq
  }

  scope :hourly_complimentary_rooms_between_dates, proc { |begin_time, end_time|
    where('departure_time >= ? and arrival_time <= ? ',
          begin_time, end_time)
    .where('rate_amount = 0')
    .exclude_status(:CANCELED, :NOSHOW).uniq
  }

  def total_guests
    (adults || 0) + (children || 0)
  end

  def formatted_currency
     number_to_currency(rate_amount.to_f, precision: 2,  unit: "") 
  end

  def formatted_rate_amount
    reservation.is_rate_suppressed ? '0.00' : ('%.2f' % (rate_amount)).to_s
  end

  def sr_rate?
    if rate
      rate.contracted? ? rate.is_rate_shown_on_guest_bill == false : rate.is_suppress_rate_on?
    else
      false
    end
  end

  def departing_today?
    reservation_date == reservation.dep_date
  end

  def arrival_today?
    reservation_date == reservation.arrival_date
  end

  def arrival_hour
    arrival_today? && reservation.arrival_time ? reservation.arrival_time.hour : 0
  end

  def departure_hour
    departing_today? && reservation.departure_time ? reservation.departure_time.hour : 23
  end

end
