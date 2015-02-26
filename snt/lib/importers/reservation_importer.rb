class ReservationImporter
  # Create a new instance of the reservation importer
  def initialize(reservation, options = {})
    @reservation = reservation
    @hotel = reservation.hotel
    @hotel_chain = @hotel.hotel_chain
    @guest = reservation.primary_guest
    # if primary guest is not present find the first one of accompanying guest and make it primary
    if !@guest && !reservation.accompanying_guests.empty?
      @guest = reservation.accompanying_guests.first
    end

    hotel_details = options[:hotel_details] || ReservationImporter.hotel_details(@hotel)

    @rooms = hotel_details[:rooms]
    @room_types = hotel_details[:room_types]
    @groups = hotel_details[:groups]
    @payment_types = hotel_details[:payment_types]
    @rates = hotel_details[:rates]

    @daily_instances = Hash[reservation.daily_instances.map { |instance| [instance.reservation_date, instance] }]

    @options = options

    fail 'Reservation is not set' unless @reservation
  end

  # Obtain details about the hotel to use throughout the import process
  def self.hotel_details(hotel)
    {
      rooms: Hash[hotel.rooms.select('id, room_no, room_type_id').map { |room| [room.room_no, room] }],
      room_types: Hash[hotel.room_types.select('id, room_type').map { |room_type| [room_type.room_type, room_type] }],
      groups: Hash[hotel.groups.select('id, group_code').map { |group| [group.group_code, group] }],
      payment_types: Hash[hotel.payment_types.select('payment_types.id, payment_types.value').map { |payment_type| [payment_type.value, payment_type] }],
      rates: Hash[hotel.rates.select('id, rate_code').map { |rate| [rate.rate_code, rate] }]
    }
  end

  # Create new reservation from booking attributes
  def self.create_from_booking_attributes(hotel, hotel_details, attributes)
    Reservation.transaction do
      reservation = Reservation.new(hotel: hotel)

      # Find existing user for this reservation, or create a new one
      guest_detail = guest_for_booking_details(hotel, attributes)

      reservation.status = ExternalMapping.map_external_system_value(hotel.pms_type, attributes[:status], Setting.mapping_types[:reservation_status])
      #Clear the pre checkin flag if the reservation is already checked in
      #Put in queue will be already cleared in the import file data for a checked in reservation
      if reservation.status === :CHECKEDIN
        reservation.is_pre_checkin = false
      end
      [:arrival_date, :confirm_no, :dep_date, :cancellation_no, :cancel_date, :cancel_reason, :fixed_rate, :total_amount,
       :guarantee_type, :last_stay_room, :total_rooms, :party_code, :preferred_room_type, :print_rate, :is_walkin, :external_id, :upsell_amount,
       :departure_time].each do |attribute|

        reservation[attribute] = attributes[attribute] if attributes.key?(attribute)
      end
      if attributes[:no_post]
        reservation[:no_post] = attributes[:no_post]
      else
        reservation[:no_post] = nil
      end
      #If reservation is pre_checked in through web pre check in then do not
      #update the arrival time coming from opera since there is a chance of it being
      #overwritten from what guest had entered in pre checkin form
      if attributes[:arrival_time]
        arrival_time = ActiveSupport::TimeZone[hotel.tz_info].parse(attributes[:arrival_time]).utc
        reservation[:arrival_time] = arrival_time if !(reservation.is_pre_checkin == true)
      end

      if attributes[:is_queued]
        reservation.is_queued = attributes[:is_queued] if reservation.put_in_queue_updated_at && hotel.last_reservation_update > reservation.put_in_queue_updated_at || !reservation.put_in_queue_updated_at
      end
      # Enable no_room_move if value is present and not equal to "N"
      reservation.no_room_move = attributes[:no_room_move] != 'N' if attributes.key?(:no_room_move)
      reservation.save!

      # Add the guest detail to the reservation
      reservation.reservations_guest_details.create!(guest_detail_id: guest_detail.id, is_primary: true)

      ReservationImporter.new(reservation, hotel_details: hotel_details).sync_booking_attributes!(attributes)

      reservation
    end
  rescue ActiveRecord::RecordInvalid => e
    logger.warn "Could not save reservation with confirmation number: #{attributes[:confirm_no]}: " + e.message
    nil
  end

  # Update reservation from booking attributes
  def sync_booking_attributes(attributes)
    status = true
    logger.debug "Updating an existing reservation with confirmation number: #{@reservation.confirm_no}"

    begin
        Reservation.transaction do
        # If guest has changed, then link new guest
        raise PmsException::InvalidReservationError, "Primary guest not set." unless @guest
        if attributes[:guest][:guest_id] != @guest.andand.external_id
          logger.debug "Found new guest for reservation #{@reservation.confirm_no}: OLD #{@guest.andand.external_id}, NEW #{attributes[:guest][:guest_id]}"

          # Find existing user for this reservation, or create a new one
          guest_detail = ReservationImporter.guest_for_booking_details(@hotel, attributes)

          # Destroy the existing guest details from the reservation
          @reservation.reservations_guest_details.destroy_all

          # Add the new guest detail to the reservation
          @reservation.reservations_guest_details.create!(guest_detail_id: guest_detail.id, is_primary: true)
        end

        # Set the reservation status if we have an external mapping for it
        mapped_reservation_status = ExternalMapping.map_external_system_value(@hotel.pms_type, attributes[:status],
                                                                              Setting.mapping_types[:reservation_status])
        @reservation.status = mapped_reservation_status if mapped_reservation_status.present?
        #Clear the pre checkin flag if the reservation is already checked in
        #Put in queue will be already cleared in the import file data for a checked in reservation
        if @reservation.status === :CHECKEDIN
          @reservation.is_pre_checkin = false
        end
        # Set the following attributes if the attribute exists

        [:arrival_date, :dep_date, :cancel_reason, :cancel_date, :no_room_move, :fixed_rate, :guarantee_type,
         :total_amount, :is_rate_suppressed, :promotion_code, :departure_time].each do |attribute|
          @reservation[attribute] = attributes[attribute] if attributes.key?(attribute)
        end
        if attributes[:no_post]
          @reservation[:no_post] = attributes[:no_post]
        else
          @reservation[:no_post] = nil
        end
        #If reservation is pre_checked in through web pre check in then do not
        #update the arrival time coming from opera since there is a chance of it being
        #overwritten from what guest had entered in pre checkin form
        if attributes[:arrival_time]
          @reservation[:arrival_time] = attributes[:arrival_time] if !(@reservation.is_pre_checkin == true)
        end
        if attributes[:is_queued]
          @reservation.is_queued = attributes[:is_queued] if @reservation.put_in_queue_updated_at && @hotel.last_reservation_update > @reservation.put_in_queue_updated_at || !@reservation.put_in_queue_updated_at
        end
        @reservation[:no_room_move] = false if !@reservation[:no_room_move]

        @reservation.save!

        sync_booking_attributes!(attributes)
      end
    rescue Exception => e
      logger.warn "Could not save reservation with confirmation number: #{@reservation.confirm_no}: " + e.message
      status = false
    end

    status
  end

  # Creates or updates the daily instances, payment type, and membership from the booking attributes
  def sync_booking_attributes!(attributes)

    # Update the daily instances for the reservation including and beyond hotel's business date
    attributes[:daily_instances].each do |daily_instance_attributes|
      sync_daily_instance_booking_attributes!(daily_instance_attributes)
    end

    # Remove all daily instances outside of the arrival and departure dates
    @reservation.daily_instances.outlying.destroy_all

    # Sync user with guest attributes
    GuestImporter.new(@guest, @hotel, @options).sync_guest_attributes!(attributes[:guest]) if attributes[:guest]

    # Update payment types
    sync_payment_type_booking_attributes!(attributes[:payment_type]) if attributes[:payment_type]

    # Update memberships
    sync_membership_booking_attributes!(attributes[:membership]) if attributes[:membership]

    # Update features
    sync_feature_booking_attributes!(attributes[:features]) if attributes[:features]

    # Update addon packages
    sync_addon_packages(attributes[:packages]) if attributes[:packages]

    # Create or update routings for reservation
    sync_routing_booking_attributes!(attributes[:routings]) if attributes[:routings]

    # Create or update payment types for bills
    sync_bill_booking_attributes!(attributes[:bill_card_payment_types]) if attributes[:bill_card_payment_types]

    #Create or update accompanying guest details for reservation
    sync_accompanying_guest_attributes(attributes[:accompanying_guests]) if attributes[:accompanying_guests]

  end

  private

  # Creates a daily instance for the reservation from the booking attributes
  def sync_daily_instance_booking_attributes!(attributes)
    currency_code = ExternalMapping.map_external_system_value(@hotel.pms_type, attributes[:currency_code], Setting.mapping_types[:currency_code])

    daily_instance_attributes = {
      reservation_date: attributes[:reservation_date],
      status: @reservation.status,
      currency_code: currency_code,
      skip_uniqueness_validation: true
    }

    room_type = room_type_for_booking_attributes(attributes[:room_type_info]) if attributes.key?(:room_type_info)
    room = @rooms[attributes[:room]]

    daily_instance_attributes[:rate] = rate_for_booking_attributes(attributes[:rate_info]) if attributes.key?(:rate_info)
    daily_instance_attributes[:group] = group_for_booking_attributes(attributes[:group_info]) if attributes.key?(:group_info)
    daily_instance_attributes[:room_type] = room_type
    daily_instance_attributes[:room] = room

    if room_type && room && room.room_type != room_type
      logger.warn "Room #{room.room_no} room type of #{room.room_type.room_type} does not match #{room_type.room_type}"
    end

    [:rate_amount, :market_segment, :adults, :children, :is_from_import].each do |attribute|
      daily_instance_attributes[attribute] = attributes[attribute] if attributes.key?(attribute)
    end

    # Get the daily instance for this day
    daily_instance = @daily_instances[daily_instance_attributes[:reservation_date]]
    # Update daily instance if it exists and its date has not passed, otherwise create it
    if daily_instance
      daily_instance_attributes = daily_instance_attributes.except(:rate_amount) if daily_instance.rate_amount.present? && daily_instance_attributes[:is_from_import]
      # CICO-10104 We are excepet this flag is_from_import as its not saved in database.
      # Only used, whether rate amount comes from import file.
      daily_instance.update_attributes!(daily_instance_attributes.except(:is_from_import))
    else
      @reservation.daily_instances.create!(daily_instance_attributes.except(:is_from_import))
    end
  end

  # Creates or updates the payment type from the booking attributes
  def sync_payment_type_booking_attributes!(attributes)
    if attributes[:credit_card_type]
      payment_method = @reservation.primary_payment_method

      mapped_card_type = ExternalMapping.map_external_value(@hotel, attributes[:credit_card_type], Setting.mapping_types[:credit_card_type])

      # If not a credit card, then add as a payment type, otherwise as credit card type.
      if PaymentType.non_credit_card(@hotel).exists?(value: mapped_card_type)
        # Add cash or direct bill payment type
        if payment_method
          payment_method.update_attributes(payment_type: @payment_types[mapped_card_type], is_swiped: false, mli_token: nil, card_expiry: nil,
                                           credit_card_type: nil, card_name: attributes[:card_name], bill_number: 1)
        else
          payment_method = @reservation.payment_methods.create(payment_type: @payment_types[mapped_card_type], is_swiped: false,
                                                               card_name: attributes[:card_name], bill_number: 1)
        end
      else
        # Add credit card payment type
        # If the payment type is not saved to the reservation, create it
        if !payment_method
          payment_method = @reservation.payment_methods.create(
            payment_type: PaymentType.credit_card,
            credit_card_type: mapped_card_type,
            card_expiry: attributes[:card_expiry],
            mli_token: attributes[:mli_token],
            card_name: attributes[:card_name],
            is_primary: false,
            is_swiped: attributes[:is_swiped],
            skip_credit_card_info_validation: true,
            bill_number: 1
          )

          unless payment_method.persisted?
            logger.warn "Could not create credit card for #{@reservation.confirm_no}: #{payment_method.errors.full_messages}"
          end
        else
          # If we have an MLI token, but the current payment type does not have it set, then set it, otherwise leave it as is
          payment_method.mli_token = attributes[:mli_token] if attributes[:mli_token]

          # If new card expiry is not masked, then update the card expiry
          payment_method.card_expiry = attributes[:card_expiry] if attributes[:card_expiry].to_s.downcase.count('x') == 0
          
          payment_method.payment_type     = PaymentType.credit_card
          payment_method.credit_card_type = mapped_card_type
          # If card name is present, then update it
          payment_method.card_name = attributes[:card_name] if attributes[:card_name].present?
          payment_method.is_swiped ||= attributes[:is_swiped]
          payment_method.bill_number = 1

          payment_method.skip_credit_card_info_validation = true

          unless payment_method.save
            logger.warn "Could not update credit card for #{@reservation.confirm_no}: #{payment_method.errors.full_messages}"
          end
        end
      end

      # Delete all the payment types for bill 1 except the newly added/updated one
      @reservation.payment_methods.where('bill_number = 1 AND id != ?', payment_method.id).destroy_all if payment_method.present?

      # Destroy all invalid payment types not linked to a reservation for this guest
      @guest.destroy_invalid_payment_methods
    end
  end

  # Creates or updates the membership from the booking attributes
  def sync_membership_booking_attributes!(attributes)
    if attributes[:membership_type] && attributes[:membership_card_number]
      mapped_membership_type = ExternalMapping.map_external_value(@hotel, attributes[:membership_type], Setting.mapping_types[:membership_type])

      if attributes[:membership_class]
        mapped_membership_class = ExternalMapping.map_external_value(@hotel, attributes[:membership_class], Setting.mapping_types[:membership_class])
      end

      guest_membership_type = mapped_membership_type ? mapped_membership_type : attributes[:membership_type]

      if mapped_membership_class && Ref::MembershipClass[mapped_membership_class] && Ref::MembershipClass[mapped_membership_class].is_system_only
        membership_type = MembershipType.where('value = ? AND property_id = NULL', guest_membership_type).first
      else
        membership_type = MembershipType.where("value = ? AND ((property_id = ? AND property_type = 'HotelChain') OR (property_id = ? AND property_type = 'Hotel'))", guest_membership_type, @hotel_chain.id, @hotel.id).first
      end

      unless membership_type
        membership_class = mapped_membership_class ? mapped_membership_class : nil
        membership_class_id = membership_class ? membership_class.id : nil
        membership_type = MembershipType.create(property_id: @hotel.id, value: guest_membership_type, property_type: 'Hotel', membership_class_id: membership_class_id)
        ExternalMapping.create(
          mapping_type: Setting.mapping_types[:membership_type],
          external_value: membership_type.value,
          value: membership_type.value,
          hotel_id: @hotel.id,
          pms_type_id: @hotel.pms_type_id
        )
      end

      guest_membership = nil
      # Lookup payment type on user
      if @guest.memberships.count
        guest_membership = @guest.memberships.joins(:membership_type).where('membership_types.value = ? ', membership_type.value).where(membership_card_number: attributes[:membership_card_number]).first
      end
      # Link the membership to the reservation if it does not exist, otherwise create it
      unless guest_membership
        guest_membership = @guest.memberships.create(
          membership_type_id: membership_type.id,
          membership_card_number: attributes[:membership_card_number],
          membership_level_id: MembershipLevel.joins(:membership_type).where('membership_types.value = ? ', mapped_membership_type).where(membership_level: attributes[:membership_level]).first.andand.id,
          name_on_card: attributes[:card_name],
          membership_start_date: attributes[:membership_start_date],
          membership_expiry_date: attributes[:membership_expiry_date],
          external_id: attributes[:external_id]
        )

        logger.warn "Could not create membership for #{@reservation.confirm_no}: #{guest_membership.errors.full_messages}" unless guest_membership.persisted?
      end
      # Add the reservation membership, if it saved and is not already linked
      if guest_membership.persisted? && !@reservation.memberships.exists?(guest_membership)
        @reservation.memberships << guest_membership
      end
    end
  end

  # Creates or updates the features from the booking attributes
  def sync_feature_booking_attributes!(features)
    # If no features were received, then clear the reservation features
    @reservation.features.clear if features.empty?

    features.each do |feature_attributes|
      if feature_attributes[:type] && feature_attributes[:value]

        mapped_type = ExternalMapping.map_external_value(@hotel, feature_attributes[:type], Setting.mapping_types[:preference_type], false)
        mapped_value = ExternalMapping.map_external_value(@hotel, feature_attributes[:value], Setting.mapping_types[:preference_value], false)

        feature = @hotel.features.find_by_value(mapped_value)

        if feature && !@reservation.features.exists?(feature)
          feature_type = feature.feature_type

          # If the selection type only allows one selection, remove the other selections
          if feature_type.selection_type != 'checkbox'
            existing_features = @reservation.features.with_feature_type(feature_type.value)
            @reservation.features -= existing_features
          end

          @reservation.features << feature
        end
      end
    end
  end

  # Get the rate for the booking attributes (create if not found)
  def rate_for_booking_attributes(attributes)
    if attributes[:rate_code].present?
      rate = @rates[attributes[:rate_code]]

      # If a rate was not found, create it
      unless rate
        currency_code = ExternalMapping.map_external_system_value(@hotel.pms_type, attributes[:currency_code], Setting.mapping_types[:currency_code])

        rate = Rate.create!(
          hotel_id: @hotel.id,
          rate_name: attributes[:rate_desc],
          rate_desc: attributes[:rate_desc],
          rate_code: attributes[:rate_code],
          begin_date: Date.today,
          market_code: attributes[:market_segment],
          currency_code: currency_code
        )

        # Add new rate to cache
        @rates[attributes[:rate_code]] = rate
      end
    end

    rate
  end

  # Get the room type for the booking attributes.
  def room_type_for_booking_attributes(attributes)
    @room_types[attributes[:room_type]]
  end

  # Get the group for the booking attributes (create if not found)
  def group_for_booking_attributes(attributes)
    group_code = attributes[:code]
    if group_code
      group = @groups[group_code]
      # If a group was not found, create it, and add an external mapping for it
      if attributes[:block_name]
        if !group
          group = Group.create!(
            hotel_id: @hotel.id,
            name: attributes[:block_name],
            group_code: group_code
          )

          @groups[group_code] = group
        else
          group.update_attribute(:name, attributes[:block_name])
        end
      end
    end

    group
  end

  # Sync the addon packages
  def sync_addon_packages(packages)
    # Delete addons that are not returned by Opera
    if packages.empty?
      @reservation.reservations_addons.destroy_all
    else
      @reservation.reservations_addons.includes(:addon).where('addons.package_code NOT IN (?)', packages.map { |p| p[:package_code] }).destroy_all
    end

    # Add/update addons
    packages.each do |addon_package|
      addon = @hotel.addons.where(package_code: addon_package[:package_code]).first

      unless addon
        addon = @hotel.addons.create!(name: addon_package[:description], description: addon_package[:description], amount: addon_package[:package_amount][:amount], package_code: addon_package[:package_code], hotel_id: @hotel.id)
      end

      reservation_addon = @reservation.reservations_addons.where(addon_id: addon.id).first

      if !reservation_addon
        ReservationsAddon.create!(reservation_id: @reservation.id, addon_id: addon.id, price: addon_package[:package_amount][:amount], is_inclusive_in_rate: (addon_package[:source] === Setting.addon_type[:rate]))
      else
        reservation_addon.update_attributes(price: addon_package[:package_amount][:amount], is_inclusive_in_rate: (addon_package[:source] === Setting.addon_type[:rate]))
      end
    end
  end

  # Find guest detail from external_id or from membership number
  def self.guest_for_booking_details(hotel, attributes)
    external_id = attributes[:guest][:guest_id]

    guest_detail = GuestDetail.where(external_id: external_id, hotel_chain_id: hotel.hotel_chain_id).first

    if guest_detail
      # Set the external id if the guest detail was found
      guest_detail.external_id = external_id
      guest_detail.save!
    else
      # If no guest was found, create a new one
      guest_detail = GuestImporter.create_from_guest_attributes!(hotel, attributes[:guest])
    end

    guest_detail
  end

  # Find guest detail from external_id or from membership number
  def accompanying_guest_for_booking_details(hotel, attributes)
    external_id = attributes[:name_id]
    guest_detail = external_id.present? ? GuestDetail.where(external_id: external_id, hotel_chain_id: hotel.hotel_chain_id).first : nil
    if guest_detail
      # update the first name and last name if the guest detail was found
      guest_detail.update_attributes!(first_name: attributes[:first_name].to_s.strip, last_name: attributes[:last_name].to_s.strip)
    else
      # guest_detail = @reservation.guest_details.where(first_name: attributes[:first_name].to_s.strip, last_name: attributes[:last_name].to_s.strip).first
      # Fix for CICO-10679, to avoid guest detail create of accompanying guest with same first-name and last-name.
      guest_detail = GuestDetail.where(first_name: attributes[:first_name].to_s.strip, last_name: attributes[:last_name].to_s.strip, external_id: nil, hotel_chain_id: hotel.hotel_chain_id).first
      # If external id is not there then do the check using the first and last name
      # CICO-10362
      # It is highly unlikely that a reservation has the primary and accompanying guest with same first and last names
      guest_detail = GuestImporter.create_from_guest_attributes!(hotel, attributes) unless guest_detail
      guest_detail.update_attributes!(external_id: external_id) if external_id.present?
    end

    guest_detail
  end

  # Sync the routings on the reservation
  def sync_routing_booking_attributes!(routings)
    # As per CICO-9799, Product Team required complete sync for charge routings.
    # So removing charge routings checks and
    # removing the entry for charge routins.
    existing_routing_ids  = @reservation.charge_routings.pluck(:id)
    logger.debug "==TEST==  fetched existing routings for reservation : #{@reservation.confirm_no}"
    logger.debug "==TEST==  existing routing ids : #{existing_routing_ids}"
    ChargeRouting.where("id IN (?)", existing_routing_ids).destroy_all if existing_routing_ids.present?
    logger.debug "==TEST== after deleting - routings : #{@reservation.charge_routings.count}"
    routings.each do |routing|
      # Find the bill for the window (bill) number on this reservation
      bill = Bill.find_or_create_by_reservation_id_and_bill_number(@reservation.id, routing[:window])

      to_bill_id = nil
      room_id = nil

      # Get the "to bill" that the charge is being routed to
      if routing[:room_no].present?
        room = @rooms[routing[:room_no]]

        if room
          room_id = room.id

          # Find reservation that is checked in for this room number as of the business date
          routing_reservation = room.reservation_daily_instances.current_daily_instances(@hotel.active_business_date).joins(:reservation).with_status(:RESERVED, :CHECKEDIN).first.andand.reservation

          # Find bill for bill #1 on routing reservation
          to_bill_id = Bill.find_or_create_by_reservation_id_and_bill_number(routing_reservation.id, 1).andand.id if routing_reservation
        end
      else
        to_bill_id = bill.andand.id
        bill = Bill.find_or_create_by_reservation_id_and_bill_number(@reservation.id, 1)
      end

      ChargeRouting.create(bill_id: bill.id, to_bill_id: to_bill_id, owner_name: routing[:owner], room_id: room_id,
                              external_routing_instructions: routing[:routing_instruction])
    end

  end

  # Sync the routings on the reservation
  def sync_bill_booking_attributes!(bill_payment_methods)
    # Import bill #1 if we don't have a payment type there (non cc only)
    should_import_bill_one = @reservation.bill_payment_method(1).nil?

    bill_payment_methods.each do |bill_payment_method|
      mapped_card_type = ExternalMapping.map_external_value(@hotel, bill_payment_method[:payment_method], Setting.mapping_types[:credit_card_type])

      is_bill_number_one = bill_payment_method[:bill_number] == '1'
      is_credit_card = !PaymentType.non_credit_card(@hotel).exists?(value: mapped_card_type)

      # Do not sync bill #1 as this is handled via the guarantee tag (unless we don't already have a payment type there and its not a credit card)
      if !is_bill_number_one || (should_import_bill_one && !is_credit_card)
        payment_method = @reservation.bill_payment_method(bill_payment_method[:bill_number])

        # Setup attributes of payment type. If DB, do not set credit card type. Otherwise it is a credit card.
        attributes = {
          is_primary: false,
          is_swiped: false,
          bill_number: bill_payment_method[:bill_number]
        }

        # If credit card, set card type, otherwise set payment type
        if is_credit_card
          attributes[:payment_type] = PaymentType.credit_card
          attributes[:credit_card_type] = mapped_card_type
          attributes[:skip_credit_card_info_validation] = true
        else
          attributes[:payment_type] = @payment_types[mapped_card_type]
          attributes[:credit_card_type] = nil
          attributes[:card_name] = bill_payment_method[:card_name]
          attributes[:mli_token] = nil
          attributes[:card_expiry] = nil
        end

        # If the payment type is not saved to the user, create it
        if !payment_method
          payment_method = @reservation.payment_methods.create!(attributes)
        else
          payment_method.update_attributes!(attributes)
        end
      end
    end
  end

  # Method to Create/Update accompanying guests for a reservation
  def sync_accompanying_guest_attributes(accompanying_guest_attributes)
   @reservation.reservations_guest_details.where(is_accompanying_guest: true, is_added_from_kiosk: false).destroy_all
    accompanying_guest_attributes.each do |accompanying_guest|
      guest_detail = accompanying_guest_for_booking_details(@reservation.hotel, accompanying_guest)
      reservation_guest_detail = @reservation.reservations_guest_details.find_or_initialize_by_guest_detail_id(guest_detail.id)

      if !@reservation.primary_guest
        reservation_guest_detail.is_primary = true
        reservation_guest_detail.is_accompanying_guest = false
      elsif @reservation.primary_guest && @reservation.primary_guest.id != reservation_guest_detail.guest_detail_id
        reservation_guest_detail.is_primary = false
        reservation_guest_detail.is_accompanying_guest = true
      end
      reservation_guest_detail.save!
    end
  end
end
