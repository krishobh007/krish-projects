class Reservation < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  attr_accessible :arrival_date, :confirm_no, :dep_date, :status_id, :status,
                  :hotel_id, :hotel, :arrival_time, :cancellation_no, :cancel_date, :cancel_reason,
                  :company_id, :no_room_move, :fixed_rate, :total_amount, :guarantee_type, :last_stay_room, :market_segment,
                  :total_rooms, :party_code, :preferred_room_type, :print_rate, :source_code, :travel_agent_id, :is_walkin,
                  :external_id, :upsell_amount, :original_arrival_date, :original_departure_date, :checkin_time,
                  :checkout_time, :waitlist_reason, :discount_type_id, :discount_type, :discount_amount, :discount_reason, :is_posting_restricted,
                  :is_remote_co_allowed, :is_day_use, :lobby_status, :is_upsell_applied, :is_first_time_checkin, :is_opted_late_checkout,
                  :late_checkout_time, :is_rate_suppressed, :promotion_code, :last_upsell_posted_date, :departure_time,
                  :reservation_type_id,  :last_imported, :source_id, :market_segment_id, :booking_origin_id, :is_queued, :departure_date, :is_advance_bill,
                  :no_post, :is_hourly, :creator_id, :updator_id, :is_early_checkin_purchased

  attr_accessor :tax_details

  alias_attribute :departure_date, :dep_date

  belongs_to :hotel, :inverse_of => :guests, :counter_cache => :guests_count
  has_many :reviews, :dependent => :destroy
  has_many :daily_instances, :class_name => 'ReservationDailyInstance', :dependent => :destroy
  has_many :wakeups, :dependent => :destroy
  has_many :notes, :class_name => 'Note', as: :associated, :dependent => :destroy
  has_many :guest_web_tokens, :class_name => 'GuestWebToken'
  has_many :external_references, as: :associated

  has_many :payment_methods, class_name: 'PaymentMethod', as: :associated
  has_many :primary_payment_methods, class_name: 'PaymentMethod', as: :associated, conditions: { bill_number: 1 }

  has_many :reservations_addons,  :class_name => 'ReservationsAddon', :dependent => :destroy
  has_many :addons, :through => :reservations_addons
  # has_and_belongs_to_many :addons, :class_name => 'Addon' ,:uniq=>true,:join_table=>'reservations_addons',:association_foreign_key => 'addon_id'
  has_and_belongs_to_many :memberships, :class_name => 'GuestMembership', :uniq => true, :join_table => 'reservations_memberships', :association_foreign_key => 'membership_id'
  has_and_belongs_to_many :features, :uniq => true, :class_name => 'Feature', :join_table => 'reservations_features', :association_foreign_key => 'feature_id'
  has_many :reservation_keys, :dependent => :destroy
  has_many :bills, :dependent => :destroy
  has_many :charge_routings, :through => :bills
  has_many :incoming_charge_routings, :through => :bills, class_name: 'ChargeRouting'
  has_many :financial_transactions, :through => :bills

  belongs_to :company, class_name: 'Account'
  belongs_to :travel_agent, class_name: 'Account'

  belongs_to :reservation_type, class_name: 'Ref::ReservationType'
  belongs_to :source
  belongs_to :market_segment
  belongs_to :booking_origin

  has_one :signature, :class_name => 'ReservationSignature', :dependent => :destroy

  has_enumerated :status, :class_name => 'Ref::ReservationStatus'
  has_enumerated :discount_type, :class_name => 'Ref::DiscountType'

  has_many :reservations_guest_details, :dependent => :destroy

  has_many :guest_details, through: :reservations_guest_details
  has_many :primary_guest_details, through: :reservations_guest_details, source: :guest_detail,
                                   conditions: { 'reservations_guest_details.is_primary' => true }

  has_many :actions, as: :object
  has_many :smartbands

  validates :arrival_date, :dep_date, :hotel, :status_id, presence: true

  validates :confirm_no, presence: true, unless: :external_pms?, uniqueness: { scope: :hotel_id }
  validates :upsell_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validate :dep_date_not_less_than_arrival_date
  validate :dep_time_not_less_than_arrival_time, if: :is_hourly_reservation?

  accepts_nested_attributes_for :payment_methods

  def dep_date_not_less_than_arrival_date
    dep_date && arrival_date && dep_date < arrival_date && errors.add(:dep_date, "can't be less than arrival_date")
  end

  def dep_time_not_less_than_arrival_time
    errors.add(:departure_time, "can't be less than arrival_time") if departure_time && arrival_time && departure_time < arrival_time
  end

  def is_hourly_reservation?
    is_hourly
  end

  before_destroy do
    memberships.clear
    features.clear
  end

  before_validation do
    derive_confirm_no
  end

  scope :asc, -> { order('rv.created_at ASC') }
  scope :desc, -> { order('rv.created_at DESC') }

  scope :current_reservations, proc { |business_date| where('arrival_date <= ? AND dep_date >= ?', business_date, business_date) }
  scope :upcoming_reservations, proc { |business_date| where('arrival_date > ?', business_date) } #CICO-12497 - Include all reservations irrespective of status
  scope :history_reservations, proc { |business_date| where('dep_date < ?', business_date) }
  scope :upcoming_reservations_including_todays, proc { |req_date| where('arrival_date >= ?', req_date) } 
  # Returns reservations that are reserved, checked in, or checked out, but have a departure date greater or equal to the business date
  scope :active, lambda { |business_date|
    with_status(:RESERVED, :CHECKEDIN, :CHECKEDOUT).where('dep_date >= ?', business_date)
  }

  scope :due_in, proc { |request_date|
    with_status(:RESERVED).where(arrival_date: request_date).where('is_pre_checkin <> true')
  }

  scope :pre_checkin, proc { |request_date|
    with_status(:RESERVED).where(arrival_date: request_date, is_pre_checkin: true)
  }

  scope :due_in_actual, proc { |request_date|
    with_status(:CHECKEDIN).where(arrival_date: request_date)
  }

  scope :due_in_between, proc { |from_date, to_date|
    with_status(:RESERVED).where('arrival_date >= ? and arrival_date <= ?', from_date, to_date).where('is_pre_checkin <> true')
  }

  scope :due_in_actual_between, proc { |from_date, to_date|
    with_status(:CHECKEDIN).where('arrival_date >= ? and arrival_date <= ?', from_date, to_date)
  }

  scope :checked_out_between, proc { |from_date, to_date|
    with_status(:CHECKEDOUT).where('dep_date >= ? and dep_date <= ?', from_date, to_date)
  }

  scope :in_house, proc { |request_date|
    with_status(:CHECKEDIN).where('dep_date > ?', request_date)
  }

  scope :due_out, proc { |request_date|
    with_status(:CHECKEDIN).where(dep_date: request_date)
  }

  scope :due_out_expected_between, proc { |from_date, to_date|
    with_status(:CHECKEDIN, :RESERVED).where('dep_date >= ? and dep_date <= ?', from_date, to_date)
  }

  scope :due_out_actual, proc { |request_date|
    with_status(:CHECKEDOUT).where(dep_date: request_date)
  }

  scope :due_out_between, proc { |from_date, to_date|
    with_status(:CHECKEDIN).where('dep_date >= ? and dep_date <= ?', from_date, to_date)
  }

  scope :due_out_actual_between, proc { |from_date, to_date|
    with_status(:CHECKEDOUT).where('dep_date >= ? and dep_date <= ?', from_date, to_date)
  }

  scope :is_late_checkout, proc { |request_date|
    current_reservations(request_date).exclude_status(:CHECKEDOUT).where(is_opted_late_checkout: true)
  }

  scope :is_vip_only, proc { |request_date|
    current_reservations(request_date).exclude_status(:NOSHOW, :CANCEL, :CHECKEDOUT).vip_only
  }

  scope :queued, proc { |request_date|
    current_reservations(request_date).where(is_queued: true).with_status(:RESERVED)
  }

  scope :due_in_list, proc { |hotel_id|
    select('rs.*').from('reservations as rs')
    .joins("inner join hotel_business_dates as hbd on rs.hotel_id=hbd.hotel_id AND hbd.status='OPEN'")
    .where('rs.hotel_id = ? AND rs.status_id = ? AND rs.arrival_date=hbd.business_date AND is_pre_checkin <> true', hotel_id, Ref::ReservationStatus[:RESERVED])
  }

  #Do not take the reservations which are already put in queue once any time
  scope :pre_checkin_list_not_queued, proc { |hotel_id|
    select('rs.*').from('reservations as rs')
    .joins("inner join hotel_business_dates as hbd on rs.hotel_id=hbd.hotel_id AND hbd.status='OPEN'")
    .where('rs.hotel_id = ? AND rs.is_pre_checkin = true AND rs.is_queued = false AND rs.put_in_queue_updated_at IS NULL AND rs.arrival_date=hbd.business_date', hotel_id)
  }

  scope :due_out_list, proc { |hotel_id|
    select('rs.*').from('reservations as rs')
    .joins("inner join hotel_business_dates as hbd on rs.hotel_id=hbd.hotel_id AND hbd.status='OPEN'")
    .where('rs.hotel_id = ? AND rs.status_id = ? AND rs.dep_date=hbd.business_date', hotel_id, Ref::ReservationStatus[:CHECKEDIN])
  }

  scope :inhouse_list, proc { |hotel_id|
    select('rs.*').from('reservations as rs')
    .joins("inner join hotel_business_dates as hbd on rs.hotel_id=hbd.hotel_id AND hbd.status='OPEN'")
    .where('rs.hotel_id = ? AND rs.status_id = ? AND rs.dep_date>hbd.business_date', hotel_id, Ref::ReservationStatus[:CHECKEDIN])
  }

  # Scope used by search page and API to get list of reservations per query, status, hotel_id and request date

  scope :search_by_hotel, proc { |query, status, hotel, request_date, is_late_checkout_only, is_queued_rooms_only, is_vip_only, is_post_charge, room_search, is_hourly_rate_enabled_for_hotel|
    # Make sure search results only are for provided hotel
    hotel_id = hotel.id
    results = where(hotel_id: hotel_id)

    # If query provided, search field list for matches
    if query.present?
      search_fields = []
      if room_search
        search_fields = ['room_no']
        search_conditions = search_fields.map { |field| "upper(#{field}) like :query" }.join(' OR ')
        results = results.where(search_conditions, query: "%#{query}%" )
      else
        # Define fields to search for query string and build search condition
        search_fields = ['guest_details.first_name', 'guest_details.last_name', 'confirm_no', 'room_no', 'name', 'travel_agent_accounts.account_name', 'company_accounts.account_name'] unless is_post_charge
        search_fields = ['guest_details.first_name', 'guest_details.last_name', 'travel_agent_accounts.account_name', 'company_accounts.account_name'] if is_post_charge && query[:account]

        search_conditions = search_fields.map { |field| "upper(#{field}) like :query" }.join(' OR ') unless  is_post_charge
        search_conditions = search_fields.map { |field| "upper(#{field}) like :account" }.join(' OR ') if  is_post_charge && query[:account].present?
        search_fields = ['room_no'] if is_post_charge && query[:room_no]
        search_conditions = search_conditions.present? ? search_conditions + " AND upper(room_no) like :room_no" : "upper(room_no) like :room_no" if  is_post_charge && query[:room_no]
        # Filter the results by the search conditions
        results = results.where(search_conditions, query: "%#{query.upcase}%") unless is_post_charge
        results = results.where(search_conditions, account: "%#{query[:account].to_s.upcase}%", room_no: "%#{query[:room_no].to_s.upcase}%" ) if  is_post_charge
      end
    end
    # For For Hourly Reservations
    is_hourly_rate_enabled_for_hotel = is_hourly_rate_enabled_for_hotel
    # All reservations arriving for the 24 hour period of the day,
    # As per the defect CICO- 12464, we will consider todays Current Business date EOD time to next day EOD time
    if is_hourly_rate_enabled_for_hotel
      is_eod_enabled = hotel.settings.is_auto_change_bussiness_date && hotel.settings.business_date_change_time.present?
      if is_eod_enabled
        current_eod_time = hotel.settings.business_date_change_time.in_time_zone(hotel.tz_info)
        begin_time = getDatetime(request_date.to_s, current_eod_time.to_s, hotel.tz_info)
        end_time = begin_time + 24.hours
      else
        begin_time = getDatetime(request_date.to_s ,'00:00'.to_s, hotel.tz_info)
        end_time = getDatetime(request_date.to_s ,'23:59'.to_s, hotel.tz_info)
      end
      current_business_date_time = getDatetime(request_date.to_s ,Time.now.utc.to_s, hotel.tz_info)
    end
    # If logical status and request_date provided, filter by database status
    if status && request_date
      if status == Setting.reservation_input_status[:due_in]
        # Match the "DUE IN" status ("RESERVED" arriving on request date)
        results = is_hourly_rate_enabled_for_hotel ? results.due_in_within_24hours(begin_time, end_time): results.due_in(request_date)
      elsif status == Setting.reservation_input_status[:due_out]
        # Match the "DUE OUT" status ("CHECKED IN" status and departing on request date)
        results = is_hourly_rate_enabled_for_hotel ? results.due_out_within_one_hour(request_date, current_business_date_time + 1.hour): results.due_out(request_date)
      elsif status == Setting.reservation_input_status[:in_house]
        # Match the "IN HOUSE" status ("CHECKED IN" status and depart date > request date)
        results = is_hourly_rate_enabled_for_hotel ? results.in_house_not_departing_one_hour(request_date, current_business_date_time + 1.hour): results.in_house(request_date)
      elsif status == Setting.reservation_input_status[:pre_checkin]
        # Match the "PRE CHECKIN" status ("RESERVED" status and is_pre_checkin=true arriving on request date)
        results = results.pre_checkin(request_date)
      end
    end

    # If only showing late checkout, filter by late checkout on request date
    results = results.is_late_checkout(request_date) if is_late_checkout_only
    results = results.is_vip_only(request_date) if is_vip_only
    results = results.queued(request_date) if is_queued_rooms_only

    # get reservation only one record from daily elements for particular reservation date
    results.where('reservation_date =  greatest(arrival_date, (least(dep_date, ?)))', request_date)
  }

  # Search by user/email and hotel/chain
  scope :by_user_and_hotel, proc { |user_id, email, hotel_id, chain_id|
    results = scoped

    if user_id
      results = results.includes(:guest_details).where('guest_details.user_id = ?', user_id)
    elsif email
      results = results.includes(guest_details: :emails).where('guest_additional_contacts.value = ?', email)
      if hotel_id
        results = results.where(hotel_id: hotel_id)
      else
        results = results.includes(:hotel).where('hotels.hotel_chain_id' => chain_id)
      end
    end

    # Order by confirmation number
    results.order(:confirm_no)
  }

  # get daily instance record for particular reservation
  scope :daily_instance_for_date, proc { |date|
    joins(:daily_instances).where('reservation_date =  greatest(arrival_date, (least(dep_date, ?)))', date)
  }

  # Include reservations that were checked out up to n-days before request date.
  scope :checked_out_before_n_days_from, ->(req_date, n) { with_status(:CHECKEDOUT).where('dep_date between ? and ?', req_date - n.days, req_date) }

  # Limit to reservations that have a status of (Reserved or Checked In) and an arrival date equal to the request date
  scope :checking_in_on_date, ->(req_date) { with_status(:RESERVED, :CHECKEDIN).where('arrival_date=?', req_date) }

  # Limit to reservations that have a status of Checked In and an arrival date equal to the request date
  scope :checked_in_on_date, ->(req_date) { with_status(:CHECKEDIN).where('arrival_date=?', req_date) }

  # Limit to reservation users that are VIP
  scope :vip_only, -> { includes(:guest_details).where('guest_details.is_vip = true') }

  # Below scopes - arrival_on, stay_over_on, departed_on
  # To use the calcuation in HK dashboard screen CICO-5250
  scope :arrival_on, proc { |req_date|
    where(arrival_date: req_date).exclude_status(:CANCELED, :NOSHOW)
  }

  scope :stay_over_on, proc { |req_date|
    where('dep_date > ? and arrival_date < ?', req_date, req_date)
    .exclude_status(:CANCELED, :NOSHOW)
  }

  scope :departure_on, proc { |req_date|
    where(dep_date: req_date).exclude_status(:CANCELED, :NOSHOW)
  }

  # To find out occupancy during arrival_date time and dep_date time which has room assigned.
  scope :occupancy, proc { |begin_time, end_time|
    where('departure_time >= ? and arrival_time <= ? ',
          begin_time, end_time)
    .joins(:daily_instances).where('room_id is not null') # For Occupancy we will list only Room Number which is assigned to a reservation.
    .exclude_status(:CANCELED).uniq
  }

  # Hourly Reservations - Dashboard Count Scope

  # All reservations arriving for the 24 hour period of the day,
  # so between 00:00 and 23:59, with status RESERVED and DUE IN

  scope :due_in_within_24hours, proc { |begin_date_time, end_date_time|
    with_status(:RESERVED).where('arrival_time between ? and ?', begin_date_time, end_date_time)
  }

  scope :due_out_within_one_hour, proc { |business_date, current_busines_datetime|
    with_status(:CHECKEDIN).where('dep_date = ? and departure_time <= ?', business_date, current_busines_datetime)
  }

  scope :due_out_within_24hours, proc { |current_date_time|
    with_status(:CHECKEDIN).where('departure_time between ? and ?', (current_date_time - 24.hours), current_date_time)
  }

  scope :in_house_not_departing_one_hour, proc { |business_date, current_busines_datetime|
    with_status(:CHECKEDIN).where('dep_date >= ? and departure_time > ?', business_date, current_busines_datetime)
  }

  def current?(business_date)
    arrival_date <= business_date && dep_date >= business_date
  end

  def upcoming?(business_date)
    status === :RESERVED && arrival_date > business_date
  end

  def history?(business_date)
    dep_date < business_date
  end

  def is_hourly?
     hourly_rates = self.daily_instances.joins(:rate).where('rates.is_hourly_rate=true')
     !hourly_rates.empty?
  end

  def get_review(rev_id)
    reviews.where(review_category_id: rev_id).first
  end

  def current_room_number
    current_daily_instance.andand.room.andand.room_no
  end

  def update_will_change?(attrs)
    attrs.each do |key, value|
      send("#{key}=", value)
      return true if send("#{key}_changed?")
    end
    false
  end

  def external_pms?
    hotel.andand.pms_type.present?
  end

  def due_in?
    # CICO-12464 Need to check for hourly reservation.
    # For hourly reservation always due-in.
    if is_hourly
      status === :RESERVED
    else
      status === :RESERVED && arrival_date == hotel.active_business_date
    end
  end

  def is_late_checkout_available?
    if departure_time.present? && hotel.checkout_time.present?
      do_not_allow_late_check_out = true if departure_time.strftime('%H:%M:%S') > hotel.checkout_time.strftime('%H:%M:%S')
    else
      do_not_allow_late_check_out = false
    end
    status = !do_not_allow_late_check_out &&
             !is_opted_late_checkout &&
             hotel.late_checkout_available? &&
             current_daily_instance.room_type.late_checkout_upsell_available?
    if hotel.settings.late_checkout_is_pre_assigned_rooms_excluded
      room = current_daily_instance.room
      status = status && !room.is_preallocated? if room.present?
    end
    status
  end

  # Returns the UTC time  for arrival after accounting for grace period
  def get_arr_time
    hotel.arr_grace_period ? (arrival_date.to_time - (hotel.arr_grace_period).hours).to_datetime.utc : arrival_date.to_time
  end

  # Returns the UTC time  for departure after accounting for grace period
  def get_dep_time
    hotel.dep_grace_period ? (dep_date.to_time + (hotel.dep_grace_period).hours).to_datetime.utc : dep_date.to_time
  end

  def add_or_update_wakeup(data, current_hotel)
    wakeup_call = nil

    result = {}
    hotel_date = current_hotel.current_date
    Time.zone = current_hotel.tz_info

    # Start and End date should be system date not business date
    start_date = ((data[:day] ? data[:day].upcase : '') == Setting.wakeup_day[:today] ? hotel_date : hotel_date + 1.day)

    end_date = start_date
    # status needs to be set
    status = data[:day] ? :REQUESTED : :CANCEL

    # get room_no from daily instance
    room_no = current_daily_instance.andand.room.andand.room_no
    data_hash = { time: data[:wake_up_time], room_no: room_no, status: Ref::WakeupStatus[status].value,
                  hotel_id: data[:hotel_id], reservation_id: data[:reservation_id], start_date: start_date.to_date,
                  end_date: end_date.to_date }

    wakeup_data_hash_external = Hash[:external_id, external_id].merge!(data_hash)
    wakeup_call_old_data = Hash[:external_id, external_id].merge!(data_hash)

    external_time = Time.strptime(data[:wake_up_time], '%I:%M %P').strftime('%H:%M:%S') + Time.zone.now.formatted_offset if data[:wake_up_time]

    wakeup_data_hash_external[:time] = external_time
    # if id found then either delete or update depending on the status
    if data[:id]
      wakeup_call = wakeups.find(data[:id]) # For updating existing wakeup
      # call to update wake up in external pms -- If id is found then its either update or delete. For update we need to first delete and then add
      if wakeup_call

        wakeup_call_old_data[:time] = wakeup_call.time.strftime('%H:%M:%S') + Time.zone.now.formatted_offset
        wakeup_call_old_data[:start_date] = wakeup_call.start_date
        wakeup_call_old_data[:end_date] = wakeup_call.end_date

        if self.status == Ref::ReservationStatus[:CHECKEDIN] && current_hotel.is_third_party_pms_configured?
          # send old data from table to delete old wake up call in external pms
          result = sync_wakeups_with_external_pms(wakeup_call_old_data, 'DELETE')
        else
          result[:success] = true
        end
        # if success then update SNT tables
        if result && result[:success]
          if status == :REQUESTED
            if self.status == Ref::ReservationStatus[:CHECKEDIN] && current_hotel.is_third_party_pms_configured?
              # send new data to set new wake up call
              result = sync_wakeups_with_external_pms(wakeup_data_hash_external, 'ADD')
            else
              result[:success] = true
            end

            wakeup_call.update_attributes(data_hash) if result && result[:success]
          else
            # if its not requested then delete the wake up call
            wakeups.destroy_all
          end
        else
          wakeup_call = nil
        end
      end

    else # if there is no id then its a call to create new wake up call
      wakeups.destroy_all

      # send new record to add wake up call in external pms

      if self.status == Ref::ReservationStatus[:CHECKEDIN] && current_hotel.is_third_party_pms_configured?
        result = sync_wakeups_with_external_pms(wakeup_data_hash_external, 'ADD')
        if result && result[:success]
          wakeup_call = Wakeup.new(data_hash)
          wakeups << wakeup_call
          self.save!
        end
      else
        wakeup_call = Wakeup.new(data_hash)
        wakeups << wakeup_call
        self.save!
      end

    end
    wakeup_call
  end

  # call external pms wakeup call methods
  def sync_wakeups_with_external_pms(wakeup_calls_data, action)
    result = { success: false }

    if wakeup_calls_data[:room_no]
      wake_up_api = ReservationApi.new(wakeup_calls_data[:hotel_id])
      wakeup_attributes = wake_up_api.add_wakeup_calls(wakeup_calls_data, action)

      if wakeup_attributes[:status]
        result[:success] = true
      else
        result[:success] = false
        logger.error "Error in Wakeup call: #{wakeup_attributes[:message]}"
      end
      result
    end
  end

  def get_wakeup_time
    reservation_wakeup = wakeups.first
    hotel_date = hotel.active_business_date

    wakeup_hash = {
      'today_date' => ApplicationController.helpers.formatted_date(hotel_date),
      'tomorrow_date' =>ApplicationController.helpers.formatted_date(hotel_date + 1.day)
    }

    if reservation_wakeup
      wakeup_hash['id'] = reservation_wakeup.id
      wakeup_hash['wake_up_time'] = reservation_wakeup.time.strftime('%I:%M %p')
      wakeup_hash['day'] = reservation_wakeup.start_date == hotel_date.to_date ? Setting.wakeup_day[:today] : Setting.wakeup_day[:tomorrow]
    end

    wakeup_hash
  end

  def get_ffps
    primary_guest.andand.get_ffps
  end

  def get_hlps
    primary_guest.andand.get_hlps(hotel)
  end

  def primary_guest
    primary_guest_details.first
  end

  # Sync the booking with the external PMS using the confirmation number. Gets the booking information from the 3rd party PMS and updates the
  # database.
  def sync_booking_with_external_pms(call_sync_notes = true)
    result = { status: true, message: nil }
    logger = Logger.new("#{Rails.root}/log/staycard_performance.log")
    logger.debug "Sync Booking with External PMS - Begin - #{confirm_no} "
    t1 = Time.now
    reservation_api = ReservationApi.new(hotel_id)
    booking_attributes = reservation_api.get_booking(confirm_no)
    logger.debug "Sync Booking with External PMS - GetBookingAPI (ms) - #{(Time.now - t1) * 1000} "
    # if sucess then assign values
    t2 = Time.now
    if booking_attributes[:status]
      ReservationImporter.new(self, ignore_vip: true).sync_booking_attributes(booking_attributes[:data])
      # sync notes whenever sync booking is sucessful
      logger.debug "SyncBookingwithExternalPMS-ReservationImporter- sync_booking_attributes #{(Time.now - t2) * 1000} "
      t3 = Time.now
      result = sync_notes_with_external_pms if call_sync_notes
      logger.debug "Sync Booking with External PMS - (ms) Sync Notes- #{(Time.now - t3) * 1000} "
      result[:booking_attributes] = booking_attributes[:data]
    else
      result = { status: false, message: booking_attributes[:message] }
    end
    # if error in booking attributes or from notes return result if error or success
    return result
  end

  # Sync the guest with the external PMS using the guest id. Gets the guest information from the 3rd party PMS and updates the database.
  def sync_guest_with_external_pms
    logger = Logger.new("#{Rails.root}/log/staycard_performance.log")
    if guest_details
      t1 = Time.now
      logger.debug 'Sync Guest with External PMS ---- '
      guest_api = GuestApi.new(hotel_id)
      guest_attributes = guest_api.fetch_guest(primary_guest.external_id)
      logger.debug "Sync Guest with External PMS - (ms) Fetch Guest #{(Time.now - t1) * 1000} "
      if guest_attributes[:status]
        # Update user with fetch guest response details, only if those properties are not already set
        GuestImporter.new(primary_guest, hotel).sync_guest_attributes(guest_attributes[:data])
      end
    end
    guest_attributes
  end

  # Sync notes with externl pms
  def sync_notes_with_external_pms
    result = { status: false, message: nil }
    if hotel.is_third_party_pms_configured?
      comments = []
      result = modify_notes_of_external_pms('FETCH', comments)

      # if result is success then create, update, or delete reservation notes
      if result[:status]
        # Delete all notes not returned by by external PMS
        notes_to_destroy = result[:data].empty? ? notes : notes.where('external_id not in (?)', result[:data].map { |n| n[:external_id] })
        notes_to_destroy.destroy_all

        result[:data].each do |comment|
          if !notes.exists?(external_id: comment[:external_id])
            reservation_note = self.notes.new

            reservation_note.external_id = comment[:external_id]
            reservation_note.description = comment[:description]
            reservation_note.is_guest_viewable = comment[:is_guest_viewable]
            reservation_note.note_type = :GENERAL
            reservation_note.is_from_external_system = true

            reservation_note.save
          else
            reservation_note = notes.find_by_external_id(comment[:external_id])
            reservation_note.update_attributes(description: comment[:description]) if comment[:description] != reservation_note.description
          end
        end
      end
    end
    result
  end

  def pre_checkin(application)
    result = { success: false }
    self.is_pre_checkin = true
    if self.save!
      result[:success] = true
      Action.record!(self, :CHECKEDIN, application, self.hotel_id)
    else
      result[:success] = false
      result[:errors] = self.errors
    end
    result
  end

  def send_checkin_success_staff_alert(recipients)
    if (hotel.settings.web_checkin_staff_alert_enabled == 'true') && (hotel.settings.web_checkin_staff_alert_to ==  Setting.alert_staff_options[:ALL])
      recipients.each do |recipient|
        ReservationMailer.alert_staff_on_checkin_success(self, recipient).deliver
      end unless recipients.empty?
    end
  end

  def send_checkin_failure_staff_alert(recipients, failure_message)
    if hotel.settings.web_checkin_staff_alert_enabled == 'true'
      recipients.each do |recipient|
        begin
          ReservationMailer.alert_staff_on_checkin_failure(self, recipient, failure_message).deliver!
        rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
          @logger ||= Logger.new('log/EmailNotifications.log')
          @logger.info "Warning: Web checkin - Staff Alert - Email not sent to #{recipient} : #{e.message}"
        end
      end unless recipients.empty?
    end
  end

  # Checkin the reservation, both in SNT and in external PMS. Save the signature image, set the status to CHECKEDIN, and update the room number.
  def checkin(signature_image, application, no_post = nil, payment_type_attrs = nil)
    result = { success: false }
    business_date = hotel.active_business_date

    room = current_daily_instance.room

    if room
      if hotel.is_third_party_pms_configured?
        # Checkin with the external PMS and get the room
        result = checkin_with_external_pms(no_post, payment_type_attrs)
      else
        result = { success: due_in? && room.present?, room: room }
        unless result[:success]
          result[:message] = "Could Checkin reservation_id - #{self.id} as due_in? or room is not present"
          logger.debug "Could Checkin reservation_id - #{self.id} as due_in? or room is not present"
        end
      end
    else
      result[:message] = I18n.t('reservation.room_required_for_check_in')
    end

    if result[:success]
      begin
        Reservation.transaction do
          self.status = :CHECKEDIN
          self.is_pre_checkin = false
          if signature_image
            # If there is already a signature saved, remove it before adding the new one
            signature.destroy if signature

            # Save the signature image to a BLOB in the database
            build_signature(base64_data: signature_image)
          end
          # We need to save orignal checkin time only if reservation is not hourly.
          current_time = Time.now.utc
          current_busines_datetime = Reservation.getDatetime(business_date.to_s, current_time.to_s, hotel.tz_info)
          self.arrival_time = current_busines_datetime.utc unless is_hourly
          self.save!

          daily_instances.each do |daily_instance|
            daily_instance.room_id = result[:room].id
            daily_instance.status = :CHECKEDIN
            daily_instance.save!
          end

          # Set the room to occupied
          room.update_attributes!(is_occupied: true)
          if !hotel.is_third_party_pms_configured?
            # If credit card information is provided, then add it to the reservation for bill #1
            if payment_type_attrs.andand[:payment_type] == PaymentType::CREDIT_CARD
              add_to_guest_card = payment_type_attrs[:add_to_guest_card] == 'true'
              PaymentMethod.create_on_reservation!(self, payment_type_attrs, add_to_guest_card)
            end
          end
          # CICO-9434
          # If reservation is hourly then post the charge also to the current_business_date
          if self.is_hourly
            options = {
              is_eod: false,
              amount: self.current_daily_instance.rate_amount.to_f, #Calculate the actual hourly rate amount
              rate_id: self.current_daily_instance.andand.rate_id, # rate id of the reservation
              bill_number: 1,
              charge_code: self.daily_instances.first.rate.charge_code,
              post_date: hotel.active_business_date
            }
            self.post_charge(options)
          end
          Action.record!(self, :CHECKEDIN, application, hotel_id)
        end
      rescue ActiveRecord::RecordInvalid => e
        logger.warn 'Could not set room for reservation: ' + e.message
        result[:status] = false
      end
    end

    # if reservation is upsold then post upsell charge after check in
    apply_upsell_charge_code(business_date) if result[:success] && hotel.is_third_party_pms_configured?

    result
  end

  def assign_room_from_room_type
    rooms_available = self.current_daily_instance.room_type.room_nos_excluding_due_in.select { |_room| _room.is_ready? }
    upcoming_daily_instances  = self.daily_instances.upcoming_daily_instances(self.hotel.active_business_date)
    pms_response = { :status => true }
    rooms_available.each do |room|
      pms_response = self.assign_room_with_external_pms(room.room_no) if self.hotel.is_third_party_pms_configured?

      upcoming_daily_instances.each do |daily_instance|
        daily_instance.update_attributes(room_id: room.id, room_type_id: room.room_type.id)
      end if pms_response[:status]
      pms_response[:room_no] = room.room_no
      break if pms_response[:status]
    end
    pms_response
  end

  def checkin_automatically
    result = {}
    room = current_daily_instance.andand.room
    if room.nil?
      pms_response = assign_room_from_room_type
      if pms_response[:status]
        room = current_daily_instance.andand.room
      end
    end

    begin
      result = self.checkin(nil, :ROVER, nil, nil)
      if result[:success]
        room_key_setup  = self.hotel.settings.room_key_delivery_for_guestzest_check_in
        if room_key_setup == 'email' || room_key_setup == 'smartphone' || room_key_setup == 'front_desk'
          begin
            new_key = self.reservation_keys.empty? ? self.create_reservation_key(false, 1) : self.reservation_keys.first
            ReservationMailer.auto_checkin_reservation_key(new_key.id, ReservationMailer.default_url_options[:host], self,
                                                       self.primary_guest.email).deliver! if self.primary_guest.andand.email.present?
          rescue ActiveRecord::RecordNotFound => ex
            puts ex.message, "Exception occured at 737"
          end
        end
      end
    end if room.present? && room.is_ready?
    return result
  end

  # Checkin with the external PMS using the external id. Returns the status and room object.
  def checkin_with_external_pms(no_post, card_info)
    result = { success: false, room: nil, message: nil }

    if external_id
      reservation_api = ReservationApi.new(hotel_id)
      checkin_attributes = reservation_api.check_in(self, no_post, card_info)

      if checkin_attributes[:status]
        result[:success] = true

        # Get room number
        room_no = checkin_attributes[:data][:room_number]
        result[:room] = Room.find_by_room_no_and_hotel_id(room_no, hotel_id)

        logger.warn "Room not found for: #{room_no} in hotel: #{hotel_id}" unless result[:room]
      else
        result[:message] = checkin_attributes[:message]
      end
    else
      result[:success] = true
    end

    result
  end

  # For non-credit-card bookings only, submit a modify booking request to enable remote checkout
  def enable_remote_checkout
    payment_method = primary_payment_method

    if payment_method && !(payment_method.payment_type.credit_card?)
      reservation_api = ReservationApi.new(hotel_id)
      result = reservation_api.modify_booking(confirm_no, { room_type_id: current_daily_instance.room_type_id }, true, true)

      update_attributes(is_remote_co_allowed: true) if result[:status]
    end
  end

 # Method to check whether CC is attached to reservation
  def is_cc_attached?
    primary_payment_method.present? ? primary_payment_method.payment_type.credit_card? : false
  end

   def create_web_token_for_email
    email_type = Setting.guest_web_email_types[:checkout]
    if ((status.to_s == Setting.reservation_input_status[:checked_in]) &&
       is_late_checkout_available?)
      email_type = Setting.guest_web_email_types[:late_checkout]
    elsif (status.to_s == Setting.reservation_input_status[:reserved])
      if hotel.is_pre_checkin_only?
        email_type = Setting.guest_web_email_types[:pre_checkin]
      else
        email_type = Setting.guest_web_email_types[:checkin]
      end
    end
    guest_web_token = GuestWebToken.find_by_guest_detail_id_and_is_active_and_reservation_id_and_email_type(primary_guest.id,true,id, email_type)
    guest_web_token = GuestWebToken.create(:access_token=>SecureRandom.hex,:guest_detail_id=>primary_guest.id,:reservation_id=>id,:email_type=>email_type) unless guest_web_token
    guest_web_token
  end


  # Get the current daily instance based on the business date in relation to the arrival and departure dates
  def current_daily_instance(requested_date = nil)

    business_date = requested_date ? requested_date : hotel.active_business_date

    if business_date <= arrival_date
      daily_instances.where('reservation_date = ?', arrival_date).first
    elsif dep_date <= business_date
      daily_instances.where('reservation_date = ?', dep_date).first
    else
      daily_instances.where('reservation_date = ?', business_date).first
    end
  end

  # Received the co-ordinates of sign as json, convert into png image and save as BLOB data.
  def create_image(json_data)
    # Step -01 Create Image
    img = Magick::ImageList.new

    # Getting Width and height from application_config file.
    img.new_image(Setting.signature_canvas_width, Setting.signature_canvas_height)
    signature = Magick::Draw.new

    # Step-02 Parse JSON stringcreate_image
    json_data = json_data
    parsed_json_hash =  JSON.parse(json_data)
    for i in parsed_json_hash
      x_value_array = i['x']
      y_value_array = i['y']

      for j in 0 ..x_value_array.size - 2
        signature.line(x_value_array[j], y_value_array[j], x_value_array[j + 1], y_value_array[j + 1])
      end

      if x_value_array.size == 1
        signature.line(x_value_array[-1] - 1, y_value_array[-1] - 1, x_value_array[-1] + 1, y_value_array[-1] + 1)
      end

    end
    # Draw image into canvas
    signature.draw(img)
    img = img.trim!
    # img.write("sign.png")

    # Convert image into blob data, using Rmagick.
    blob_data = img.to_blob { self.format = 'png' }
    blob_data
  end

  def sync_bills_with_external_pms
    billing_api = BillingApi.new(hotel_id)
    invoice = billing_api.get_invoice(external_id)
    if invoice[:status]
      Bill.create_or_update_bills(invoice[:data], self)
    else
      invoice
    end
  end

  def update_checkout_details
    status = true
    business_date = hotel.active_business_date
    begin
      Reservation.transaction do
        self.status = :CHECKEDOUT
        self.dep_date = business_date
        self.checkout_time = Time.now.utc
        if is_hourly
          # As per CICO-13076
          #  Monday 23 February 2015 [7:30:46 PM] Jos Schaap: *how to fix this*
          # - check out time should be saved as hotels time zone actual calendar date and time
          self.departure_time = Time.now.utc
        end
        self.save!

        self.bills.each do |bill|
          account = self.company || self.travel_agent if (self.company || self.travel_agent)
          if account && self.bill_payment_method(bill.bill_number).andand.direct_payment?
            options = {
              payment_type: 'DB',
              amount: bill.current_balance,
              bill_number: bill.bill_number
            }
            self.submit_payment_to_bill(options)
          end
        end

        room = current_daily_instance.andand.room
        if room
          room.hk_status = :DIRTY
          room.is_occupied = false
          room.save!
        end

        daily_instances.each do |daily_instance|
          daily_instance.status = :CHECKEDOUT
          daily_instance.save!
        end
        # Update Inventory count - Based on story CICO-8604
        extra_instances = self.daily_instances.where("reservation_date >= ?", self.dep_date).with_status(:CHECKEDOUT)
        extra_instances.each do |instance|
        # Hourly inventories decrement current sold count
          if is_hourly
            HourlyInventoryDetail.map_inventories(self, true)
          elsif instance.reservation_date != self.dep_date || self.dep_date == self.arrival_date
              InventoryDetail.record!(instance.rate_id, instance.room_type_id, self.hotel.id, instance.reservation_date, false)
          end
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      logger.warn 'Could not set room for reservation: ' + e.message
      status = false
    end
    status
  end

  def cancel
    status = true
    begin
      Reservation.transaction do
        if self.status != Ref::ReservationStatus[:CANCELED]
          self.status = :CANCELED
          self.cancel_date = DateTime.now.utc
          self.save!

          daily_instances.each do |daily_instance|
            daily_instance.status = :CANCELED
            daily_instance.room = nil
            # Hourly inventories decrement current sold count
            if is_hourly
              HourlyInventoryDetail.map_inventories(self, true)
            # Update Inventory count - Based on story CICO-8604
            elsif daily_instance.reservation_date != self.dep_date || self.dep_date == self.arrival_date
              InventoryDetail.record!(daily_instance.rate_id, daily_instance.room_type_id, self.hotel.id, daily_instance.reservation_date, false)
            end
            daily_instance.save!
          end
       else
         status = false
       end
      end
    rescue ActiveRecord::RecordInvalid => e
      logger.warn 'Could not set room for reservation: ' + e.message
      status = false
    end
    status
  end

  # Make all cc transactions through payment gateway if !3pPMS
  # And make payment through OWS if 3pPMS configured
  def make_reservation_payment(card_data, bill_number, amount, fees_amount=nil, fees_code=nil)
    # Get card details
    result = { status: false, message: '' }
    errors = []

    payment_type = card_data.payment_type
    is_credit_card = payment_type.credit_card?

    # OWS Connected hotel
    if hotel.is_third_party_pms_configured?
      should_call_payment_api = true
      payment_info = {
        card_type: card_data.credit_card_type.value,
        card_name: card_data.card_name,
        mli_token: card_data.mli_token,
        expiry_date: card_data.card_expiry
      }

      # Retrieve the card number from token if OWS does not support token
      if !hotel.settings.is_pms_tokenized
        response = Mli.new(hotel).get_credit_card_number(card_data.mli_token)
        should_call_payment_api = response[:status]
        if should_call_payment_api
          card_number = response[:data]
          payment_info[:card_number] = card_number
        else
          errors = response[:errors]
        end
      end

      if should_call_payment_api
        # Ows call for make payment
        payment_api = PaymentApi.new(hotel_id)
        payment_details = payment_api.make_payment(external_id, payment_info, bill_number, amount)

        if payment_details[:status]
          result[:status] = true
        else
          result[:message] = payment_details[:message]
        end
      end

    else # Standalone Hotel
      amount = amount + fees_amount if fees_amount
      # Process credit card for stand alone if payment type is cc
      if is_credit_card
        if hotel.payment_gateway == 'sixpayments'
          settlement = SixPayment::ThreeCIntegra::Processor::Settlement.new(hotel, card_data)
          @credit_card_transaction = settlement.process({
            :amount => amount,
            :type   => 'sale',
            :currency_code => hotel.default_currency.andand.value
          })
          if @credit_card_transaction.external_message != 'APPROVED' || @credit_card_transaction.external_failure_reason != '00'
            result[:status] = false
            errors << "The payment is rejected with #{@credit_card_transaction.external_message} and code #{@credit_card_transaction.external_failure_reason}"
          else
            result[:status] = true
          end

          result[:credit_card_transaction] = @credit_card_transaction
        elsif hotel.payment_gateway == 'MLI'
          guest_name = card_data.card_name.present? ? card_data.card_name : (primary_guest.nil? ? 'TEST' : primary_guest.first_name)
          
          settlement = MerchantLink::Lodging::Processor::Settlement.new(hotel)
          @credit_card_transaction = settlement.process({
            :amount         => amount,
            :payment_method => card_data,
            :type           => 'auth_settle',
            :checkin_date   => arrival_date.strftime("%Y%m%d"),
            :checkout_date  => dep_date.strftime("%Y%m%d"),
            :room_rate      => average_rate_amount,
            :guest_name     => guest_name
          })
          result[:status] = true
          result[:credit_card_transaction] = @credit_card_transaction
        else
          errors << 'No payment gateway found.'
        end
      end

    end

    result[:message] = errors.to_sentence if !errors.empty?
    return result
  end

  def submit_payment_to_bill(options)
    begin
      # Below are the possible options
        # bill_number,
        # payment_type_id,
        # payment_type,
        # is_emv_request,
        # amount,
        # fees_amount,
        # add_to_guest_card,
        # fees_charge_code_id,
      @credit_card_transaction = options[:credit_card_transaction]
      initial_amount           = options[:initial_amount]
      
      bill_number = options[:bill_number] || 1
      bill = bills.find_by_bill_number(bill_number)
      bill = bills.create!(bill_number: 1) unless bill
      errors = []
      total_amount = 0
      result = {}
      #This is actually the payment_method_id (id of a record in payment_methods table)
      bill_payment_method = PaymentMethod.find(options[:payment_type_id]) if (options[:payment_type_id]).present?
      payment_type = hotel.payment_types.find_by_value(options[:payment_type]) if (options[:payment_type]).present?

      is_emv_request = options[:is_emv_request]

      if options[:amount].present? && options[:payment_type].present? && !((bill_payment_method.nil? && options[:payment_type] == 'CC') && !is_emv_request)

        total_amount = options[:fees_amount].nil? ? options[:amount] : (options[:fees_amount].to_f + options[:amount].to_f).to_s
        cc_amount = initial_amount.nil? ? total_amount : options[:fees_amount].nil? ? initial_amount : (options[:fees_amount].to_f + initial_amount.to_f).to_s
        # Make C&P payments
        if is_emv_request.present? && is_emv_request
          if @credit_card_transaction.nil?
            if cc_amount.to_i >= 0
              @credit_card_transaction = CreditCardTransaction.make_emv_payment(hotel, cc_amount)
            else
              refund_amount = cc_amount.to_i * -1
              prior_transaction = self.financial_transactions.cc_credit.last
              credit_card = prior_transaction.andand.credit_card_transaction.andand.payment_method
              @credit_card_transaction = self.refund_deposits_to_cc(credit_card, refund_amount, true)
            end
          end
          bill_payment_method = @credit_card_transaction.payment_method
        end

        if options[:payment_type] == 'CC'
          # Add payment method to guest card
          if options[:add_to_guest_card] == true
            guest = primary_guest
            existing_payment_method = guest.payment_methods.where(id: options[:payment_type_id]).first
            if !existing_payment_method && guest #Insert this as new
              bill_payment_method.associated = guest
              bill_payment_method.save
            end
          end
          charge_code = bill_payment_method.charge_code(hotel)
        else
          charge_code = payment_type.charge_code(hotel)
        end
        # Make payment only if charge code is present
        if options[:payment_type] == 'CC' && !is_emv_request

          is_offline = bill_payment_method.andand.payment_type.andand.offline?(hotel) || bill_payment_method.andand.credit_card_type.andand.offline?(hotel)
          begin
            if @credit_card_transaction.nil?
              if cc_amount.to_i >= 0
                # Make payment through OWS or payment gateway
                payment_result = self.make_reservation_payment(bill_payment_method, bill_number, cc_amount)
                @credit_card_transaction = payment_result[:credit_card_transaction]
              else
                refund_amount = cc_amount.to_i * -1
                @credit_card_transaction = self.refund_deposits_to_cc(bill_payment_method, refund_amount, false)
              end
            end
          end unless is_offline
        end
        if !hotel.is_third_party_pms_configured?
          if charge_code
            # Insert all transactions to SNT DB
            if options[:payment_type] == "DB"
              account = self.company || self.travel_agent if (self.company || self.travel_agent)
              if account
                bill.update_attribute(:account_id, account.id)
                if self.bill_payment_method(bill.bill_number).andand.direct_payment?
                  ar_transaction = hotel.ar_transactions.create({
                      debit: bill.current_balance,
                      date: hotel.active_business_date,
                      bill_id: bill.id,
                      reservation_id: self.id,
                      account_id: bill.account_id
                    }) if bill.current_balance > 0
                end
              end
            end

            transaction = bill.financial_transactions.create(amount: total_amount.to_f,
              date: hotel.active_business_date,
              currency_code_id: hotel.default_currency.andand.id,
              charge_code_id: charge_code.andand.id,
              time: hotel.current_time,
              reference_text: options[:reference_text],
              credit_card_transaction_id: @credit_card_transaction.andand.id
            )
            FinancialTransaction.record_action(transaction, :CREATE_TRANSACTION, :WEB, hotel.id)
            transaction.set_cashier_period
            transaction.record_details({payment_method: bill_payment_method})
            if options[:fees_charge_code_id] && options[:fees_amount]
              FinancialTransaction.create_fees_transactions(transaction, options[:fees_amount], options[:fees_charge_code_id])
            end
          else
            errors << "The charge code for selected payment type does not exist"
          end
        end

      else
        errors << "Request is not valid"
      end

      financial_records = bill.financial_transactions.where('financial_transactions.charge_code_id IS NOT NULL')
      bill_balance = financial_records.exclude_payment.sum(:amount).round(2) - financial_records.credit.sum(:amount).round(2)

      if errors.empty?
        result[:data] = {
              reservation_id: self.id,
              bill_balance:  bill_balance,
              reservation_balance: self.current_balance,
              authorization_code: @credit_card_transaction.andand.authorization_code.to_s,
              payment_method: {
                id: bill_payment_method.andand.id,
                token: bill_payment_method.andand.mli_token,
                expiry_date: bill_payment_method.andand.card_expiry_display,
                card_type: bill_payment_method.andand.credit_card_type.andand.value,
                ending_with: bill_payment_method.andand.mli_token_display
              }
        }
        result[:errors] = []
        result[:credit_card_transaction] = @credit_card_transaction
      else
        result[:data] = {}
        result[:errors] = errors
      end
    rescue ActiveRecord::RecordNotFound => ex
      result[:data] = {}
      result[:errors] = [ex.message]
    end
    result
  end

  # get current balance on reservation
  def current_balance
    # if rate is suppressed then don't include window which has room charges in the total debit amount
    if is_rate_suppressed
      total_debit_amount = 0
      total_credit_amount = 0

      bills.each do |bill|
        unless bill.financial_transactions.is_active.include_room.exists?
          total_debit_amount += bill.financial_transactions.is_active.exclude_payment.sum(:amount)
          total_credit_amount += bill.financial_transactions.is_active.credit.sum(:amount)
        end
      end
    else
      total_debit_amount = financial_transactions.is_active.exclude_payment.sum(:amount)
      total_credit_amount = financial_transactions.is_active.credit.sum(:amount)
    end
    NumberUtility.default_amount_format(total_debit_amount.to_f.andand.round(2) - total_credit_amount.to_f.andand.round(2))
  end

  # This does not include tax
  def total_addon_charges
    total_addon_charges = 0

    reservations_addons.each do |res_addon|
      addon_charge = res_addon.addon.total_charge_for_reservation(self) * res_addon.quantity
      total_addon_charges += addon_charge
    end
    total_addon_charges
  end

  # This included both room charges and the taxes associated
  def accommodation_cost
    accommodation_cost = {}
    if self.zero_nights?
      daily_instances = self.daily_instances
    else
      daily_instances = self.daily_instances.where('reservation_date != ?', dep_date)
    end
    accommodation_cost[:room_cost] = daily_instances.sum(:rate_amount).to_f
    bill = bills.first || Bill.create(bill_number: 1, reservation_id: self.id)

    # Find the total accommodation tax
    accommodation_exclusive_tax = 0
    accommodation_inclusive_tax = 0
    daily_instances.each do |instance|
      charge_code = instance.rate.charge_code
      ex_tax = []
      in_tax = []
      ex_tax = charge_code.taxes(instance.rate_amount, self, bill).map { |tax_info| tax_info[:amount] }
      in_tax = charge_code.taxes(instance.rate_amount, self, bill, true).map { |tax_info| tax_info[:amount] }
      accommodation_exclusive_tax = accommodation_exclusive_tax + (ex_tax.compact.inject(:+) || 0)
      accommodation_inclusive_tax = accommodation_inclusive_tax + (in_tax.compact.inject(:+) || 0)
    end
    accommodation_cost[:accommodation_exclusive_tax] = accommodation_exclusive_tax
    accommodation_cost[:accommodation_inclusive_tax] = accommodation_inclusive_tax
    accommodation_cost
  end

  # This inclused both the package charges and the taxes associated
  def addon_cost
    bill = bills.first || Bill.create(bill_number: 1, reservation_id: self.id)
    addon_cost = {}
    addon_cost[:package_cost] = self.total_addon_charges
    #Find the total addon tax
    addon_exclusive_tax = 0
    addon_inclusive_tax = 0
    self.reservations_addons.each do |res_addon|
      ex_tax = []
      in_tax = []
      addon = res_addon.addon
      charge_code = addon.charge_code
      if charge_code
        ex_tax = charge_code.taxes(addon.total_charge_for_reservation(self) * res_addon.quantity, self, bill).map { |tax_info| tax_info[:amount] }
        in_tax = charge_code.taxes(addon.total_charge_for_reservation(self) * res_addon.quantity, self, bill, true).map { |tax_info| tax_info[:amount] }
      end
      addon_exclusive_tax = addon_exclusive_tax + (ex_tax.compact.inject(:+) || 0)
      addon_inclusive_tax = addon_inclusive_tax + (in_tax.compact.inject(:+) || 0)
    end
    addon_cost[:addon_exclusive_tax] = addon_exclusive_tax
    addon_cost[:addon_inclusive_tax] = addon_inclusive_tax
    addon_cost
  end

  def currency_code
    if bills.count > 0 && bills.first.financial_transactions.count > 0
      code = bills.first.financial_transactions.first.currency_code.andand.value
    else
      code = current_daily_instance.currency_code.andand.value if current_daily_instance
    end
    code = code || hotel.default_currency.to_s
  end

  def timeline(business_date)
    time_line = 'history'
    if arrival_date <= business_date && dep_date >= business_date
      time_line = 'current'
    elsif arrival_date > business_date #CICO-12497 - Include all reservations irrespective of status
      time_line = 'upcoming'
    end
    time_line
  end

  def valid_primary_card?
    valid_primary_payment_method.present?
  end

  # Checkout with the external PMS using the external id. Returns the status.
  def checkout_with_external_pms
    result = { status: false, message: '' }
    if external_id

      guest_api = GuestApi.new(hotel_id)
      guest_api.insert_update_privacy_option(primary_guest.external_id, 'Email' , 'YES')

      reservation_api = ReservationApi.new(hotel_id)

      # Checkout
      checkout_attributes = reservation_api.check_out(self)

      if checkout_attributes && checkout_attributes[:status]
        result[:status] = true
      else
        result[:message] = checkout_attributes[:message]
      end
    else
      result[:status] = false
      logger.warn "Invalid external ID for reservation #{id}"
    end

    result
  end

  # post payment to be called from end of day process
  def post_payment(process_date, is_eod = false)
    # get all the bills for reservation
    if !self.bills.empty?
      self.bills.each do |bill|
        post_pay = false
        # get payment method of each bill
        bill_payment_method = self.bill_payment_method(bill.bill_number)
        # get charge code associated with payment type
        charge_codes = self.hotel.charge_codes.payment
        if bill_payment_method
          charge_code = bill_payment_method.credit_card? ?
            charge_codes.cc.find_by_associated_payment_id(
              Ref::CreditCardType[bill_payment_method[:credit_card_type_id]].andand.id
            ) : charge_codes.non_cc.find_by_associated_payment_id(
              PaymentType.find_by_id(bill_payment_method[:payment_type_id]).andand.id
            )
        end
        # if charge code is present then get and post the balance
        if charge_code
          # get financial records and bill balance for that bill number
          financial_records = bill.financial_transactions.where('financial_transactions.charge_code_id IS NOT NULL')
          bill_balance = financial_records.exclude_payment.sum(:amount).round(2) - financial_records.credit.sum(:amount).round(2)
          # if balance is there then post the charges
          if bill_payment_method.credit_card?
            # get authorization
            post_pay = true
          elsif bill_payment_method.check?
            # do check validation
            post_pay = true
          elsif bill_payment_method.direct_payment?
            # do ar account validation
            post_pay = true
          elsif bill_payment_method.cash?
            # post with cash
            post_pay = true
          else
            post_pay = true
          end
          # if post pay and bill balance the post the payment
          transaction = self.post_transaction(bill, bill_balance, charge_code.id, process_date, is_eod) if bill_balance > 0 && post_pay
          return true if transaction
        else
          return false
        end
      end
    else
      return false
    end

  end

  # Post Charge
  def post_charge(options)
    charge_code = options[:charge_code] if options[:charge_code].present?
    advance_bill = options[:advance_bill] || false
    bill_no = options[:bill_number] if options[:bill_number].present?
    bill = self.bills.first if !bill_no.present?

    bill = self.bills.find_by_bill_number(bill_no) || self.bills.first || Bill.create(bill_number: 1, reservation_id: self.id) if bill_no
    hotel = self.hotel
    if options[:is_eod] || advance_bill
      rate = hotel.rates.find(options[:rate_id]) if options[:rate_id].present?
      charge_code = rate.charge_code if (rate && rate.charge_code)
    end

    charge_code_id = charge_code ? charge_code.id : nil

    # if charge code is there then process to post transactions
    if charge_code_id.present?
      if options[:addon].present?
        should_post = options[:addon].should_post?(bill) && options[:amount] > 0
      else
        # Add additional flag - hourly_reservation_is_edit, should_post became true if post charge calls from hourly reservation edit.
        should_post = options[:amount].to_f > 0 || options[:hourly_reservation_is_edit]
      end
      if options[:rate_id]
        should_post = false  if hotel.rates.find(options[:rate_id]).is_hourly_rate && (options[:is_eod] == true || advance_bill)
      end
      if should_post
        if options[:amount] && charge_code_id
          transaction = post_transaction(bill, options[:amount], charge_code_id, options[:post_date], options[:is_eod]) if !options[:is_item_charge]
          transaction = post_item_charge_transaction(bill, options[:amount], charge_code_id, options[:post_date], options[:is_eod], nil, options[:item_details]) if options[:is_item_charge]
          post_taxes(bill, charge_code, options[:amount], options[:post_date], options[:is_eod], transaction.id) if charge_code && !charge_code.is_tax?
        end
      end
    end
  end


   def routed_bill(charge_code, bill)
   billing_groups = charge_code.billing_groups
   if !billing_groups.empty?
     to_bill_id = self.bills.joins(:charge_routings).where("charge_routings.billing_group_id in (?)", billing_groups.pluck(:id)).pluck(:to_bill_id).first
   end
   unless to_bill_id.present?
     to_bill_id = self.bills.joins(:charge_routings).where("charge_routings.charge_code_id = ? ", charge_code.id).pluck(:to_bill_id).first
   end
   if to_bill_id.present?
     bill = Bill.find(to_bill_id)
   end
   bill
  end

  def post_transaction(bill, amount, charge_code_id, post_date, is_eod, parent_transaction_id=nil)
    charge_code = ChargeCode.find(charge_code_id)
    bill = self.routed_bill(charge_code, bill)
    post_date = post_date || hotel.active_business_date

    existing_transaction = bill.financial_transactions.find_by_date_and_charge_code_id_and_is_active_and_parent_transaction_id(post_date, charge_code_id, true, parent_transaction_id)
    parent_transaction = bill.financial_transactions.find(parent_transaction_id) if parent_transaction_id
    parent_transaction_comments = parent_transaction.andand.comments
    options = {
      amount: amount,
      date: post_date,
      currency_code_id: self.hotel.default_currency.andand.id,
      charge_code_id: charge_code_id,
      parent_transaction_id: parent_transaction_id,
      is_eod_transaction: is_eod,
      time: hotel.current_time

    }
    # for the case of hourly reservation, whenever inhous reservation extend, we should post new transction
    # See CCIO-12503
    new_transaction = bill.financial_transactions.create(options) unless (existing_transaction && !self.is_hourly)
    transaction = existing_transaction || new_transaction

    transaction.update_attribute(:comments, parent_transaction_comments)
    transaction.set_cashier_period
    FinancialTransaction.record_action(transaction, :CREATE_TRANSACTION, :WEB, hotel.id)
    existing_transaction || new_transaction
  end


  def post_item_charge_transaction(bill, amount, charge_code_id, post_date, is_eod, parent_transaction_id=nil, item_details=nil)
    charge_code = ChargeCode.find(charge_code_id)
    bill = self.routed_bill(charge_code, bill)
    post_date = post_date || hotel.active_business_date

    transaction = bill.financial_transactions.create(amount: amount,
      date: post_date,
      time: hotel.current_time,
      currency_code_id: self.hotel.default_currency.andand.id,
      charge_code_id: charge_code_id,
      is_eod_transaction: is_eod,
      parent_transaction_id: parent_transaction_id
      )
    FinancialTransaction.record_action(transaction, :CREATE_TRANSACTION, :WEB, hotel.id)
    transaction.set_cashier_period
    transaction.record_details({item_details: item_details, hotel: self.hotel})
    transaction
  end

  #If the charge code is not of type tax find the associated taxes to the charge code

  def post_taxes(bill, charge_code, charge_amount, post_date, is_eod, parent_transaction_id)
    bill = self.routed_bill(charge_code, bill)
    hotel = self.hotel
    taxes = charge_code.taxes(charge_amount, self, bill)
    taxes.each do |tax|
      post_transaction(bill, tax[:amount], tax[:code_id], post_date, is_eod, parent_transaction_id) if tax[:amount] && tax[:amount] > 0
    end
  end

  # Returns bill #1
  def bill_one
    bills.one.first
  end

  def average_rate_amount
    if is_rate_suppressed
      '0.00'
    elsif self.zero_nights?
      daily_instances.average(:rate_amount).andand.round(2).to_s
    else
      daily_instances.where('reservation_date != ?', dep_date).average(:rate_amount).andand.round(2).to_s
    end
  end

  def guest_room_rates
    result = {}
    rate_type = current_daily_instance.andand.rate.andand.rate_desc
    rate_name = current_daily_instance.andand.rate.andand.rate_name
    daily_rates = []

    daily_instances.each do |daily_instance|
      daily_rates << {
        'is_checkout' => (dep_date == daily_instance.reservation_date).to_s,
        'day' => daily_instance.reservation_date.strftime('%A').upcase.to_s,
        'date' => daily_instance.reservation_date.strftime('%B %d').to_s,
        'rate_amount' => dep_date == daily_instance.reservation_date ? '' : number_to_currency(daily_instance.formatted_rate_amount, precision: 2,  unit: "")
      }
    end

    result['total'] = number_to_currency(average_rate_amount, precision: 2,  unit: "")
    result['rate_type'] = rate_type.to_s
    result['rate_name'] = rate_name ? rate_name.to_s : ''
    result['currency'] = hotel.default_currency.andand.symbol.to_s
    result['daily_rates'] = daily_rates ? daily_rates : ''
    result
  end

  def guest_payment_details
    result = {}
    balance = 0
    transactions = bill_one.andand.financial_transactions

    if transactions.present?
      credits = transactions.credit.sum(:amount)
      debits = transactions.exclude_payment.sum(:amount)
      balance = debits.andand.round(2) - credits.andand.round(2)
    end

    payment_method = primary_payment_method

    if payment_method
      card_time_image_file = (((payment_method.andand.credit_card_type.andand.value).to_s))
      card_type_image = card_time_image_file.present? ? "#{card_time_image_file.downcase}.png" : ''
      request = Thread.current[:current_request]
      card_image_url =  request.protocol + request.host_with_port + "/assets/#{card_type_image}"
      mli_token_display = payment_method.mli_token ? payment_method.mli_token_display.to_s : ''
      card_image_url = card_image_url
    end
    result['currency'] = hotel.default_currency.andand.symbol.to_s
    result['card_number'] = mli_token_display.to_s
    result['cc_number'] = payment_method && payment_method.mli_token.present? ? last_for(payment_method.mli_token).to_s : ''
    result['card_type'] = (payment_method.present? && payment_method.credit_card?) ? payment_method.credit_card_type.description : ''
    result['image_url'] = card_image_url ? card_image_url : ''
    result['balance'] = balance ? ('%.2f' % balance).to_s : ''
    result['payment_date'] = hotel.active_business_date.strftime('%^a %d %^b')
    result
  end

  #Display XXX before the cc number for Zest Bill
  def last_for(cc)
    cc.gsub(/(\d+)(\d{4})/, "\\1").gsub(/\d/, "X") + cc.gsub(/\d+(\d{4})/, "\\1")
  end

  def guest_bill_details(selected_bill=nil)
    result = {}
    credits = 0
    debits = 0
    total_tax = 0
    make_all_charges_suppressed = false
    fee_details_array = []
    ex_in_tax_total = 0 
    tax_details = []
    self.sync_bills_with_external_pms if hotel.is_third_party_pms_configured?
    guest_bill =  selected_bill.present? ? selected_bill : bill_one
    transactions = guest_bill.andand.financial_transactions.present? ? guest_bill.andand.financial_transactions.order('date ASC') : []
    if due_in?
      if is_rate_suppressed
        make_all_charges_suppressed = true
      end
      if hotel.is_third_party_pms_configured?
        result = sync_booking_with_external_pms
        deposit_attributes_hash = result[:booking_attributes].present? ? ViewMappings::StayCardMapping.get_balance_and_deposit(result[:booking_attributes]) : {}
      else
        deposit_attributes_hash = ViewMappings::StayCardMapping.standalone_balance_and_deposit(self)
      end
      credits = deposit_attributes_hash.present? ? deposit_attributes_hash[:deposit_paid].to_f : 0
      debits = deposit_attributes_hash.present? ? deposit_attributes_hash[:total_cost_of_stay].to_f : 0
      total_tax = deposit_attributes_hash.present? ? deposit_attributes_hash[:fees].to_f : 0

    elsif transactions.present?
      # Check if any rate is SR. If yes then make all the charges as SR
      if is_rate_suppressed && transactions.include_room.exists?
        make_all_charges_suppressed = true
      end

      credits = transactions.credit.sum(:amount)
      debits = transactions.exclude_payment.sum(:amount)

      fee_dates = transactions.pluck(:date).uniq

      fee_dates.each do |fee_date|

        fee_details_per_day = {
          'date' => fee_date.strftime(hotel.date_format),
          'fee_date' => fee_date.strftime('%^a %d %^b'),
          'print_date' => fee_date.strftime('%d-%b')
        }

        show_guest_room_params = fee_date < dep_date || self.zero_nights?

        transactions_for_date = transactions.exclude_payment.where('date = ?', fee_date.to_date)
        credit_transactions = transactions.include_payment.where('date = ?', fee_date.to_date)

        fee_details_per_day['charge_details'] = transactions_for_date.map do |transaction|
          charge_code = transaction.charge_code
          total_tax += transaction.amount if charge_code.charge_code_type === :TAX

          {
            'reference_text' => transaction.reference_text.to_s,
            'description' => charge_code.description.to_s,
            'is_tax' => charge_code.charge_code_type === :TAX,
            'amount' => make_all_charges_suppressed ? NumberUtility.default_amount_format('0') : number_to_currency(transaction.amount, precision: 2,  unit: "")
          }
        end
        fee_details_per_day['credit_details'] = credit_transactions.map do |transaction|
          charge_code = transaction.charge_code
          payment_method = primary_payment_method
          description = payment_method.payment_type.andand.description if payment_method.present?
          description += " " + last_for(payment_method.mli_token) if payment_method && payment_method.credit_card?
          {
            'reference_text' => transaction.reference_text.to_s,
            'description' => description.to_s,
            'amount' => make_all_charges_suppressed ? NumberUtility.default_amount_format('0') : number_to_currency(transaction.amount, precision: 2,  unit: "")
          }
        end
        fee_details_array << fee_details_per_day if transactions_for_date.present? || credit_transactions.present?
      end
    end
    result['fee_details'] = fee_details_array
    tax_details = grouped_tax_details(transactions, guest_bill) if transactions.present?
    result['tax_details'] = tax_details.present? ? tax_details : []
    ex_in_tax_total = tax_details.present? ? tax_details.map{|a| a[:amount]}.sum : 0
    #
    if make_all_charges_suppressed
      result['credits'] = NumberUtility.default_amount_format('0')
      result['total_fees'] = NumberUtility.default_amount_format('0')
      result['net_amount'] = NumberUtility.default_amount_format('0')
      result['total_incl_tax'] = NumberUtility.default_amount_format('0')
      result['balance'] = NumberUtility.default_amount_format('0')
    else
      result['credits'] = number_to_currency(credits, precision: 2,  unit: "")
      result['total_fees'] = number_to_currency(debits, precision: 2,  unit: "")
      result['total_incl_tax'] = number_to_currency(total_tax, precision: 2,  unit: "")
      result['net_amount'] = number_to_currency(debits-ex_in_tax_total, precision: 2,  unit: "")
      result['balance'] = number_to_currency((debits.andand.round(2) - credits.andand.round(2)), precision: 2,  unit: "")

    end

    result['currency'] = hotel.default_currency.andand.symbol.to_s
    result['currency_for_html'] = Ref::CurrencyCode[currency_code].andand.symbol.to_s
    result
  end

  def grouped_tax_details(transactions, guest_bill)
    tax_info = tax_information(transactions).group('financial_transactions.charge_code_id').sum(:amount)

    inclusive_tax_info = []
    inclusive_tax_details = []
    transactions.exclude_payment.each do |incl_transaction|
      inclusive_tax_info.concat(incl_transaction.charge_code.taxes(incl_transaction.amount, self, guest_bill, inclusive=true))
    end
    inclusive_charge_codes = (inclusive_tax_info.map {|a| a[:code_id]}).uniq
    inclusive_charge_codes.each do |code|
      inclusive_tax_details << {
        description: hotel.charge_codes.tax.find(code).description,
        amount: (inclusive_tax_info.select {|c| c[:code_id] == code }).map{|a| a[:amount]}.sum
      }
    end

    exclusive_tax_details = []
    tax_info.each do |key, value|
      exclusive_tax_details << {
        description: hotel.charge_codes.tax.find(key).description,
        amount: value.andand.round(2)
      }
    end

    total_tax_info = inclusive_tax_details.concat(exclusive_tax_details)
    grouped_tax_info = total_tax_info.group_by{|h| h[:description]}.each{|_, v| (v.map!{|h| h[:amount]})}
    tax_details = []
    grouped_tax_info.each do |key, value|
      tax_details << {description: key,
      amount: value.inject{|sum, x| sum+x} }
    end

    tax_details
  end

  # Assign room number to the reservation
  def assign_room_with_external_pms(room_no)
    result = { :status => false, :room_no => nil }
    if self.external_id
      reservation_api = ReservationApi.new(self.hotel_id)
      assign_room_attributes = reservation_api.assign_room(self.external_id, room_no)
      if assign_room_attributes && assign_room_attributes[:status]
        result[:status] = true
        result[:room_no] = assign_room_attributes[:data][:room_assigned]
      end
    else
      result[:status] = false
      logger.warn "Invalid external ID for reservation #{id}"
    end

    result
  end

  # Upgrade / Upsell room
  def upgrade_room(upsell_amount, new_room_no, application)
    result = {}
    errors = []
    update_local_tables = true

    # Set the upsell amount to zero if not present
    upsell_amount = 0 unless upsell_amount.present?

    # assign existing values
    old_room_id = current_daily_instance.room_id
    old_room_type_id = current_daily_instance.room_type_id
    old_room_type_name = current_daily_instance.room_type.room_type_name
    old_level = current_daily_instance.room_type.upsell_room_level.andand.level
    old_rate_amount = current_daily_instance.rate_amount.to_f
    old_rate_id = current_daily_instance.rate_id

    # assign new values
    new_room = hotel.rooms.find_by_room_no(new_room_no)
    new_room_id = new_room.id
    new_room_type_id = new_room.room_type_id
    new_room_type_name = new_room.room_type.room_type_name
    new_level = new_room.room_type.upsell_room_level.andand.level
    new_rate_id = old_rate_id

    # Check if third party pms configured
    if hotel.is_third_party_pms_configured?
      update_local_tables = false

      # if the reservation has room no then unassign room
      if old_room_id
        result = release_room_with_external_pms
      else
        result[:status] = true
      end

      # if release of room in external pms is sucessful then update room id to null in SNT
      if result[:status]
        # Calling modify external pms for change of upgraded room type
        changed_attributes = { room_type_id: new_room_type_id, rate_id: new_rate_id , old_room_type_id: old_room_type_id}
        result = modify_booking_of_external_pms(changed_attributes)

        if result[:status]
          # After updating room type update rate amount
          changed_attributes = { rate_amount: old_rate_amount }
          result = modify_booking_of_external_pms(changed_attributes)

          if result[:status]
            # Assign new room number
            if new_room_id
              result = assign_room_with_external_pms(new_room_no)

              if result[:status]
                new_room = hotel.rooms.find_by_room_no(result[:room_no]) if result[:room_no]
                new_room_id = new_room.id
                update_local_tables = true
              else # Assign new room failed
                logger.debug "Could not assign new room for reservation: #{id} in External PMS"
                errors = [I18n.t('reservation.external_pms.cannot_assign_new_room')]

                # Call to revert back to old rate amount
                changed_attributes = { rate_amount: old_rate_amount }
                result = modify_booking_of_external_pms(changed_attributes)

                if result[:status] # If old rate change is sucessful then change old room type and then Assign old room no
                  # Calling modify external pms for change of upgraded room type to old room type
                  changed_attributes = { room_type_id: old_room_type_id }
                  result = modify_booking_of_external_pms(changed_attributes)

                  if result[:status] # If old room type change sucessful then Assign old room no
                    if old_room_id
                      result = assign_room_with_external_pms(Room.find(old_room_id).room_no)

                      unless result[:status] # Assign old room failed
                        logger.debug "Could not assign old room for reservation: #{id} in External PMS"
                        errors = [I18n.t('reservation.external_pms.cannot_assign_old_room')]
                      end
                    end
                  else
                    logger.debug "Could not update old room type for reservation: #{id} in External PMS"
                    errors = [I18n.t('reservation.external_pms.cannot_assign_old_room_type')]
                  end
                else
                  logger.debug "Could not update old rate amount for reservation: #{id} in External PMS"
                  errors = [I18n.t('reservation.external_pms.cannot_assign_old_rate')]
                end
              end
            else # if new room is not assigned then update SNT tables
              update_local_tables = true
            end
          else # Rate Amount change failed
            logger.debug "Could not update rate amount for reservation: #{id} in External PMS"
            errors = [I18n.t('reservation.external_pms.cannot_assign_new_rate')]

            # Calling modify external pms for change of upgraded room type to old room type
            changed_attributes = { room_type_id: old_room_type_id }
            result = modify_booking_of_external_pms(changed_attributes)

            if result[:status] # If old room type change sucessful then Assign old room no
              if old_room_id
                result = assign_room_with_external_pms(Room.find(old_room_id).room_no)

                unless result[:status] # Assign old room failed
                  logger.debug "Could not assign old room for reservation: #{id} in External PMS"
                  errors = [I18n.t('reservation.external_pms.cannot_assign_old_room')]
                end
              end
            else
              logger.debug "Could not update old room type for reservation: #{id} in External PMS"
              errors = [I18n.t('reservation.external_pms.cannot_assign_old_room_type')]
            end
          end

        else # Room Type change failed  -- Assign the original room no if it was existing
          logger.debug "Could not update room type for reservation: #{id} in External PMS"
          errors = [I18n.t('reservation.external_pms.cannot_assign_new_room_type')]

          # If old room no exists then assign it back
          if old_room_id
            result = assign_room_with_external_pms(Room.find(old_room_id).room_no)

            unless result[:status] # Assign old room failed
              logger.debug "Could not assign old room for reservation: #{id} in External PMS"
              errors = [I18n.t('reservation.external_pms.cannot_assign_old_room')]
            end
          end
        end
      else # release of room failed
        logger.debug "Could not release room for reservation: #{id} in External PMS"
        errors = [I18n.t('reservation.external_pms.cannot_release_room')]
      end
    end

    # update local tables
    if update_local_tables
      # Update Inventory count - Based on story CICO-8604
      self.daily_instances.each do |daily_instance|
        if daily_instance.reservation_date != self.dep_date || self.dep_date == self.arrival_date
          InventoryDetail.record!(old_rate_id, old_room_type_id, self.hotel.id, daily_instance.reservation_date, false)
          InventoryDetail.record!(new_rate_id, new_room_type_id, self.hotel.id, daily_instance.reservation_date, true)
        end
      end

      # modify booking to update new rate_amount, room type id and room id
      changed_attributes = { room_type_id: new_room_type_id, rate_amount: old_rate_amount, room_id: new_room_id }
      modify_booking(changed_attributes)
      update_attributes(is_upsell_applied: true, upsell_amount: upsell_amount)

      action_details = [
        { key: 'room_type', old_value: old_room_type_name, new_value: new_room_type_name },
        { key: 'level', old_value: old_level, new_value: new_level },
        { key: 'amount', old_value: old_rate_amount, new_value: old_rate_amount },
        { key: 'upsell', old_value: nil, new_value: upsell_amount }
      ]

      Action.record!(self, :UPSELL, application, hotel_id, action_details)
    end

    { status: errors.empty?, errors: errors }
  end

  # Release room assigned to the reservation
  def release_room_with_external_pms
    result = ReservationApi.new(hotel_id).release_room(external_id)
    result[:status] ? result : { status: false, errors: I18n.t('reservation.cannot_release_room') }
  end

  # get total stay rate by adding all daily elements rate amount.
  # .to_f and .andand are appended wherever needed to avoid errors, done while testing Yotel APIs: CICO-9291
  def get_total_stay_amount
    total_amount = 0
    if dep_date == arrival_date
      total_amount = current_daily_instance.andand.rate_amount.to_f
    else
      total_amount = daily_instances.where('reservation_date != ?', dep_date).andand.sum(:rate_amount).to_f
    end
    ('%.2f' % total_amount).to_s
  end

  def zero_nights?
    dep_date == arrival_date
  end

  # Modify booking method to call external pms
  def modify_booking_of_external_pms(changed_attributes)
    ReservationApi.new(hotel_id).modify_booking(confirm_no, changed_attributes)
  end

  # Modify Booking in SNT
  def modify_booking(changed_attributes)
    # get daily instances for updating
    res_daily_instances = daily_instances.upcoming_daily_instances(hotel.active_business_date)

    res_daily_instances.each do |daily_instance|

      daily_instance.room_type_id = changed_attributes[:room_type_id] if changed_attributes[:room_type_id]
      daily_instance.rate_amount = changed_attributes[:rate_amount] if changed_attributes[:rate_amount]
      daily_instance.room_id = changed_attributes[:room_id] if changed_attributes[:room_id]

      daily_instance.save!
    end
  end

  # Modify payment method of reservation
  def modify_payment_method_of_external_pms(card_info)
    ReservationApi.new(hotel_id).update_payment_method(external_id, card_info)
  end

  def create_reservation_key(is_additional, number_of_keys, uid = nil)
    room_no = current_daily_instance.andand.room.andand.room_no
    if is_additional == 'false'
      reservation_keys.destroy_all
    end
    #Inactive the key with UID first if its being used for another reservation
    invalidate_key_for_previous_reservations(uid) if uid.present?
    reservation_keys.create(room_number: room_no, number_of_keys: number_of_keys, qr_data: qr_code, uid: uid, is_inactive: false)
  end

  # Get the QR code for this reservation, which is the language code and reservation id
  def qr_code
    Qrcode.get_qr_code_blob("en-US$#{id.to_s}")
  end

  def invalidate_key_for_previous_reservations(uid)
    hotel.reservations.joins(:reservation_keys).where("reservation_keys.uid = :uid AND reservation_keys.is_inactive = false", uid: uid).update_all(is_inactive: true)
  end

  # Modify comments/notes on reservation
  def modify_notes_of_external_pms(action_type, comments)
    ReservationApi.new(hotel_id).guest_comment_requests(confirm_no, action_type, comments)
  end

  # Total number of nights
  def total_nights
    (dep_date - arrival_date).to_i
  end

  # Total number of hours
  def total_hours
    (departure_time - arrival_time).to_i / 3600 if arrival_time && departure_time
  end

  # Return the statue(true/false) for enable/disable  night status button in staycard screen
  def get_enabled_night_status(active_business_date)
    enabled_status = 'true'
    if (status === :NOSHOW && dep_date < active_business_date) || status === :CANCELED || status === :CHECKEDIN || status === :CHECKEDOUT
      enabled_status = 'false'
    end
    enabled_status
  end

  # Get the date where to start looking for availability
  def availability_lower_limit
    business_date = hotel.active_business_date
    limit = arrival_date - Setting.stay_date_lower_limit.to_i
    limit <= business_date ? business_date : limit
  end

  # Get the date where to stop looking for availability
  def availability_upper_limit
    dep_date + Setting.stay_date_upper_limit.to_i
  end

  # Gets the primary (bill #1) payment type on this reservation
  def primary_payment_method
    primary_payment_methods.first
  end

  # Gets the primary (bill #1) payment type on this reservation (if valid)
  def valid_primary_payment_method
    primary_payment_methods.valid.last
  end

  # Gets the payment type for a bill on this reservation
  def bill_payment_method(bill_number)
    payment_methods.where(bill_number: bill_number).last
  end

  # Updates the payment type for a bill on this reservation
  def update_bill_payment_type!(bill_number, guest_payment_type)
    errors = []
    if guest_payment_type.persisted?
      reservation_guest_payment_type = reservations_guest_payment_types.where(bill_number: bill_number).first

      if reservation_guest_payment_type
        errors << "Unable to update guest_payment_type" unless  reservation_guest_payment_type.update_attributes!(guest_payment_type_id: guest_payment_type.id)
      else
        errors << "Unable to create guest_payment_type" unless reservations_guest_payment_types.create!(bill_number: bill_number, guest_payment_type_id: guest_payment_type.id)
      end
    end
    errors
  end

  def apply_late_checkout(late_checkout_data, application)
    applied_late_checkout = false
    result = {}
    bill_no = late_checkout_data[:bill_no] ? late_checkout_data[:bill_no] : '1'
    bill = self.bills.find_by_bill_number(bill_no)
    bill = self.bills.create!(bill_number: 1) unless bill
    late_checkout_offer = LateCheckoutCharge.find(late_checkout_data[:late_checkout_offer_id])
    charge_code_obj = hotel.late_checkout_charge_code
    charge_code = charge_code_obj.charge_code
    charge = late_checkout_offer.extended_checkout_charge
    if hotel.is_third_party_pms_configured?
      post_ows = PostChargesApi.new(hotel.id)
      posting_attr_hash = { posting_date: dep_date, posting_time: Time.now, long_info: late_checkout_data[:long_text], charge: charge, bill_no: bill_no }
      result = post_ows.update_post_charges(charge_code, external_id, posting_attr_hash)
      applied_late_checkout = result[:status]
    else
      transaction = post_transaction(bill, charge, charge_code_obj.id, hotel.active_business_date)
      applied_late_checkout = true if transaction
    end

    if applied_late_checkout
      update_attributes(is_opted_late_checkout: true, late_checkout_time: late_checkout_offer.extended_checkout_time)
      sync_bills_with_external_pms if hotel.is_third_party_pms_configured?

      action_details = [
        { key: 'time', new_value: late_checkout_offer.extended_checkout_time.andand.strftime('%-I').to_s },
        { key: 'index', new_value: hotel.late_checkout_charges.index(late_checkout_offer) },
        { key: 'charge', new_value: late_checkout_offer.extended_checkout_charge.to_i.to_s }
      ]
      if self.hotel.is_third_party_pms_configured?
        note_description = "#{late_checkout_time.andand.strftime('%l:%M %p')} LATE CHECK OUT SELECTED BY GUEST"
        result = self.modify_notes_of_external_pms('ADD', [{ description: note_description }])
      end
      Action.record!(self, :LATECHECKOUT, application, hotel_id, action_details)
    end

    result[:status] = applied_late_checkout
    result
  end

  # apply upsell charge code if exists
  def apply_upsell_charge_code(new_business_date, is_eod = false)
    result = {}
    hotel = self.hotel
    # if upsell is on and upsell is applied on reservation then go ahead and post upsell charges
    if hotel.settings.upsell_is_on && is_upsell_applied
      charge_code = hotel.upsell_charge_code
      upsell_charge_code = charge_code.present? ? charge_code.charge_code : ''
      charge_code_desc = charge_code.present? ? charge_code.description : ''

      charge_code_id = hotel.upsell_charge_code_id
      charge_code = ChargeCode.find_by_id(charge_code_id)
      upsell_charge_code = charge_code.charge_code
      charge_code_desc = charge_code.description

      upsell_posted_date = last_upsell_posted_date.present? ? last_upsell_posted_date : (new_business_date - 1)
      upsell_charge = upsell_amount
      # if upsell charge code and upsell amount is there then post charges
      if upsell_charge_code.present? && upsell_charge.present?
        # if not posted for current business date and not departure date then send upsell amount posting
        if (upsell_posted_date < new_business_date) && (new_business_date != dep_date)
          # post the charges to window 1
          bill_no = '1'
          post_ows = PostChargesApi.new(hotel.id) if hotel.is_third_party_pms_configured?

          posting_attr_hash = { posting_date: new_business_date, posting_time: Time.now, long_info: charge_code_desc, charge: upsell_charge, bill_no: bill_no }

          if hotel.is_third_party_pms_configured?
            result = post_ows.update_post_charges(upsell_charge_code, external_id, posting_attr_hash)
          else

            upsell_attributes = {charge_code: charge_code, bill_number: 1, post_date: new_business_date, amount: upsell_charge, is_eod: is_eod}
            post_charge(upsell_attributes)
            result[:status] = true
          end

          # IF success then update reservation table
          if result[:status]
            update_attributes(last_upsell_posted_date: new_business_date)
          else
            logger.debug "Could not post upsell charges for reservation: #{id} in External PMS"
          end
        else
          logger.debug "Could not post upsell charges for reservation: #{id} as charges are already posted or reservation is due today"
        end
      else
        logger.debug "Could not post upsell charges for reservation: #{id} as charge code or charge amount is not defined"
      end
    end # if upsell is on and upsell applied
  end


  #
  def send_checkin_email
    if self.hotel.is_pre_checkin_only? && self.hotel.settings.checkin_action.to_s != Setting.checkin_actions[:auto_checkin].to_s
      checkin_email_template  = self.hotel.email_templates.find_by_title('PRE_CHECKIN_EMAIL_TEXT')
      email_type = Setting.guest_web_email_types[:pre_checkin]
    else
      checkin_email_template  = self.hotel.email_templates.find_by_title('CHECKIN_EMAIL_TEMPLATE')
      email_type = Setting.guest_web_email_types[:checkin]
    end

    guest_web_token = GuestWebToken.find_by_guest_detail_id_and_is_active_and_reservation_id_and_email_type(self.primary_guest.id, true, self.id, email_type)
    guest_web_token = GuestWebToken.create(access_token: SecureRandom.hex, guest_detail_id: self.primary_guest.id, reservation_id: self.id, email_type: email_type) unless guest_web_token
    if checkin_email_template
      ReservationMailer.send_guestweb_email_notification(self,checkin_email_template).deliver!
      Action.record!(self, :EMAIL_CHECKIN, :ROVER, hotel_id)
      { status: true, errors: [] }
    else
      { status: false, errors: ["Email template is missing"] }
    end
  end

  ############################### START ----HK Stories Future Reservation status---- START #####################################

  def is_res_stay_over_than?(date)
    dep_date > date &&
    arrival_date < date
  end

  def is_res_arrival_on?(date)
    arrival_date == date
  end

  def is_res_arrived_on?(date)
    status === :CHECKEDIN &&
      arrival_date == date
  end

  def is_res_departed_on?(date)
    dep_date == date
  end

  def is_res_day_use_on?(date)
    dep_date == date && arrival_date == date
  end

  def is_res_early_checkout_than?(date)
    dep_date > date
  end

  def is_res_due_out_on?(date)
    dep_date == date
  end


  #################################################----END----###################################################

  def is_stay_over_than?(business_date)
    status === :CHECKEDIN &&
      dep_date > business_date &&
      arrival_date < business_date
  end

  def is_arrival_on?(business_date)
    status === :RESERVED &&
      arrival_date == business_date
  end

  def is_arrived_on?(business_date)
    status === :CHECKEDIN &&
      arrival_date == business_date
  end

  def is_departed_on?(business_date)
    status === :CHECKEDOUT &&
      dep_date == business_date
  end

  def is_day_use_on?(business_date)
    dep_date == business_date && arrival_date == business_date
  end

  def is_early_checkout_than?(business_date)
    dep_date > business_date && status === :CHECKEDOUT
  end

  def is_due_out_on?(business_date)
    status === :CHECKEDIN && dep_date == business_date
  end

  def is_no_show?
    status === :NOSHOW
  end
  # Checks if bill #1 exists and has a credit card attached
  def is_cc_attached
    primary_payment_method.andand.credit_card?
  end

  def transfer_transaction(options)
    if hotel.is_third_party_pms_configured?
      billing_api = BillingApi.new(self.hotel_id)
      transfer_transaction = billing_api.folio_transaction_transfer(self.external_id, options)
    else
      transfer_transaction = {status: false}
      from_bill = bills.find_by_bill_number(options[:from_bill])
      to_bill = bills.find_by_bill_number(options[:to_bill]) || bills.create(bill_number: options[:to_bill])
      from_bill.financial_transactions.find(options[:id]).child_transactions.update_all(original_transaction_id: nil)
      transfer_transaction[:status] = from_bill.financial_transactions.find(options[:id]).update_attributes(bill_id: to_bill.id, original_transaction_id: nil)
    end
    transfer_transaction
  end

  def accompanying_guests
    accompaying_guests = self.guest_details.where("reservations_guest_details.is_accompanying_guest=1")
    accompaying_guests
  end

  def card_count
    [primary_guest, company, travel_agent].compact.count
  end

  def send_late_checkout_staff_alert_emails(status, message =nil)
    if hotel.settings.is_send_checkout_staff_alert.to_s == 'true'
      recipients = hotel.web_checkout_staff_alert_emails.pluck(:email)
      alert_success = ( hotel.settings.web_checkout_staff_alert_option == Setting.alert_staff_options[:ALL] ) && status
      recipients.each do |recipient|
        ReservationMailer.alert_staff_on_late_checkout_success(self, recipient).deliver! if alert_success
        ReservationMailer.alert_staff_on_late_checkout_failure(self, recipient, message.to_s).deliver! if !status
      end if !recipients.empty?
    end
  end

  # For return the given rate is supprressed or not based on suppress rate - CICO-6083
  def is_rate_suppressed
    rate = current_daily_instance.andand.rate
    if hotel.is_third_party_pms_configured?
      rate.present? && is_rate_suppressed?
    else
      rate.contracted? ? rate.is_rate_shown_on_guest_bill == false : rate.is_suppress_rate_on?
    end
  end
  # For standalone pms, we are excluding all SR rate from the average rate_amount calcuation - CICO-6083
  def standalone_average_rate_amount
    daily_instances_rate = daily_instances.includes(:rate)
                      .where('rates.is_suppress_rate_on=false or rates.is_suppress_rate_on is null')
                      .where('rates.hotel_id = ?', hotel.id)
    if self.zero_nights?
      daily_instances_rate.empty? ? '0.0' : daily_instances_rate.average(:rate_amount).andand.round(2).to_s
    else
      daily_instances_rate.where('reservation_date != ?', dep_date).average(:rate_amount).andand.round(2).to_s
    end
  end
  # For standalone pms, we are excluding all SR rate from the total stay cost calcuation - CICO-6083
  def standalone_total_stay_amount
    daily_instances_rate = daily_instances.includes(:rate)
                      .where('rates.is_suppress_rate_on=false or rates.is_suppress_rate_on is null')
                      .where('rates.hotel_id = ?', hotel.id)
    if self.zero_nights?
      total_amount = current_daily_instance.rate && current_daily_instance.rate.is_suppress_rate_on ? 0 :
                     current_daily_instance.rate_amount
    else
      total_amount = daily_instances_rate.where('reservation_date != ?', dep_date).sum(:rate_amount)
    end
    ('%.2f' % total_amount).to_s if total_amount.present?
  end

  def suppress_rate_present_in_daily_instances
    daily_instances.includes(:rate).where('rates.is_suppress_rate_on= true')
  end

  def post_advance_bill
    business_date = hotel.active_business_date
    last_stay_date = dep_date - 1.day
    business_date.upto(last_stay_date) { |d|
      post_room_charge(true, d)
      post_addon_charges(d, true, false)
      apply_upsell_charge_code(d)
    }
    self.update_attribute(:is_advance_bill, true)
  end

  def post_room_charge(advance_bill, post_date)
    rate = current_daily_instance.andand.rate
    # Only post charge if the rate attached to the daily instance is not hourly
    # CICO-9434
    if rate && !rate.is_hourly_rate
      options = {
        is_eod: false,
        amount: current_daily_instance.andand.rate_amount,
        rate_id: current_daily_instance.andand.rate_id,
        bill_number: 1,
        charge_code: nil,
        advance_bill: advance_bill,
        post_date: post_date
      }
      post_charge(options) #charge_code
    end
  end

  def post_addon_charges(post_date, advance_bill, is_eod)
    options = {
      is_eod: is_eod,
      rate_id: nil,
      bill_number: 1,
      advance_bill: advance_bill,
      post_date: post_date
    }

    addons.each do |addon|
      options[:amount] = addon.addon_amount(self)
      options[:charge_code] = addon.charge_code
      options[:addon] = addon
      begin_date = addon.begin_date || post_date
      end_date = addon.end_date || post_date

      post_charge(options) if begin_date <= post_date && post_date <= end_date
    end
  end

  # Get the cancelation penalty for the rate on the arrival date, if there is one
  def rate_cancellation_penalty
    cancellation_policy = daily_instances.first.rate.andand.cancellation_policy
    cancellation_policy.present? ? cancellation_penalty(cancellation_policy.id, cancellation_policy.post_type) : nil
  end

  # Penalty charge calculation - Based on story CICO-1403 - currently implemented in client side
  def cancellation_penalty(cancellation_policy_id, post_type)
    cancellation_policy = Policy.find(cancellation_policy_id)
    # Get the rate amount from first daily instance of reservation
    rate_amount = self.daily_instances.first.rate_amount.to_f
    # Get the total stay amount for the reservation
    total_stay_amount = self.get_total_stay_amount.to_i
    total_nights = self.total_nights
    case cancellation_policy.amount_type
    # Set penalty amount when Cancellation policy is set for amount
    when "amount"
       penalty = cancellation_policy.amount
    # Set penalty amount when Cancellation policy is set for percentage
    when "percent"
      # Set different penalty amounts by checking whether Cancellation Policy Percentage is set for a stay or per night
       # When post type is STAY
       if post_type === :STAY
          penalty = total_stay_amount * (cancellation_policy.amount.to_f/100)
       # When post type is PER NIGHT
       elsif post_type === :NIGHT
          penalty = rate_amount * (cancellation_policy.amount.to_f/100)
       end
    # Set penalty amount when Cancellation policy is set for night
    when "day"
       penalty_nights = cancellation_policy.amount
       penalty = rate_amount * (( total_nights > penalty_nights) ? penalty_nights : total_nights).to_i
    else
       penalty = 0
    end
    penalty.round(2)
  end

  # Return Tax details of a given reservation where Charge Group Description = Tax
  def tax_information(transactions)
    # will return financial transactions for debits posted
    financial_records = transactions
                        .where('financial_transactions.charge_code_id IS NOT NULL AND is_active=true').order('financial_transactions.updated_at')
    # get all the revenues or debits
    financial_records_debits = financial_records.exclude_payment
    # get financial transaction for charge groups = TAX
    financial_records_groups = financial_records_debits.joins(charge_code: :charge_groups)
                               .where("charge_groups.description = 'TAX'") if financial_records_debits

    financial_records_groups
  end

  # Return the Bill Routing Informations
  def billing_informations
    entity_result = charge_routings.joins('LEFT OUTER join bills as to_bills on to_bills.id=charge_routings.to_bill_id')
                   .joins('LEFT OUTER JOIN reservations as to_reservations on to_reservations.id=to_bills.reservation_id')
                   .joins('LEFT OUTER JOIN accounts as to_accounts on to_accounts.id=to_bills.account_id')
                   .select('charge_routings.bill_id as from_bill_id,to_bills.id as to_bill_id,
                    to_bills.bill_number as to_bill_no, to_accounts.id as account_id,
                    to_reservations.id as reservation_id').uniq

    entity_result
  end

  def is_qualified_for_checkin_alert
    response = {status: true, message: nil}
    excluded_rate_ids = hotel.pre_checkin_excluded_rate_codes.pluck(:rate_id)
    excluded_group_ids = hotel.pre_checkin_excluded_block_codes.pluck(:group_id)
    room =  current_daily_instance.room
    rate_id = current_daily_instance.rate_id
    group_id = current_daily_instance.group_id

    if primary_guest.andand.email.present?
      response[:status] = !excluded_rate_ids.include?(rate_id) && !excluded_group_ids.include?(group_id)
      response[:message] =  "rate_code/block_code for reservation : #{confirm_no} matches with the exclude list for hotel : #{hotel.code} " unless response[:status]
      if response[:status]
        response[:status] =  response[:status] && room.present? && !room.is_occupied && room.is_ready? unless hotel.is_pre_checkin_only?
        response[:message] = "room not present for the reservation : #{confirm_no}" unless response[:status]
        if (response[:status] && hotel.settings.checkin_require_cc_for_email)
          response[:status] = false unless is_cc_attached
          response[:message] = "valid CC not present for the reservation : #{confirm_no}" unless response[:status]
        end
      end
    else
    response[:status] = false
    response[:message] = "email address not present for the reservation : #{confirm_no}"
    end
    response
  end

  def has_nightly_component?
    rate = current_daily_instance.andand.rate
    raise "Reservation does not have a rate associated" if rate.nil?
    date = arrival_date
    room_type = current_daily_instance.room_type
    begin_time = arrival_time
    end_time = departure_time
    amount_hash = rate.fetch_hourly_roomrates_data(date, room_type, begin_time)
    if (amount_hash.night_start_time == nil || amount_hash.night_end_time == nil || amount_hash.night_start_time == amount_hash.night_end_time)
      is_nightly = false
    else
      time_zone_converted = rate.adjust_roomrates_data(date, room_type, begin_time, end_time, amount_hash)
      is_nightly = rate.has_nightly_component(begin_time, end_time, time_zone_converted)
    end
    return is_nightly
  end


  def deposit_policy
    deposit_policy = hotel.deposit_policies.where(apply_to_all_bookings: true).first
    first_daily_instance = daily_instances.first
    deposit_policy = first_daily_instance.rate.andand.deposit_policy if !deposit_policy

    if deposit_policy && deposit_policy.advance_days.present? && (deposit_policy.advance_days < (self.arrival_date - self.hotel.active_business_date))
      return nil
    end
    deposit_policy
  end

  # Get the deposit details of the reservation as per the deposit rule
  #   The deposit rule of the rate of the first night of the reservation
  # is taken for the calculation

  def deposit_amount
    # If days in advance is configured for deposit policy
    # Check whether arrival_date - business_date = no_of_days in advance
    # If true then return the amount
    # Else return 0.00
    # If there is a deposit policy for the hotel configured as apply to all reservations then take that
    # Else Find rate of the first night
    #    And Find the deposit policy attached to the rate
    # If Deposit policy is configured for first night
    #   STAY_COST = Stay amount for the first night
    # If Deposit policy is configured for entire stay
    #   STAY_COST = Entire stay cost
    # Amount type of deposit policy is Amount
    # DEPOSIT_AMT = deposit_policy.amount
    # Amount type of deposit policy is Percentage
    # DEPOSIT_AMT = (deposit_policy.amount * STAY_COST) / 100
    # Amount type of deposit policy is Night(s)
    # Calculate the number of nights for this booking specified in the amount field.
    #  I.e. Amount = 1, Amount Type – Night, the deposit charge will be the First Night of this reservation.
    #  If specified ‘2’, the amount would be the first two nights.
    deposit_amount = 0
    if !self.hotel.is_third_party_pms_configured?
      deposit_policy = self.deposit_policy
      if deposit_policy
        apply_deposit = true if (deposit_policy.advance_days && arrival_date - hotel.active_business_date <= deposit_policy.advance_days) || !deposit_policy.advance_days
        if apply_deposit
          if deposit_policy.amount_type == 'amount'
            deposit_amount = deposit_policy.amount
          elsif deposit_policy.amount_type == 'percent'
            if deposit_policy.post_type === :STAY
              stay_cost = self.standalone_total_stay_amount
            elsif deposit_policy.post_type === :NIGHT
              stay_cost = daily_instances.first.rate_amount
            end
            deposit_amount = (deposit_policy.amount.to_f * stay_cost.to_f) / 100
          elsif deposit_policy.amount_type == 'day'
            deposit_amount = self.daily_instances.limit(deposit_policy.amount).pluck(:rate_amount).inject(:+)
          end
        end
      end
    end
    deposit_amount
  end

  def deposit_paid
    deposit = 0
    fees_paid = 0
    if self.bills
      deposit_transactions = self.financial_transactions
      deposit   = deposit_transactions.credit.andand.sum(:amount) if deposit_transactions
      fees_paid = deposit_transactions.fees.andand.sum(:amount) if deposit_transactions
    end
    deposit - fees_paid
  end

  def balance_deposit_amount
    balance = 0
    balance = self.deposit_amount - self.deposit_paid if self.deposit_amount > self.deposit_paid
    balance
  end
  
  # Get the deposit paid, which is to be shown in deposit reports,
  # this will be calculated prior to CHECKIN.
  def calculate_deposit_paid_before_checkin
    deposit = 0
    if self.bills
      if status === :CHECKEDIN
        deposit_transactions = self.financial_transactions.where("date <= ?", arrival_date)
      else
        deposit_transactions = self.financial_transactions
      end
      deposit = deposit_transactions.credit.andand.sum(:amount) if deposit_transactions
    end
    deposit
  end
  
  def self.kiosk_search(params,hotel)
    reservations = joins(:daily_instances)
                  .joins("LEFT OUTER JOIN rooms ON reservation_daily_instances.reservation_id = reservations.id AND reservation_daily_instances.room_id = rooms.id")
                  .joins("LEFT OUTER JOIN room_types on reservation_daily_instances.room_type_id = room_types.id")
                  .joins("LEFT OUTER JOIN reservations_guest_details on reservations_guest_details.reservation_id = reservations.id")
                  .joins("LEFT OUTER JOIN guest_details ON guest_details.id = reservations_guest_details.guest_detail_id")
                  .joins("LEFT OUTER JOIN additional_contacts ON guest_details.id = additional_contacts.associated_address_id")
                  .where("lower(guest_details.last_name) = ? AND reservations_guest_details.is_primary = 1", params[:last_name].downcase)
                  .select("reservations.id as id, reservations.is_early_checkin_purchased, reservations.is_rate_suppressed as rate_suppressed, reservations.status_id, reservations.hotel_id, reservations.confirm_no as confirm_no, reservation_daily_instances.adults as adults, reservation_daily_instances.children as children,  reservations.arrival_date as arrival_date,reservations.dep_date, "\
                          "reservations.arrival_time as arrival_time, guest_details.first_name as first_name, guest_details.last_name as last_name, room_types.room_type_name as room_type, rooms.room_no")

    reservations = reservations.where("additional_contacts.value = ? ", params[:email]) if params[:email]

    if params[:confirmation_no]
      reservations = reservations.joins("LEFT OUTER JOIN external_references ON external_references.associated_id = reservations.id")
        .where("reservations.confirm_no = :confirm_no OR (external_references.value = :confirm_no AND " \
               "external_references.reference_type_id = :reference_type_id) AND external_references.associated_type = :associated_type",
               confirm_no: params[:confirmation_no], reference_type_id: Ref::ExternalReferenceType[:CONFIRMATION_NUMBER], associated_type: Setting.external_references_associated_types[:reservation])

    end

    reservations = reservations.where("lower(additional_contacts.value) = ? ", params[:email].downcase) if params[:email]
    reservations = reservations.where("datediff(reservations.dep_date, reservations.arrival_date) = ?", params[:total_nights]) if params[:total_nights]
    reservations = params[:room_no] ? reservations.where("rooms.room_no = ? ", params[:room_no]).due_out(hotel.active_business_date) : reservations.due_in(hotel.active_business_date)
    reservations.uniq
  end

  # Method to allow checkout using kiosk
  def is_allow_checkout_from_kiosk
    ( status === :CHECKEDIN && ( current_balance.to_i == 0 || ( current_balance.to_i > 0 && is_cc_attached? )))
  end

  def post_deposit_refund_transactions(with_refund, rate_charge_code, payment_charge_code, current_cc_payments)
    # Post the depost as -ve credit
    if with_refund

      # Making -ve entry against each payment method
      bill_one.financial_transactions.cc_credit.each do |txn|

        amount_to_refund = 0

        fees_applied = txn.child_transactions.fees.sum(:amount)
        amount_to_refund = txn.amount - fees_applied

        refund_deposits_to_cc(txn.credit_card_transaction.andand.payment_method, amount_to_refund) unless txn.credit_card_transaction.nil?

        transaction = bill_one.financial_transactions.create!(
          amount: -amount_to_refund,
          date: hotel.active_business_date,
          currency_code_id: hotel.default_currency.andand.id,
          charge_code_id: txn.charge_code_id,
          time: hotel.current_time
        )
        if transaction
          FinancialTransaction.record_action(transaction, :CREATE_TRANSACTION, :WEB, hotel.id)
          transaction.set_cashier_period
          transaction.record_details({comments: "No deposit refund on reservation cancellation."})
        end
      end
    # If we don't opt the refund, then post that amount with the rate charge code so that balance becomes 0
    else
      transaction = bill_one.financial_transactions.create!(amount: (current_cc_payments.to_f),
        date: hotel.active_business_date,
        currency_code_id: hotel.default_currency.andand.id,
        charge_code_id: rate_charge_code.andand.id,
        time: hotel.current_time) unless (current_cc_payments.to_f == 0)
      if transaction
        FinancialTransaction.record_action(transaction, :CREATE_TRANSACTION, :WEB, hotel.id)
        transaction.set_cashier_period
        transaction.record_details({comments: "No deposit refund on reservation cancellation."})
      end
    end
  end

  def refund_deposits_to_cc(credit_card, refund_amount, is_terminal = false)
     credit_card_transaction = nil
     begin
       if hotel.payment_gateway == 'sixpayments'
         settlement = SixPayment::ThreeCIntegra::Processor::Settlement.new(hotel, credit_card)
         credit_card_transaction = settlement.process({
           :amount => refund_amount,
           :type   => is_terminal ? 'refund_terminal' : 'refund',
           :currency_code => hotel.default_currency.andand.value
         })
       elsif hotel.payment_gateway == 'MLI'
         refund = MerchantLink::Lodging::Processor::Refund.new(hotel)
         if refund_amount > 0
           refund_amount = refund_amount * -1
         end
         guest_name = credit_card.card_name.present? ? credit_card.card_name : (primary_guest.nil? ? 'TEST' : primary_guest.first_name)
         
         credit_card_transaction = refund.process({
           :payment_method => credit_card,
           :amount         => refund_amount,
           :guest_name     => guest_name
         })
       end
     end unless credit_card.nil?
     return credit_card_transaction
  end

  #Method to find conficting routes exists across a reservation and accounts
  def has_conflicting_routes(first_account,second_account = nil)


   has_conflicting_charge_codes = false
   has_conflicting_charge_codes =  !(first_account.default_account_routings.for_hotel(hotel).map(&:charge_code_id).compact & second_account.default_account_routings.for_hotel(hotel).map(&:charge_code_id).compact).empty? ||
     !(first_account.default_account_routings.for_hotel(hotel).map(&:billing_group_id).compact & second_account.default_account_routings.for_hotel(hotel).map(&:billing_group_id).compact).empty? if first_account.present? && second_account.present?

   has_conflicting_charge_codes ||= !(charge_routings.map(&:charge_code_id).compact & first_account.default_account_routings.for_hotel(hotel).map(&:charge_code_id)).empty? ||
   !(charge_routings.map(&:billing_group_id).compact & first_account.default_account_routings.for_hotel(hotel).map(&:billing_group_id).compact).empty? if first_account.present?

   has_conflicting_charge_codes ||= !(charge_routings.map(&:charge_code_id).compact & second_account.default_account_routings.for_hotel(hotel).map(&:charge_code_id).compact).empty? ||
   !(charge_routings.map(&:billing_group_id).compact & second_account.default_account_routings.for_hotel(hotel).map(&:billing_group_id).compact).empty? if second_account.present?
  has_conflicting_charge_codes
  end

  def next_bill_available_for_account_routings
    available_bill = bills.where("bill_number != 1 AND account_id IS NULL").order("bill_number ASC").first
    available_bill = bills.create(bill_number: bills.last.bill_number + 1) unless available_bill.present?
    available_bill
  end

  def calculated_status
    business_date = hotel.active_business_date

    if status === :RESERVED
      if arrival_date == business_date
        label = 'reservation.status.due_in'
      else
        label = 'reservation.status.reserved'
      end
    elsif status === :CHECKEDIN
      if dep_date == business_date
        label = 'reservation.status.due_out'
      else
        label = 'reservation.status.in_house'
      end
    elsif status === :CHECKEDOUT
      label = 'reservation.status.checked_out'
    elsif status === :CANCELED
      label = 'reservation.status.canceled'
    elsif status === :NOSHOW
      label = 'reservation.status.no_show'
    end

    I18n.t(label) if label
  end

  def self.getDatetime(date, time, tz_info)
    ActiveSupport::TimeZone[tz_info].parse(date.to_s + ' ' + time.to_s)
  end

  def is_early_checkin_bundled
    early_checkin_rates = hotel.early_checkin_rates.include?(current_daily_instance.rate)
    early_checkin_addons = addons.pluck(:id) & hotel.early_checkin_setups.pluck(:addon_id)
    early_checkin_rates || !early_checkin_addons.empty? || is_early_checkin_purchased
  end

  def current_early_checkin_offer
    arrived_time = Time.now.utc
    available_offer = {}
    if hotel.checkin_time.present?
      hotel.early_checkin_setups.order("start_time ASC").each do |offer|
        if arrived_time >= ActiveSupport::TimeZone[hotel.tz_info].parse(offer.start_time.in_time_zone(hotel.tz_info).strftime("%H:%M")).utc
          available_offer = {
                              normal_checkin_time: hotel.checkin_time.strftime("%l:%M %p") ,
                              early_checkin_time: ActiveSupport::TimeZone[hotel.tz_info].parse(offer.start_time.in_time_zone(hotel.tz_info).strftime("%H:%M")).strftime("%H:%M").to_s,
                              early_checkin_charge: hotel.default_currency.andand.symbol.to_s + number_to_currency(offer.charge, precision: 2,  unit: "").to_s,
                              early_checkin_offer_id: offer.id
                            } 
        end
      end
    end
    available_offer
  end

  # CICO-12567. Called to find the deposit status
  def deposit_payment_status
    business_date = hotel.active_business_date
    if self.andand.balance_deposit_amount.to_f == 0 && self.andand.financial_transactions.present? && deposit_policy
      label = "PAID"
    elsif self.andand.balance_deposit_amount.to_f > 0 && self.deposit_due_date >= business_date && deposit_policy
      label = "DUE"
    elsif self.andand.balance_deposit_amount.to_f > 0 && self.deposit_due_date < business_date && deposit_policy
      label = "PASSED"
    else
      label = "DEPOSIT_NOT_NEEDED"
    end
    label
  end
  
  def deposit_due_date
    advanced_days = self.andand.deposit_policy.andand.advance_days
    if advanced_days.nil?
      advanced_days = 0
    else
      advanced_days = advanced_days.to_i
    end
    deposit_due_date = self.arrival_date - advanced_days
  end

  def has_valid_email_address
    status = false
    if primary_guest.present? && primary_guest.email.present?
      email_regex_array = []
      email_adresses = hotel.black_listed_emails.pluck(:email)
      email_regex_array = email_adresses.map do |email|
        Regexp.new(email)
      end
      regex = Regexp.union(email_regex_array)
      
      status = !(primary_guest.email =~ regex).present?
    end
    status
  end

  private

  def get_currency_symbol(currency_code)
    Ref::CurrencyCode[currency_code].andand.symbol.to_s
  end

  # Called when creating a reservation. If the confirmation number is not already set, then get the last confirm_no
  def derive_confirm_no
    unless hotel.is_third_party_pms_configured? || confirm_no.present?
      latest_reservation = hotel.reservations.order('cast(confirm_no as unsigned) desc').first
      self.confirm_no = latest_reservation ? (latest_reservation.confirm_no.to_i + 1).to_s : '100000'
    end
  end

end
