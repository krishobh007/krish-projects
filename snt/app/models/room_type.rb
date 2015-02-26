class RoomType < ActiveRecord::Base
  attr_accessible :hotel_id, :room_type, :description, :no_of_rooms, :max_adults, :max_children, :room_type_name, :is_pseudo, :max_occupancy,
                  :image_file_name, :image_content_type, :image_file_size, :is_suite,
                  :max_late_checkouts

  belongs_to :hotel
  has_many :rooms, :dependent => :destroy
  has_one :upsell_room_level
  
  has_many :room_type_tasks
  has_many :tasks , through: :room_type_tasks
  has_many :inventory_details

  attr_accessible :image

  validates :hotel_id, :room_type, :no_of_rooms, :room_type_name, presence: true
  validates :room_type, uniqueness: { scope: :hotel_id, case_sensitive: false }
  validates :max_occupancy, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  has_attached_file :image, styles: { medium: '300x300>', thumb: '100x100>' }, path: ':room_type_prefix/:class/:id/:attachment/:style/:filename',
                            default_url: ''

  scope :is_not_pseudo, -> { where(is_pseudo: false) }
  scope :is_not_suite, -> { where(is_suite: false) }

  scope :with_level, ->(level) { includes(:upsell_room_level).where('upsell_room_levels.level = ?', level) }

  def upsell_available?(reservation)
    get_upgrade_room_types(reservation).select { |room_type| room_type.room_nos_excluding_due_in.present? }.present?
  end

  def late_checkout_upsell_available?
    max_late_checkouts ? max_late_checkouts > late_checkout_opted_reservations.count : true
  end

  def room_type_current_daily_instances
    ReservationDailyInstance.where(reservation_date: hotel.active_business_date).where(room_type_id: id)
  end

  def late_checkout_opted_reservations
    Reservation.where('id in (?)', room_type_current_daily_instances.pluck(:reservation_id))
               .where(is_opted_late_checkout: true)
               .due_out(hotel.active_business_date)
  end

  def get_upgrade_room_types(reservation)
    upgrade_room_types = []
    # Ensure that upsell is on, the number of nights is allowed, and there is an upsell room level
    # As per CICO-7904, removed restriction for reservation in standalone pms.
    is_upsell_available = hotel.settings.upsell_is_on && reservation.status === :RESERVED &&
        (!hotel.settings.upsell_is_one_night_only ||
        reservation.total_nights == 1) && upsell_room_level
    if reservation.hotel.is_third_party_pms_configured?
      is_upsell_available &&= !reservation.is_upsell_applied?
    end

    if is_upsell_available

      # Get upsell to-levels from the current from-level
      upgrade_room_levels = hotel.upsell_amounts.where(level_from: upsell_room_level.level).pluck(:level_to)
      # Get available room types that can be upgraded to

      upgrade_room_types = hotel.room_types.is_not_pseudo
      .joins('INNER JOIN upsell_room_levels ON room_types.id = upsell_room_levels.room_type_id')
      .joins(:rooms).merge(Room.ready(hotel.settings.checkin_inspected_only))
      .where('upsell_room_levels.level IN (?) ', upgrade_room_levels)
      .order('upsell_room_levels.level')

      upgrade_room_types = upgrade_room_types.uniq
      # Get the availability from third party pms if it is configured
      if reservation.hotel.is_third_party_pms_configured?
        # Get rate code
        rate_code = reservation.current_daily_instance.rate.andand.rate_code
        # Remove room type from array if there is no availability for room type and rate code
        t4 = Time.now
        upgrade_room_types.delete_if do |room_type|
          t5 = Time.now
          !availability_check_with_external_pms(reservation, room_type.room_type, rate_code)[:status]
          puts "availability ows call -#{room_type.room_type}- #{(Time.now - t5)*1000}"
        end
        puts "Total Time for availability check -- #{(Time.now - t4)*1000}"
      else
        # send each room type and rate code combinatin for availability and it it is available then keep
        # the room type else remove the remove the room type from the list
        upgrade_room_types.delete_if do |room_type|
          !room_rate_available(reservation, room_type, hotel)
        end
      end
    end
    
    upgrade_room_types
  end

  # This method retuns available true or false for a room type and rate
  def room_rate_available(reservation, room_type, hotel)
    is_room_rate_available = true
    rate_id = reservation.current_daily_instance.rate_id
    # getting room type record for room type id
    @room_types = RoomType.find(room_type.id)
    # getting rates record for rate id
    @rates = Rate.find(rate_id) if rate_id.present?
    # For availability API calls, expecting rates and room types as array of active records
    # Make sure before sending data.
    rates_for_availability = Rate.where(id: rate_id) if rate_id.present?
    room_type_room_count = hotel.rooms.exclude_pseudo.where(room_type_id: room_type.id).group(:room_type_id).count
    options = { rates: rates_for_availability, room_types: RoomType.where(id: room_type.id),
                override_restrictions: true, room_type_room_count: room_type_room_count }
    from_date = reservation.arrival_date
    to_date = reservation.dep_date
    # get date range and call avaible function
    @dates = Kaminari.paginate_array((from_date..to_date).to_a)
    availability = Availability.new(hotel, @dates, options).process
    # Check for availability in room rates
    availability.each do |available_rate|
      is_room_rate_available = false unless available_rate[:rates].present?
      available_rate[:rates].each do |available_room_rate|
        is_room_rate_available = false unless available_room_rate[:room_rates].present?
        available_room_rate[:room_rates].each do |available|
          is_room_rate_available = false unless available[:availability] > 0
        end
      end
    end
    # return available or not
    is_room_rate_available
  end

  # get room nos for room type which are vacant, ready and not assigned to due in reservation
  def room_nos_excluding_due_in
    rooms.ready(hotel.settings.checkin_inspected_only).select { |room| !room.is_due_in? }
  end

  # Avaialability Check with the external PMS using room type and rate code. Returns the status.
  def availability_check_with_external_pms(reservation, room_type, rate_code)
    result = { status: false }
    if reservation.external_id
      availability_api = AvailabilityApi.new(hotel_id)
      # Call availability with room type and rate code
      availability_attributes = availability_api.availability(reservation.arrival_date, reservation.dep_date, room_type, rate_code,
                                                              reservation.promotion_code)
      result[:status] = true if availability_attributes && availability_attributes[:status]
    else
      result[:status] = false
      logger.warn "Invalid external ID for reservation #{reservation.id}"
    end

    result
  end

  def image_from_base64=(base64_data)
    file_name = "image#{DateTime.now.strftime("%Y%m%d%H%M%S")}.png"
    image_path = Rails.root.join('public', file_name)
    File.open(image_path, 'wb') do |file|
      file.write(ActiveSupport::Base64.decode64(base64_data))
    end
    image = File.open(image_path)
    self.image = image
    File.delete(image_path)
  end

  Paperclip.interpolates :room_type_prefix do |a, s|
    "#{a.instance.hotel.hotel_chain.code}/#{a.instance.hotel.code}"
  end

  # private
  # def get_default_room_type_image
    # request = Thread.current[:current_request]
    # image_url =  request.protocol + request.host_with_port + "/assets/default_room_type.jpg"
    # image_url
  # end
end
