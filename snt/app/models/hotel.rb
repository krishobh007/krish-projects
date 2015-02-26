class Hotel < ActiveRecord::Base
  # acts_as_cached
  include ActionView::Helpers::NumberHelper
  include RailsSettings::CachedExtend

  attr_accessible :code, :arr_grace_period, :checkin_bypass, :country, :checkin_time, :checkout_time, :city,
                  :dep_grace_period, :groups_count, :guests_count, :hotel_phone, :icon_content_type, :icon_file_name,
                  :icon_file_size, :latitude, :longitude, :name, :number_of_rooms, :posts_month_count,
                  :posts_today_count, :short_name, :sl_checkin_msg, :staffs_count, :state, :welcome_msg,
                  :users_attributes, :welcome_msg_detail, :zipcode, :hotel_chain,
                  :last_reservation_update, :last_reservation_filename, :hotel_brand, :street, :is_inactive, :country_id,
                  :hotel_brand_id, :hotel_chain_id, :default_currency, :default_currency_id, :main_contact_first_name,
                  :main_contact_last_name, :main_contact_email, :main_contact_phone, :tz_info, :pms_type_id, :pms_type,
                  :domain_name, :is_res_import_on, :key_system, :key_system_id, :auto_logout_delay, :hotel_from_address,
                  :late_checkout_charge_code_id, :upsell_charge_code_id, :language, :language_id, :template_logo, :day_import_freq,
                  :night_import_freq, :last_smartband_imported, :beacon_uuid_major, :is_eod_in_progress, :is_eod_manual_started,
                  :default_date_format_id, :pms_start_date, :is_external_references_import_on, :external_references_import_freq,
                  :last_external_references_update, :last_external_references_filename

  belongs_to :hotel_brand
  belongs_to :hotel_chain
  belongs_to :country
  belongs_to :late_checkout_charge_code, class_name: 'ChargeCode'
  belongs_to :upsell_charge_code, class_name: 'ChargeCode'

  # has_many :membership_types, :as => :property
  has_many :business_dates, class_name: 'HotelBusinessDate', foreign_key: :hotel_id
  has_many :late_checkout_charges
  has_many :maintenance_reasons
  has_many :floors
  has_many :printer_templates
  has_many :billing_groups, class_name: 'BillingGroup'
  has_many :hotels_payment_types
  has_many :payment_types, through: :hotels_payment_types
  has_many :hotels_credit_card_types
  has_many :credit_card_types, through: :hotels_credit_card_types
  has_many :black_listed_emails
  # has_and_belongs_to_many :payment_types, uniq: true, class_name: 'PaymentType', join_table: 'hotels_payment_types', association_foreign_key: 'payment_type_id'
  has_many :guests, class_name: 'Reservation', through: :users
  has_many :reservations, dependent: :destroy, inverse_of: :hotel
  has_many :daily_instances, through: :reservations
  has_many :external_mappings
  has_many :items
  has_many :posts, class_name: 'SbPost'
  has_many :groups
  has_many :booking_origins
  has_many :upsell_amounts
  has_many :room_types
  has_many :rooms
  has_many :late_checkout_charges
  has_many :rates
  has_many :room_rates, through: :rates
  has_many :departments
  has_many :roles, through: :hotels_roles
  has_many :hotels_roles
  has_many :charge_codes
  has_many :addons
  has_many :charge_groups
  has_many :actions
  has_many :user_activities
  has_many :web_checkin_staff_alert_emails
  has_many :web_checkout_staff_alert_emails
  has_many :sources
  has_many :hotels_restriction_types
  has_many :restriction_types, through: :hotels_restriction_types
  has_many :market_segments
  has_many :rate_restrictions
  has_many :room_rate_restrictions
  has_many :inventory_details
  has_many :sell_limits
  has_many :occupancy_targets
  has_many :hotel_messages
  has_many :policies
  has_many :staff_alert_emails
  has_many :hotel_email_templates
  has_many :email_templates, through: :hotel_email_templates
  has_many :beacons
  has_many :promotions
  has_many :work_types
  has_many :shifts
  has_many :daily_instances, through: :reservations
  has_many :pre_checkin_excluded_rate_codes
  has_many :pre_checkin_excluded_block_codes
  has_many :cms_components
  has_many :key_encoders
  has_many :ar_transactions
  has_many :early_checkin_setups
  has_many :analytics_setups
  has_many :campaigns
  has_and_belongs_to_many :early_checkin_rates, uniq: true, class_name: 'Rate', join_table: 'hotels_early_checkin_rates', association_foreign_key: 'rate_id'
  has_and_belongs_to_many :early_checkin_groups, uniq: true, class_name: 'Group', join_table: 'hotels_early_checkin_groups', association_foreign_key: 'group_id'

  has_one :guest_bill_print_setting

  has_and_belongs_to_many :membership_types, uniq: true, class_name: 'MembershipType', join_table: 'hotels_membership_types'
  has_and_belongs_to_many :users, uniq: true
  has_and_belongs_to_many :review_categories, uniq: true, class_name: 'Ref::ReviewCategory', join_table: 'hotel_review_categories', association_foreign_key: 'ref_review_category_id'
  has_and_belongs_to_many :payment_types, uniq: true, class_name: 'PaymentType', join_table: 'hotels_payment_types', association_foreign_key: 'payment_type_id'
  has_and_belongs_to_many :credit_card_types, uniq: true, class_name: 'Ref::CreditCardType', join_table: 'hotels_credit_card_types', association_foreign_key: 'ref_credit_card_type_id'
  has_and_belongs_to_many :reservation_types, uniq: true, class_name: 'Ref::ReservationType', join_table: 'hotels_reservation_types', association_foreign_key: 'ref_reservation_type_id'
  has_and_belongs_to_many :features, uniq: true, class_name: 'Feature', join_table: 'hotels_features', association_foreign_key: 'feature_id'
  has_and_belongs_to_many :feature_types, uniq: true, join_table: 'hotels_feature_types' , association_foreign_key: 'feature_type_id'
  has_and_belongs_to_many :rate_types, uniq: true, join_table: 'hotels_rate_types', association_foreign_key: 'rate_type_id'
  has_and_belongs_to_many :active_memberships, uniq: true, class_name: 'MembershipType', join_table: 'hotels_membership_types'
  
  has_many :work_type_tasks, through: :work_types, source: :tasks
  
  has_enumerated :pms_type, class_name: 'Ref::PmsType'
  has_enumerated :default_currency, class_name: 'Ref::CurrencyCode'
  has_enumerated :default_date_format, class_name: 'Ref::DateFormat'
  has_enumerated :key_system, class_name: 'Ref::KeySystem'
  has_enumerated :language, class_name: 'Ref::Language'

  accepts_nested_attributes_for :users

  # Clear the coordinates and geocode the address into lat/lng if the address changed
  before_validation :clear_coordinates, :geocode if :address_changed?

  validates :language_id, presence: true

  # Informs the geocoder gem to lookup the latitude/longitude using the address
  geocoded_by :address

  # Server Code Migration WorkAround
  after_create :set_hotels_roles

  # If hotel deleted, the hotel.is_inactive = true
  scope :active, -> { where(is_inactive: false) }

  attr_accessible :icon
  has_attached_file :icon, styles: { medium: '300x300>', thumb: '100x100>' }, path: ':hotel_prefix/:class/:id/:attachment/:style/:filename',  default_url: '/assets/logo.png'
  has_attached_file :template_logo, styles: { medium: '300x300>', thumb: '100x100>' }, path: ':hotel_prefix/:class/:id/:attachment/:style/:filename',  default_url: '/assets/logo.png'

  # validation for mandatory
  validates :name, :code, presence: true, uniqueness: { case_sensitive: false }

  validates :street, :city, :country, :hotel_chain_id, :default_currency_id, :hotel_phone, :tz_info, :auto_logout_delay,
            :main_contact_first_name, :main_contact_last_name, :main_contact_email, :main_contact_phone, :day_import_freq, :night_import_freq, :default_date_format_id,
            presence: true

  validate :validate_address

  validates :auto_logout_delay, numericality: { greater_than: 1 }

  validates :main_contact_email, format: { with: /\A([^@\s]+)@((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})\Z/ }
  validates :main_contact_phone, format: { with: /^\+?\(?\d+\)?[\d\-]+$/ }
  validates :hotel_from_address, format: { with: /\A([^@\s]+)@((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})\Z/ }

  validates :day_import_freq, :night_import_freq, numericality: { only_integer: true }, allow_nil: true
  validates :external_references_import_freq, presence: true, if: :is_external_references_import_on
  validates :external_references_import_freq, numericality: { only_integer: true }, allow_nil: true

  # Set the latitude and longitude to nil - should be done prior to geocoding
  def clear_coordinates
    self.latitude = nil
    self.longitude = nil
  end

  def date_format
    Setting.date_formats[default_date_format.value] || '%m-%d-%Y'
  end

  # Get the address using its components
  def address
    [street, city, state, zipcode, country.andand.name].compact.join(', ')
  end

  # Check if any of the address components have changed
  def address_changed?
    attrs = %w(street city state zipcode country_id)
    attrs.any? { |a| send "#{a}_changed?" }
  end

  def is_pre_checkin_only?
    self.settings.is_pre_checkin_only == 'true'
  end

  def current_time
    # self.active_business_date.andand.strftime('%Y-%m-%d') +
    self.active_business_date.andand.strftime('%Y-%m-%d') + ' ' +
                                     Time.now.andand.utc.strftime('%H:%M:%S')
  end

  def prev_business_date
    business_dates.where('status' => 'CLOSED').order('business_date DESC').first.andand.business_date
  end

  # Validate the address by ensuring the latitude and longitude are provided.
  def validate_address
    if !latitude.present? || !longitude.present?
      errors.add(:address, 'is invalid')
    end
  end

  # Filter by chain or brand
  scope :filter, proc { |hotel_chain_id, hotel_brand_id|
    results = scoped

    if hotel_chain_id
      results = results.where('hotel_chain_id = ?', hotel_chain_id)
    end

    if hotel_brand_id
      results = results.where('hotel_brand_id = ?', hotel_brand_id)
    end

    results = results.order('name')
  }

  def get_domain_name
    domain_name ? domain_name : hotel_chain.domain_name
  end

  def get_auto_logout_delay
    auto_logout_delay.nil? ? Setting.defaults[:default_auto_logout_delay].minutes : auto_logout_delay.minutes
  end

  # Returns hotels that have the reservation import process enabled
  scope :import_enabled, -> { includes(:hotel_chain).where('hotel_chains.batch_process_enabled = true and is_res_import_on') }
  scope :needs_export, -> { where('is_reservation_export_on = true') }
  # Returns hotels that have the external references import process enabled
  scope :external_references_import_enabled, -> { where('is_external_references_import_on') }

  # Returns hotels that need an import based on the frequency and the last time they were imported
  def self.needs_import
    utc = Time.now.utc

    Hotel.import_enabled.select do |hotel|
      Time.zone = hotel.tz_info

      now = Time.zone.now
      start_time = Time.zone.parse(Setting.import_day_start)
      end_time = Time.zone.parse(Setting.import_day_end)
      is_day = start_time < now && now < end_time

      last_reservation_update = hotel.last_reservation_update.andand.utc
      minutes_since = (utc - last_reservation_update) / 60.0 if last_reservation_update

      !last_reservation_update || (is_day && minutes_since > hotel.day_import_freq) || minutes_since > hotel.night_import_freq
    end
  end

  # Returns hotels that need an external references import based on the frequency and the last time they were imported
  def self.needs_external_references_import
    utc = Time.now.utc

    Hotel.external_references_import_enabled.select do |hotel|
      last_external_references_update = hotel.last_external_references_update.andand.utc
      minutes_since = (utc - last_external_references_update) / 60.0 if last_external_references_update
      freq = hotel.external_references_import_freq || Setting.external_references_import_freq

      !last_external_references_update || minutes_since > hotel.external_references_import_freq
    end
  end

  def self.needs_pre_checkin
    hotels = []
    Hotel.find_each do |hotel|
      hotels << hotel if hotel.is_pre_checkin_only?
    end
    hotels
  end

  # Returns hotels that need a smartband import
  def self.needs_smartband_import
    Hotel.import_enabled.select do |hotel|
      Time.zone = hotel.tz_info

      now = Time.zone.now
      last_smartband_import_date = hotel.last_smartband_imported.andand.in_time_zone(hotel.tz_info).andand.to_date

      hotel.settings.icare_enabled && (!last_smartband_import_date ||
        (last_smartband_import_date < now.to_date && now >= Time.zone.parse(hotel.settings.smartband_import_time)))
    end
  end

  # Get average review score of a hotel
  def average_review_score(req_date)
    # TODO Will save the actual value
    n = 10
    average = reservations.checked_out_before_n_days_from(req_date, n).joins(:reviews).joins('LEFT OUTER JOIN review_ratings rr ON rr.review_id = reviews.id').average(:rating)
    average ? average.round(1).to_s : nil
  end

  # Get a count of how many VIP users are checking in on the request date
  def vip_checkin_count(req_date)
    reservations.vip_only.checking_in_on_date(req_date).count
  end

  # Get the upsell target amount from the product config for this hotel
  def upsell_target_amount
    settings.upsell_target_amount
  end

  # Get the upsell target room count from the product config for this hotel
  def upsell_target_rooms
    settings.upsell_target_rooms
  end

  # Sum the total upsell revenue from all reservations with an arrival date equal to the request date and a check-in status
  def total_upsell_revenue(req_date)
    reservations.checked_in_on_date(req_date).where(is_upsell_applied: true).sum('upsell_amount')
  end

  # Count the total upsell rooms that were sold by the number of reservations with an arrival date equal to the request date and a check-in status
  def total_upsell_rooms_sold(req_date)
    reservations.checked_in_on_date(req_date).where(is_upsell_applied: true).count
  end

  # get hotel active business date
  def active_business_date
    business_dates.where('status' => 'OPEN').order('business_date DESC').first.andand.business_date
  end

  Paperclip.interpolates :hotel_prefix do |a, s|
    "#{a.instance.hotel_chain.code}/#{a.instance.code}"
  end

  def get_guest_features_hash(guest)
    {
      'newspapers' => features.newspaper.map { |f| { 'id' => f.id, 'name' => f.value } },
      'user_newspaper' => guest.preferences.newspaper.first.andand.id || '',
      'roomtype' => features.room_type.map { |f| { 'id' => f.id, 'name' => f.value } },
      'user_roomtype' => guest.preferences.room_type.first.andand.id || '',
      'room_features' => [
        {
          'values' => features.room_feature.map { |f| { 'id' => f.id, 'details' => f.value } },
          'user_selection' => guest.preferences.room_feature.map { |f| f.id }
        }
      ],
      'user_id' => guest.id,
      'preferences' => features.group(:feature_type_id).exclude_feature_type.map do |feature|
        {
          'name' => feature.feature_type.value,
          'values' => features.with_feature_type(feature.feature_type.value).map { |f| { 'id' => f.id, 'details' => f.value } }
        }
      end,
      'user_preference' => guest.preferences.map { |f| f.id }
    }
  end

  # Fetch from membership_types table for the requested hotel
  def get_available_ffps
    MembershipType.with_membership_class(:FFP)
  end

  # Fetch from membership_types table for the requested hotel
  def get_available_hlps
    MembershipType.with_membership_class(:HLP).where('(property_type = "Hotel" AND property_id=?) OR (property_type = "HotelChain" AND property_id=?)', id, hotel_chain.id)
  end

  def get_active_ffps
    membership_types.with_membership_class(:FFP)
  end

  # Fetch from membership_types table for the requested hotel
  def get_active_hlps
    membership_types.with_membership_class(:HLP)
  end

  def get_newspaper_features(selected_reservation)
    feature_hash = {}
    feature_hash ['news_papers'] =   features.newspaper.map do|news_paper|
        { 'value' => news_paper.id, 'name' => news_paper.value }
    end
    news_paper = selected_reservation.features.newspaper.first
    feature_hash ['selected_newspaper'] = news_paper.andand.id.to_s
    feature_hash
  end

  def deposit_policies
    policy_type_id = Ref::PolicyType[:DEPOSIT_REQUEST].id
    self.policies.where(policy_type_id: policy_type_id)
  end

  def cancellation_policies
    policy_type_id = Ref::PolicyType[:CANCELLATION_POLICY].id
    self.policies.where(policy_type_id: policy_type_id)
  end

  # Ows call to Getting All Room Types and Room Number
  def sync_external_room_number(room_type_code = nil)
    logger.debug 'Starting sync external room number method'

    hotel_id = id
    # Ows Call for getting Room Types and Room Number
    room_api = RoomApi.new(hotel_id)
    room_attributes = room_api.get_rooms(room_type_code)

    if room_attributes[:status]
      # From ows geting response as ['DLK','Short Desc','long Desc]=>101,['DLK','Short Desc','long Desc]=>102,
      # SO using array method to group same room type into single key and set of room numbers into arrays
      # so keys array and values array will get
      room_attributes[:data] = room_attributes[:data].group_by(&:keys).map { |k, v| { k.first => v.flat_map(&:values) } }
      begin
        ActiveRecord::Base.transaction do
          room_attributes[:data].each do |attribute|
            attribute.each do |key, value|
              room_type_found  = RoomType.find_by_room_type_and_hotel_id(key[0], hotel_id)

              if !room_type_found
                # key[0]-- Room type, Key[1]- long_description, key[2]- Short Description, key[3] - Max Occupancy,
                # key[4]- Return true/false if pseudo room type if present or not

                room_type = RoomType.create!(hotel_id: hotel_id, room_type: key[0], description: key[1],
                                             no_of_rooms: value.size, room_type_name: key[2], max_occupancy: key[3], is_pseudo: key[4], is_suite: key[5])
              else
                room_type = room_type_found
              end
            # Checking Room Type is present in the upsell_room_levels table
            # if not found will insert as new record in Level - 01.
              if room_type
                unless room_type.upsell_room_level
                  upsell_room_level = UpsellRoomLevel.create!(level: 1, room_type_id: room_type.id)
                end

              end
              value.each do |room|
                room_number_found = Room.find_by_room_no_and_hotel_id(room, hotel_id)
                if !room_number_found
                  Room.create!(room_no: room, hotel_id: hotel_id, room_type_id: room_type.id)
                else
                  room_number_found.update_attributes!(room_no: room, hotel_id: hotel_id, room_type_id: room_type.id)
                end

              end# value end

            end# attrribute end

          end# room_attributes end

        end # transaction end
        return true
      rescue ActiveRecord::RecordInvalid => ex
           logger.debug 'Hotel::sync_external_room_number()::Exception--' + ex.message
           return  false
      end
    end
  end

  def update_settings(new_settings)
    new_settings.each do |key, value|
      settings[key] = value
    end
  end

  def standalone_pms?
    !pms_type.present?
  end

  def external_pms?
    pms_type.present?
  end

  def is_third_party_pms_configured?
    pms_type.present? && settings.pms_access_url.present? && settings.pms_channel_code.present? && settings.pms_user_name.present? &&
    settings.pms_user_pwd.present? && settings.pms_hotel_code.present? && settings.pms_chain_code.present?
  end

  def late_checkout_offers
    late_checkout_charges.map do |charge|
      {
        'id' => charge.id.to_s,
        'time' => charge.extended_checkout_time.andand.strftime('%-I%p').to_s,
        'amount' => number_to_currency(charge.extended_checkout_charge.to_i, precision: 0,  unit: "").to_s
      }
    end
  end

  def has_automatic_emails_triggered?
    settings.checkin_alert_time.present? && (ActiveSupport::TimeZone[tz_info]
      .parse(settings.checkin_alert_time.in_time_zone(tz_info).strftime('%H:%M')).utc.strftime('%H:%M') < Time.now.utc.strftime('%H:%M'))
  end

  def alert_due_in_guests_on_room_status_change(rooms)
    email_template = email_templates.find_by_title("CHECKIN_EMAIL_TEMPLATE")
    logger.debug "******** started email notifications for checkin reservations after room status import ********"
    logger.debug "******** Number of rooms got ready during import : #{rooms.count} ********"
    alerted_reservations = []

    if !is_pre_checkin_only? && has_automatic_emails_triggered?
      rooms.each do |room|
        begin
         # Same room can be assigned to more than one checkin reservations in OWS
          reservation_ids = room.reservation_daily_instances.current_daily_instances(active_business_date)
                     .joins(:reservation).with_status(:RESERVED).where("reservations.arrival_date = ?",active_business_date).pluck("reservations.id").uniq

          reservations =  reservation_ids.empty? ? [] :  room.hotel.reservations.find(reservation_ids)
          logger.debug "******** number of reservations for checkin alert after room status import : #{reservations.count}    ********"

          reservations.each do |reservation|
            alert_response = reservation.is_qualified_for_checkin_alert
            if alert_response[:status]
              logger.debug "******** alerting reservation : #{reservation.confirm_no} after room status import ********"
              reservation.create_web_token_for_email
              ReservationMailer.send_guestweb_email_notification(reservation, email_template).deliver!
              alerted_reservations << reservation
              Action.record!(reservation, :EMAIL_CHECKIN, :ROVER, reservation.hotel_id)
            else
              logger.debug "******** reservation  : #{reservation.confirm_no} not qualified for checkin alert ********"
              logger.debug "******** #{alert_response[:message]} ********"
            end
          end

        # We will be doing only the generic exception handling in batch process as the product team asked
        rescue Exception=>ex
          logger.debug "**********   #{ex.message}    **********"
        end
      end

    end
  end

  def late_checkout_available?
    opted_late_checkouts = reservations.current_reservations(active_business_date).where(:is_opted_late_checkout => true).count
    settings.late_checkout_is_on && settings.late_checkout_num_allowed.to_i > opted_late_checkouts && late_checkout_charges.present?
  end

  # Imports the rates from the external pms and saves in the database
  def import_rates_from_external_pms
    now = Date.today
    status = false

    api = CodeApi.new(id)
    api_response = api.get_rate_codes

    if api_response[:status]
      status = true

      api_response[:data].each do |attributes|
        unless rates.exists?(rate_code: attributes[:code])
          rate = Rate.new(hotel_id: id, rate_name: attributes[:description], rate_desc: attributes[:description], rate_code: attributes[:code], begin_date: now)

          unless rate.save
            logger.warn "Unable to import rate #{rate.rate_name} (#{rate.rate_code}): " + rate.errors.full_messages.to_s
          end
        end
      end
    end

    status
  end

  # Imports the addons from the external pms and saves in the database
  def import_addons_from_external_pms
    status = false

    api = CodeApi.new(id)
    api_response = api.get_addons

    if api_response[:status]
      status = true
      api_response[:data].each do |attributes|

        unless addons.exists?(package_code: attributes[:package_code])
          name = attributes[:short_description].present? ? attributes[:short_description] : attributes[:description]

          addon = Addon.new(
            hotel_id: id,
            package_code: attributes[:package_code],
            name: name,
            is_included_in_rate: attributes[:is_included_in_rate],
            description: attributes[:description],
            begin_date: attributes[:begin_date],
            end_date: attributes[:end_date]
          )

          unless addon.save
            logger.warn "Unable to import addon: #{addon.name}" + addon.errors.full_messages.to_s
          end
        end
      end
    end

    status
  end


  # OWS call to import transaction code & description into 'transaction_codes' table
  def sync_external_charge_code
    logger.debug 'Starting sync external charge_code method'
    status = false

    # Ows Call for getting Room Types and Room Number
    charge_code_api = CodeApi.new(id)
    api_response = charge_code_api.get_transaction_codes

    if api_response[:status]
      status = true

      api_response[:data].each do |attributes|
        unless charge_codes.exists?(charge_code: attributes[:charge_code])
          attributes[:hotel_id] = id
          attributes[:charge_code_type] = :OTHERS

          charge_code = ChargeCode.create(attributes)
          unless charge_code
            logger.warn "Unable to save charge code #{attributes[:description]} (#{attributes[:charge_code]}): " + charge_code.errors.full_messages.to_s
          end
        end
      end
    end

    status
  end

  # External PMS Call for getting business date
  def get_business_date_from_external_pms(connection_params = nil)
    business_date_api = BusinessDateApi.new(id, connection_params)
    business_date_api.get_business_date(connection_params)
  end

  # Gets the business date from the external PMS and updates the hotel's business date if different.
  def sync_business_date_with_external_pms
    result = {}

    # Get business date from external PMS
    business_date_attributes = get_business_date_from_external_pms

    if business_date_attributes[:status]
      pms_business_date = business_date_attributes[:data].to_date
      result[:status] = true

      # If the business date matches, then do nothing
      if active_business_date == pms_business_date
        result[:message] =  'Current business date is up to date'
      else
        # Find an existing business date (there shouldn't be one)
        existing_business_date = business_dates.where(business_date: pms_business_date).first

        # Update the open business date to closed for this hotel
        business_dates.is_open.first.andand.update_attributes(status: 'CLOSED')

        # Create a new business date or update the existing one
        if !existing_business_date
          business_dates.create(status: 'OPEN', business_date: pms_business_date)
        else
          logger.warn "Found existing business date for #{existing_business_date}. This should not happen."
          existing_business_date.update_attributes(status: 'OPEN')
        end

        result[:message] = 'Current business date has been updated'

        # after change of business date call to post upsell charges for reservation
        post_upsell_charges_for_reservations(pms_business_date)

        if self.settings.do_not_update_video_checkout != "true"
          # Enable remote checkout for all due-in reservations (only applies to non-credit-cards)
          logger.debug "Updating video checkouts"
          self.enable_remote_checkout_for_due_in
        end
      end

      result[:business_date] = pms_business_date

    else
      result[:status] = false
      result[:message] = business_date_attributes[:message]
    end

    result
  end

  # Enable remote checkout for all due in reservations (only applies to non-credit-cards)
  def enable_remote_checkout_for_due_in
    reservations.due_in(active_business_date).each do |reservation|
      reservation.enable_remote_checkout
    end
  end

  def review_list
    max = settings.reviews_per_page
    Review.includes(:reservation).where('reservations.hotel_id = ?', id).order('reviews.created_at desc')
  end

  # Get available rate types ie. rate types created by hotel and system specific rate types
  def available_rate_types
    RateType.for_hotel_or_system(self.id)
  end

  def current_date
    Time.zone = tz_info
    Time.zone.now
  end

  # get all the reservations and post charges for reservations which are upsold
  def post_upsell_charges_for_reservations(new_business_date)
    if settings.upsell_is_on
      upsold_reservations = reservations.with_status(:CHECKEDIN).where(is_upsell_applied: true)
      upsold_reservations.each do |reservation|
        reservation.apply_upsell_charge_code(new_business_date, true)
      end
    end
  end

  def set_logo(raw_post_image)
    base64_data = raw_post_image.split('base64,')[1]
    file_name = "logo#{DateTime.now.strftime("%Y%m%d%H%M%S")}.png"
    image_path = Rails.root.join('public', file_name)
    File.open(image_path, 'wb') do |file|
      file.write(Base64.decode64(base64_data))
    end
    icon = File.open(image_path)
    self.icon = icon
    File.delete(image_path)
  end

  def set_template_logo(raw_post_image)
    base64_data = raw_post_image.split('base64,')[1]
    file_name = "template_logo#{DateTime.now.strftime("%Y%m%d%H%M%S")}.png"
    image_path = Rails.root.join('public', file_name)
    File.open(image_path,"wb") do |file|
      file.write(Base64.decode64(base64_data))
    end
    template_logo = File.open(image_path)
    self.template_logo = template_logo
    File.delete(image_path)
  end


  # Returns time in hotel time zone with DST also
  def utc_to_hotel_time(time)
    if time
      Time.zone = 'UTC'
      utc_time = Time.zone.parse(time.strftime('%H:%M')).to_s
      Time.zone = tz_info
      Time.zone.parse(utc_time)
    end
  end

  # Get the actual occupancy percentages for the hotel
  def occupancy_per_date(from_date, to_date)
    room_count = rooms.exclude_pseudo_and_suite.count

    inventory_details.between_dates(from_date, to_date).group(:date).sum(:sold).map do |date, sold|
      { date: date, occupancy: (sold.to_f / room_count * 100).to_f }
    end
  end

  # Get the target occupancy percentages for the hotel
  def target_per_date(from_date, to_date)
    occupancy_targets.where('? <= date and date <= ?', from_date, to_date)
  end

  def is_business_date_on_weekends
    active_business_date.present? ? active_business_date.saturday? || active_business_date.sunday? : false
  end

  # Api to be called for running end of day procedures for business date change
  def end_of_day_process
    process_date = active_business_date
     # arrival reservations not yet CHECKED IN, change the status to NO SHOW
    no_show_reservations(process_date)
    # check-out hourly reservations of the hotel which have not been checked-out
    check_out_hourly_departures(process_date) if settings.is_hourly_rate_on
    # check out any reservations which have not yet checked out
    check_out_departures(process_date)
     # post room charges, taxes, addons for inhouse guests
    post_room_charges(process_date)
     # change all inhouse room status to dirty
    change_hk_status(process_date)
    # Close all Cashiers
    close_cashiers(process_date)
    # Change business_date
    update_business_date(process_date)
    # Create Data Exports
    eod_data_exports(process_date)
    # Email Report
    email_eod_reports(process_date)
  end

  # Change reservations which are not arrived for the day to no show for the hotel
  def no_show_reservations(process_date)
    # code to make reservations no show
    # Mark NO SHOW to pre-checkin reservations and due in reservations
    noshow_reservations = self.reservations.due_in(process_date) + self.reservations.pre_checkin(process_date)

    noshow_reservations.each do |reservation|
      if reservation.status === :RESERVED
        reservation.status_id = Ref::ReservationStatus[:NOSHOW].id
        reservation.daily_instances.update_all(status_id: Ref::ReservationStatus[:NOSHOW].id)
        reservation.save!
      end
      # Update Inventory count - Based on story CICO-8604
      reservation.daily_instances.each do |daily_instance|
        if daily_instance.reservation_date != reservation.dep_date || reservation.dep_date == reservation.arrival_date
          InventoryDetail.record!(daily_instance.rate_id, daily_instance.room_type_id, self.id, daily_instance.reservation_date, false)
        end
      end
    end
  end

  # check-out hourly reservations for the hotel which have not been checked-out
  def check_out_hourly_departures(process_date)
    hotel_current_date_time = ActiveSupport::TimeZone[tz_info].parse((process_date + 1.day).to_s + ' ' + Time.now.utc.to_s)
    reservations = self.reservations.where(is_hourly: true).due_out_within_24hours(hotel_current_date_time)
    # check-out hourly reservation departures which have not been checked out
    reservations.each do |reservation|
      if reservation.status === :CHECKEDIN
        # call post payment which will post payment for each bill
        reservation.post_payment(process_date, true) if reservation.current_balance.to_i > 0
        reservation.update_checkout_details
      end
    end
  end

  # Check out reservations for the hotel which have not been checked out
  def check_out_departures(process_date)
    if self.settings.is_hourly_rate_on
      reservations = self.reservations.where(is_hourly: false)
    else
      reservations = self.reservations
    end
    # code to check out departures which have not been checked out
    reservations.due_out(process_date).each do |reservation|
      if reservation.status === :CHECKEDIN
        # call post payment which will post payment for each bill
        reservation.post_payment(process_date, true) if reservation.current_balance.to_i > 0
        reservation.update_checkout_details
      end
    end
  end

  # Post Room Charges for checked in reservations for the hotel
  def post_room_charges(process_date)
    if self.settings.is_hourly_rate_on
      reservations = self.reservations.where(is_hourly: false)
    else
      reservations = self.reservations
    end
    # code to post room charges
    reservations.in_house(process_date).each do |reservation|
      if reservation.status === :CHECKEDIN && reservation.is_advance_bill == false
        options = {
          is_eod: true,
          amount: reservation.current_daily_instance.andand.rate_amount,
          rate_id: reservation.current_daily_instance.andand.rate_id,
          bill_number: 1,
          charge_code: nil,
          post_date: process_date
        }

        reservation.post_charge(options)
        reservation.post_addon_charges(process_date, false, true)
      end
    end
  end

  # Change housekeeping status to Dirty for check in reservations for the hotel
  def change_hk_status(process_date)
    if self.settings.is_hourly_rate_on
      reservations = self.reservations.where(is_hourly: false)
    else
      reservations = self.reservations
    end
    # code to run change hk status to DIRTY if not already Dirty or OS or OO
    reservations.in_house(process_date).each do |reservation|
      if reservation.status === :CHECKEDIN
        room = reservation.current_daily_instance.andand.room
        if room
          room.hk_status = :DIRTY unless room.hk_status === :DIRTY || room.hk_status === :OO || room.hk_status === :OS
          room.save!
        end
      end
    end
  end

  # Close all the cashiers for the hotel
  def close_cashiers(process_date)
    # code to run end of day exports
    cashiers = self.users.with_cashier_role.map(&:id)
    cashier_periods = CashierPeriod.where('user_id IN (?)', cashiers).where('status = "OPEN" AND starts_at < ?', self.current_time)
    cashier_periods.each do |shift|
      options = {
        cash_submitted: 0.0,
        checks_submitted: 0.0,
        ends_at: self.current_time,
        id: shift.id,
        updater_id: nil,
        closing_balance_check: shift.total_checks_received(self) + shift.opening_balance_check,
        closing_balance_cash: shift.total_cash_received(self) + shift.opening_balance_cash
      }
      CashierPeriod.close(options)
    end
  end

  # update business date
  def update_business_date(process_date)
    # code to update business date
    # Update the open business date to closed for this hotel
    business_dates.is_open.first.andand.update_attributes(status: 'CLOSED')
    business_dates.create(status: 'OPEN', business_date: (process_date + 1))
    # after change of business date call to post upsell charges for reservation
    post_upsell_charges_for_reservations(process_date)
  end

  # run end of day exports
  def eod_data_exports(process_date)
    # code to run end of day exports
  end

  # email end of day reports
  def email_eod_reports(process_date)
    # code to send email
  end

  def month_start_date_based_on_pms_start_date
    if pms_start_date.present?
      if active_business_date.month == pms_start_date.month && active_business_date.year == pms_start_date.year
        beginning_month_date = pms_start_date
      else
        beginning_month_date = active_business_date.at_beginning_of_month
      end
    else
      beginning_month_date = active_business_date.at_beginning_of_month
    end
    beginning_month_date
  end

  def year_start_date_based_on_pms_start_date
    if pms_start_date.present?
      if active_business_date.year == pms_start_date.year
        beginning_year_date = pms_start_date
      else
        beginning_year_date = active_business_date.at_beginning_of_year
      end
    else
      beginning_year_date = active_business_date.at_beginning_of_year
    end
    beginning_year_date
  end

  def payment_gateway
    self.settings.payment_gateway.nil? ? "MLI" : self.settings.payment_gateway
  end

  # Method to check whether automatic check-in can process
  def can_run_automatic_checkin?
    start_auto_checkin_from             = self.settings.start_auto_checkin_from
    start_auto_checkin_from_prime_time  = self.settings.start_auto_checkin_from_prime_time
    auto_checkin_start_time             = ""

    start_auto_checkin_to             = self.settings.start_auto_checkin_to
    start_auto_checkin_to_prime_time  = self.settings.start_auto_checkin_to_prime_time
    auto_checkin_end_time             = ""

    return false if start_auto_checkin_from.blank? || start_auto_checkin_from_prime_time.blank? || start_auto_checkin_to.blank? || start_auto_checkin_to_prime_time.blank?

    auto_checkin_start_time = DateTime.strptime("#{start_auto_checkin_from} #{start_auto_checkin_from_prime_time} #{self.tz_info}", "%H:%M %p %Z")
    auto_checkin_end_time   = DateTime.strptime("#{start_auto_checkin_to} #{start_auto_checkin_to_prime_time} #{self.tz_info}", "%H:%M %p %Z")

    if auto_checkin_start_time > auto_checkin_end_time
      auto_checkin_end_time = auto_checkin_end_time + 1.day
    end
    
    hour_range = []
    checkin_start_time = auto_checkin_start_time
    while(checkin_start_time + 15.minutes < auto_checkin_end_time)
      hour_range << "#{checkin_start_time.hour}:#{checkin_start_time.min}"
      checkin_start_time = checkin_start_time + 15.minutes
    end
    
    current_time_in_zone = Time.now.in_time_zone(self.tz_info)
    if hour_range.include?("#{current_time_in_zone.hour}:#{current_time_in_zone.min - ( current_time_in_zone.min % 15)}") && self.settings.checkin_action == "auto_checkin"
      return true
    end
    
    return false
  end

  private

  # SERVER MIGRATION WORKAROUND - Create hotels_roles, after creating hotel.
  def set_hotels_roles
    set1 = {}
    set1[:role_id] = Role.where(name: "front_office_staff").first.id
    set1[:default_dashboard_id] =  Ref::Dashboard[:FRONT_DESK].id

    set2 = {}
    set2[:role_id] = Role.where(name: "floor_&_maintenance_staff").first.id
    set2[:default_dashboard_id] =  Ref::Dashboard[:HOUSEKEEPING].id

    set3 = {}
    set3[:role_id] = Role.where(name: "hotel_admin").first.id
    set3[:default_dashboard_id] =  Ref::Dashboard[:MANAGER].id

    hotel_roles_input = [set1, set2, set3]

    hotel_roles_input.each do |set|
      HotelsRole.create!(hotel_id: self.id, role_id: set[:role_id], default_dashboard_id: set[:default_dashboard_id])
    end
  end

end
