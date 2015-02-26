class GuestImporter
  # Create a new instance of the guest importer. Options:
  # - :ignore_vip (boolean): indicates whether the VIP flag should be updated
  def initialize(guest, hotel, options = {})
    @guest = guest
    @hotel = hotel
    @options = options
    # fail "User is not set" unless guest
  end

  def self.create_from_guest_attributes!(hotel, attributes)
    guest_detail = GuestDetail.new
    guest_detail.first_name = attributes[:first_name].to_s.strip
    guest_detail.last_name = attributes[:last_name].to_s.strip
    guest_detail.hotel_chain = hotel.hotel_chain
    guest_detail.external_id = attributes[:guest_id]
    guest_detail.passport_no = attributes[:passport_no] # Q: Why it was not there in original import

    guest_detail.save!

    guest_detail
  end

  # Sync the guest hash attributes with the user, only if they are not present. Rollback on exception.
  def sync_guest_attributes(attributes)
    GuestDetail.transaction do
      sync_guest_attributes!(attributes)
    end
  rescue ActiveRecord::RecordInvalid => e
    logger.warn "Could not save guest: #{@guest.full_name}: " + e.message
  end

  # Sync the guest hash attributes with the user.
  def sync_guest_attributes!(attributes)
    guest_keys = [:first_name, :last_name, :birthday, :passport_no, :passport_expiry]

    # Update the guest attributes
    guest_attributes = attributes.select { |key, value| guest_keys.include?(key) }

    # Only set the title if the current title is empty
    guest_attributes[:title] = attributes[:title] unless @guest.title.present?

    # Set the VIP status (unless ingoring vip updates)
    unless @options[:ignore_vip]
      exclude_vip = ExternalMapping.map_external_value(@hotel, attributes[:vip], Setting.mapping_types[:vip_exclusion])
      guest_attributes[:is_vip] = attributes[:vip].present? && exclude_vip != Setting.exclude_vip_value
    end

    unless @guest.update_attributes(guest_attributes)
      logger.warn "Could not save attributes on guest: #{@guest.full_name}: #{@guest.errors.full_messages}"
    end

    sync_addresses(attributes)
    sync_emails(attributes)
    sync_phones(attributes)
    sync_memberships(attributes)
    sync_payment_types(attributes)
    sync_preferences(attributes)

    unless @guest.save
      logger.warn "Could not create preferences on guest: #{@guest.full_name}: #{@guest.errors.full_messages}"
    end
  end

  private

  # Add addresses if none exist on account
  def sync_addresses(attributes)
    attributes[:addresses].andand.each do |address_attributes|
      address = @guest.addresses.primary.first

      if !address
        address = @guest.addresses.create(address_attributes)
        logger.warn "Could not save address on user: #{@guest.full_name}: #{address.errors.full_messages}" unless address.persisted?
      elsif !address.update_attributes(address_attributes)
        logger.warn "Could not update address on user: #{@guest.full_name}: #{address.errors.full_messages}"
      end
    end
  end

  # Add or update emails
  def sync_emails(attributes)
    attributes[:emails].andand.each do |email_attributes|
      email = @guest.emails.where(external_id: email_attributes[:external_id]).first

      # If email not found by external_id, lookup by the email itself
      email = @guest.emails.where(value: email_attributes[:value]).first unless email

      if !email
        email = @guest.contacts.create(email_attributes)
        logger.warn "Could not create email on user: #{@guest.full_name}: #{email.errors.full_messages}" unless email.persisted?
      elsif !email.update_attributes(email_attributes)
        logger.warn "Could not update email on user: #{@guest.full_name}: #{email.errors.full_messages}"
      end
      # update the primary to false of other emails if current email is primary
      @guest.emails.where('value != ?', email.value).each { |seconday_emails|
        seconday_emails.update_attribute(:is_primary, false)
        } if email.present? && email.is_primary
    end
  end

  # Add or update phones
  def sync_phones(attributes)
    attributes[:phones].andand.each do |phone_attributes|
      phone = @guest.phones.where(external_id: phone_attributes[:external_id]).first

      if !phone
        phone = @guest.contacts.create(phone_attributes)
        logger.warn "Could not create phone on user: #{@guest.full_name}: #{phone.errors.full_messages}" unless phone.persisted?
      elsif !phone.update_attributes(phone_attributes)
        logger.warn "Could not update phone on user: #{@guest.full_name}: #{phone.errors.full_messages}"
      end
    end
  end

  # Add or update memberships
  def sync_memberships(attributes)
    attributes[:memberships].andand.each do |membership_attributes|
      membership = @guest.memberships.where(external_id: membership_attributes[:external_id]).first

      membership_types = @hotel.membership_types.where(value: membership_attributes[:membership_type]) +
        @hotel.hotel_chain.membership_types.where(value: membership_attributes[:membership_type])

      membership_attributes[:membership_level_id] = MembershipLevel.where(membership_level: membership_attributes[:membership_level],
                                                                          membership_type_id: membership_types.first.andand.id).first.andand.id
      membership_attributes[:membership_type_id] = membership_types.first.andand.id
      membership_attributes[:name_on_card] = membership_attributes[:card_name]

      save_attributes = membership_attributes.except(:used_in_reservation, :card_name, :membership_level, :membership_type, :membership_class)

      if !membership
        membership = @guest.memberships.create(save_attributes)
        logger.warn "Could not create membership on user: #{@guest.full_name}: #{membership.errors.full_messages}" unless membership.persisted?
      elsif !membership.update_attributes(save_attributes)
        logger.warn "Could not update membership on user: #{@guest.full_name}: #{membership.errors.full_messages}"
      end
    end
  end

  def sync_payment_types(attributes)
    if attributes[:payment_types]
      # Hide payment types with external ids not in the current list from the guest card
      external_ids = attributes[:payment_types].map { |payment_type_attributes| payment_type_attributes[:external_id] }
      @guest.payment_methods.where('external_id is not null and external_id not in (?)', external_ids).each do |payment_method|
        unless payment_method.update_attributes!(is_primary: false)
          logger.warn "Could not update payment type on user: #{@guest.full_name}: #{payment_method.errors.full_messages}"
        end
      end

      is_primary_found = false

      # Add payment types if they don't exist. If found, make sure it is on guest card.
      attributes[:payment_types].each do |payment_type_attributes|
        # Change primary flag to false if we already found a primary
        payment_type_attributes[:is_primary] &&= !is_primary_found

        # Record that we found at least one primary credit card
        is_primary_found ||= payment_type_attributes[:is_primary]

        payment_method = @guest.payment_methods.where('external_id = ? OR mli_token = ?', payment_type_attributes[:external_id],
                                                      payment_type_attributes[:mli_token]).first

        if !payment_method
          payment_type_attributes[:is_swiped] = false

          payment_method = @guest.payment_methods.create(payment_type_attributes)

          unless payment_method.persisted?
            logger.warn "Could not create payment type on guest: #{@guest.full_name}: #{payment_method.errors.full_messages}"
          end
        else
          unless payment_method.update_attributes(payment_type_attributes)
            logger.warn "Could not update payment type on guest: #{@guest.full_name}: #{payment_method.errors.full_messages}"
          end
        end
      end
    end
  end

  # Add preferences if they don't exist
  def sync_preferences(attributes)
    attributes[:preferences].andand.each do |preference_attributes|
      feature = @hotel.features.find_by_value(preference_attributes[:preference_value])

      if feature && !@guest.preferences.exists?(feature)
        feature_type = feature.feature_type

        # If the selection type only allows one selection, remove the other selections
        if feature_type.selection_type != 'checkbox'
          existing_features = @guest.preferences.with_feature_type(feature_type.value)
          @guest.preferences -= existing_features
        end

        @guest.preferences << feature
      end
    end

    unless @guest.save
      logger.warn "Could not create preferences on guest: #{@guest.full_name}: #{@guest.errors.full_messages}"
    end
  end
end
