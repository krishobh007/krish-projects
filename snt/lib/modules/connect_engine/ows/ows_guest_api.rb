class OwsGuestApi
  # Fetch the guest information from OWS
  def self.fetch_guest(hotel_id, guest_id)
    name_service = OwsNameService.new(hotel_id)

    message = OwsMessage.new
    message.append_guest_id(guest_id)
    message.append_use_vault(hotel_id)

    # Calling the Fetch Profile API in SOAP
    name_service.fetch_profile message, '//FetchProfileResponse', lambda { |operation_response|
      OwsCommonApi.parse_guest_response(hotel_id, operation_response.xpath('ProfileDetails'))
    }
  end

  # Update guest profile if the user information changed
  def self.update_guest(hotel_id, guest_id, guest_detail)
    name_service = OwsNameService.new(hotel_id)
    hotel = Hotel.find(hotel_id)

    # Update the name information if it changed
    if guest_detail.first_name_changed? || guest_detail.last_name_changed? || guest_detail.birthday_changed? || guest_detail.nationality_changed?
      message = OwsMessage.new
      message.append_guest_id(guest_id)
      message.append_name(guest_detail.first_name, guest_detail.last_name)
      message.append_gender(guest_detail.gender) if guest_detail.gender_changed?
      message.append_birthday(guest_detail.birthday) if guest_detail.birthday_changed?
      # message.append_language(guest_detail.language.andand.value) if guest_detail.language_id_changed?
      message.append_nationality(ExternalMapping.map_value(hotel, guest_detail.nationality, Setting.mapping_types[:nationality])) if guest_detail.nationality_changed?

      name_service.update_name message, '//UpdateNameResponse'
    end

    # Update passport information if it changed
    if (guest_detail.passport_no_changed? || guest_detail.passport_expiry_changed? || guest_detail.nationality_changed?) && guest_detail.passport_no && guest_detail.passport_expiry && guest_detail.nationality
      message = OwsMessage.new
      message.append_guest_id(guest_id)
      message.append_passport(guest_detail.passport_no, ExternalMapping.map_value(hotel, guest_detail.nationality, Setting.mapping_types[:nationality]), guest_detail.passport_expiry)

      name_service.update_passport message, '//UpdatePassportResponse'
    end

    # Insert, update, or delete primary address information if it changed
    address = guest_detail.addresses.select { |a| a.is_primary }.first

    if address
      mapped_address_label = ExternalMapping.map_value(hotel, address.label.value, Setting.mapping_types[:address_type])

      if !address.new_record? && address.external_id
        message = OwsMessage.new
        message.append_address(mapped_address_label, address.is_primary, address.street1, address.street2, address.city, address.state, address.postal_code, address.country.andand.code, address.external_id)

        name_service.update_address message, '//UpdateAddressResponse'
      elsif address.new_record? || address.external_id.nil?
        message = OwsMessage.new
        message.append_guest_id(guest_id)
        message.append_address(mapped_address_label, address.is_primary, address.street1, address.street2, address.city, address.state, address.postal_code, address.country.andand.code)

        result = name_service.insert_address message, '//InsertAddressResponse'

        # Set external id if successful
        address.external_id = result[:external_id] if result[:external_id]
      end
    end

    # Insert or update email information if it changed
    email = guest_detail.contacts.select { |c| c.is_primary && c.contact_type === :EMAIL }.first

    if email
      
      mapped_email_label = ExternalMapping.map_value(hotel, email.label.value, Setting.mapping_types[:email_type])

      if email.marked_for_destruction?
        message = OwsMessage.new
        message.append_email_id(email.external_id)

        name_service.delete_email message, '//DeleteEmailResponse'
      elsif !email.new_record? && email.external_id
        message = OwsMessage.new
        message.append_email(mapped_email_label, email.is_primary, email.value, email.external_id)

        name_service.update_email message, '//UpdateEmailResponse'
      elsif email.new_record? || email.external_id.nil?
        message = OwsMessage.new
        message.append_guest_id(guest_id)
        message.append_email(mapped_email_label, email.is_primary, email.value)

        result = name_service.insert_email message, '//InsertEmailResponse'

        # Set external id if successful
        email.external_id = result[:external_id] if result[:external_id]
      end
    end

    # Insert or update home phone information if it changed
    phone = guest_detail.contacts.select { |c| c.label === :HOME && c.contact_type === :PHONE }.first

    if phone
      mapped_phone_label = ExternalMapping.map_value(hotel, phone.label.value, Setting.mapping_types[:phone_type])

      if phone.marked_for_destruction?
        message = OwsMessage.new
        message.append_phone_id(phone.external_id)

        name_service.delete_phone message, '//DeletePhoneResponse'
      elsif !phone.new_record? && phone.external_id
        message = OwsMessage.new
        message.append_phone(mapped_phone_label, phone.is_primary, phone.value, phone.external_id)

        name_service.update_phone message, '//UpdatePhoneResponse'
      elsif phone.new_record?  || phone.external_id.nil?
        message = OwsMessage.new
        message.append_guest_id(guest_id)
        message.append_phone(mapped_phone_label, phone.is_primary, phone.value)

        result = name_service.insert_phone message, '//InsertPhoneResponse'

        # Set external id if successful
        phone.external_id = result[:external_id] if result[:external_id]
      end
    end

    # Insert or update mobile phone information if it changed
    mobile = guest_detail.contacts.select { |c| c.label === :MOBILE && c.contact_type === :PHONE }.first

    if mobile
      mapped_mobile_label = ExternalMapping.map_value(hotel, mobile.label.value, Setting.mapping_types[:phone_type])

      if mobile.marked_for_destruction?
        message = OwsMessage.new
        message.append_phone_id(mobile.external_id)

        name_service.delete_phone message, '//DeletePhoneResponse'
      elsif !mobile.new_record? && mobile.external_id
        message = OwsMessage.new
        message.append_phone(mapped_mobile_label, mobile.is_primary, mobile.value, mobile.external_id)

        name_service.update_phone message, '//UpdatePhoneResponse'
      elsif mobile.new_record? || mobile.external_id.nil?
        message = OwsMessage.new
        message.append_guest_id(guest_id)
        message.append_phone(mapped_mobile_label, mobile.is_primary, mobile.value)

        result = name_service.insert_phone message, '//InsertPhoneResponse'

        # Set external id if successful
        mobile.external_id = result[:external_id] if result[:external_id]
      end
    end
  end

  # Update the user preferences
  def self.update_preferences(hotel_id, guest_id, preferences_to_insert, preferences_to_delete)
    name_service = OwsNameService.new(hotel_id)
    hotel = Hotel.find(hotel_id)

    # Delete removed preferences
    preferences_to_delete.each do |preference|
      mapped_preference_type = ExternalMapping.map_value(hotel, preference[:type], Setting.mapping_types[:preference_type], false)
      mapped_preference_value = ExternalMapping.map_value(hotel, preference[:value], Setting.mapping_types[:preference_value], false)

      if mapped_preference_type && mapped_preference_value
        message = OwsMessage.new
        message.append_guest_id(guest_id)
        message.append_preference(hotel_id, mapped_preference_type, mapped_preference_value)

        name_service.delete_preference message, '//DeletePreferenceResponse'
      end
    end

    # Insert new preferences
    preferences_to_insert.each do |preference|
      mapped_preference_type = ExternalMapping.map_value(hotel, preference[:type], Setting.mapping_types[:preference_type], false)
      mapped_preference_value = ExternalMapping.map_value(hotel, preference[:value], Setting.mapping_types[:preference_value], false)

      if mapped_preference_type && mapped_preference_value
        message = OwsMessage.new
        message.append_guest_id(guest_id)
        message.append_preference(hotel_id, mapped_preference_type, mapped_preference_value)

        name_service.insert_preference message, '//InsertPreferenceResponse'
      end
    end
  end

  # Insert a new address
  def self.insert_address(hotel_id, guest_id, address_label, primary, street1, street2, city, state, postal_code, country)
    name_service = OwsNameService.new(hotel_id)
    hotel = Hotel.find(hotel_id)

    mapped_address_label = ExternalMapping.map_value(hotel, address_label, Setting.mapping_types[:address_type])

    message = OwsMessage.new
    message.append_guest_id(guest_id)
    message.append_address(mapped_address_label, primary, street1, street2, city, state, postal_code, country)

    name_service.insert_address message, '//InsertAddressResponse'
  end

  # Insert a new credit card
  def self.insert_credit_card(hotel_id, guest_id, card_type, primary, name, mli_token, expiry_date, et2, etb, ksn, pan)
    name_service = OwsNameService.new(hotel_id)
    hotel = Hotel.find(hotel_id)

    mapped_card_type = ExternalMapping.map_value(hotel, card_type, Setting.mapping_types[:credit_card_type])

    message = OwsMessage.new
    message.append_guest_id(guest_id)
    message.append_credit_card(hotel_id, mapped_card_type, primary, name, mli_token, expiry_date, et2, etb, ksn, pan)

    name_service.insert_credit_card message, '//InsertCreditCardResponse'
  end

  # Insert a new email
  def self.insert_email(hotel_id, guest_id, email_label, primary, email)
    name_service = OwsNameService.new(hotel_id)
    hotel = Hotel.find(hotel_id)

    mapped_email_label = ExternalMapping.map_value(hotel, email_label, Setting.mapping_types[:email_type])

    message = OwsMessage.new
    message.append_guest_id(guest_id)
    message.append_email(mapped_email_label, primary, email)

    name_service.insert_email message, '//InsertEmailResponse'
  end

  # Insert a new guest card
  def self.insert_guest_card(hotel_id, guest_id, membership_class, membership_type, membership_number, membership_level, member_name, expiry_date, start_date)
    name_service = OwsNameService.new(hotel_id)
    hotel = Hotel.find(hotel_id)

    mapped_membership_class = ExternalMapping.map_value(hotel, membership_class, Setting.mapping_types[:membership_class])
    mapped_membership_type = ExternalMapping.map_value(hotel, membership_type, Setting.mapping_types[:membership_type])

    message = OwsMessage.new
    message.append_guest_id(guest_id)
    message.append_guest_card(mapped_membership_class, mapped_membership_type, membership_number, membership_level, member_name, expiry_date, start_date)

    name_service.insert_guest_card message, '//InsertGuestCardResponse'
  end

  # Insert a new phone
  def self.insert_phone(hotel_id, guest_id, phone_label, primary, phone_number)
    name_service = OwsNameService.new(hotel_id)
    hotel = Hotel.find(hotel_id)

    mapped_phone_label = ExternalMapping.map_value(hotel, phone_label, Setting.mapping_types[:phone_type])

    message = OwsMessage.new
    message.append_guest_id(guest_id)
    message.append_phone(mapped_phone_label, primary, phone_number)

    name_service.insert_phone message, '//InsertPhoneResponse'
  end

  # Insert a new preference
  def self.insert_preference(hotel_id, guest_id, preference_type, preference_value)
    name_service = OwsNameService.new(hotel_id)
    hotel = Hotel.find(hotel_id)

    mapped_preference_type = ExternalMapping.map_value(hotel, preference_type, Setting.mapping_types[:preference_type])
    mapped_preference_value = ExternalMapping.map_value(hotel, preference_value, Setting.mapping_types[:preference_value])

    message = OwsMessage.new
    message.append_guest_id(guest_id)
    message.append_preference(hotel_id, mapped_preference_type, mapped_preference_value)

    name_service.insert_preference message '//InsertPreferenceResponse'
  end

  # Update an existing address
  def self.update_address(hotel_id, external_id, address_label, primary, street1, street2, city, state, postal_code, country)
    name_service = OwsNameService.new(hotel_id)
    hotel = Hotel.find(hotel_id)

    mapped_address_label = ExternalMapping.map_value(hotel, address_label, Setting.mapping_types[:address_type])

    message = OwsMessage.new
    message.append_address(mapped_address_label, primary, street1, street2, city, state, postal_code, country, external_id)

    name_service.update_address message, '//UpdateAddressResponse'
  end

  # Update an existing credit card
  def self.update_credit_card(hotel_id, external_id, card_type, primary, name, mli_token, expiry_date)
    name_service = OwsNameService.new(hotel_id)
    hotel = Hotel.find(hotel_id)

    mapped_card_type = ExternalMapping.map_value(hotel, card_type, Setting.mapping_types[:credit_card_type])

    message = OwsMessage.new
    message.append_credit_card(hotel_id, mapped_card_type, primary, name, mli_token, expiry_date, nil, nil, nil, external_id)

    name_service.update_credit_card message, '//UpdateCreditCardResponse'
  end

  # Update an existing email
  def self.update_email(hotel_id, external_id, email_label, primary, email)
    name_service = OwsNameService.new(hotel_id)
    hotel = Hotel.find(hotel_id)

    mapped_email_label = ExternalMapping.map_value(hotel, email_label, Setting.mapping_types[:email_type])

    message = OwsMessage.new
    message.append_email(mapped_email_label, primary, email, external_id)

    name_service.update_email message, '//UpdateEmailResponse'
  end

  # Update an existing guest card
  def self.update_guest_card(hotel_id, external_id, membership_class, membership_type, membership_number, membership_level, member_name, expiry_date, start_date)
    name_service = OwsNameService.new(hotel_id)
    hotel = Hotel.find(hotel_id)

    mapped_membership_class = ExternalMapping.map_value(hotel, membership_class, Setting.mapping_types[:membership_class])
    mapped_membership_type = ExternalMapping.map_value(hotel, membership_type, Setting.mapping_types[:membership_type])

    message = OwsMessage.new
    message.append_guest_card(mapped_membership_class, mapped_membership_type, membership_number, membership_level, member_name, expiry_date, start_date, external_id)

    name_service.update_guest_card message, '//UpdateGuestCardResponse'
  end

  # Update an existing name -API getting Error
  def self.update_name(hotel_id, guest_id, first_name, last_name, gender, birthday, language, nationality)
    name_service = OwsNameService.new(hotel_id)

    message = OwsMessage.new
    message.append_guest_id(guest_id)
    message.append_name(first_name, last_name)
    message.append_gender(gender)
    message.append_birthday(birthday)
    message.append_language(language)
    message.append_nationality(nationality)

    name_service.update_name message, '//UpdateNameResponse'
  end

  # Update an existing passport
  def self.update_passport(hotel_id, guest_id, passport_number, country, expiry_date)
    name_service = OwsNameService.new(hotel_id)

    message = OwsMessage.new
    message.append_guest_id(guest_id)
    message.append_passport(passport_number, country, expiry_date)

    name_service.update_passport message, '//UpdatePassportResponse'
  end

  # Update an existing phone
  def self.update_phone(hotel_id, external_id, phone_label, primary, phone_number)
    name_service = OwsNameService.new(hotel_id)

    mapped_phone_label = ExternalMapping.map_value(hotel_id, phone_label, Setting.mapping_types[:phone_type])

    message = OwsMessage.new
    message.append_phone(mapped_phone_label, primary, phone_number, external_id)

    name_service.update_phone message, '//UpdatePhoneResponse'
  end

  # Delete an existing address
  def self.delete_address(hotel_id, external_id)
    name_service = OwsNameService.new(hotel_id)

    message = OwsMessage.new
    message.append_address_id(external_id)

    name_service.delete_address message, '//DeleteAddressResponse'
  end

  # Delete an existing credit card
  def self.delete_credit_card(hotel_id, external_id)
    name_service = OwsNameService.new(hotel_id)

    message = OwsMessage.new
    message.append_credit_card_id(external_id)

    name_service.delete_credit_card message, '//DeleteCreditCardResponse'
  end

  # Delete an existing email
  def self.delete_email(hotel_id, external_id)
    name_service = OwsNameService.new(hotel_id)

    message = OwsMessage.new
    message.append_email_id(external_id)

    name_service.delete_email message, '//DeleteEmailResponse'
  end

  # Delete an existing guest card
  def self.delete_guest_card(hotel_id, external_id)
    name_service = OwsNameService.new(hotel_id)

    message = OwsMessage.new
    message.append_guest_card_id(external_id)

    name_service.delete_guest_card message, '//DeleteGuestCardResponse'
  end

  # Delete an existing passport
  def self.delete_passport(hotel_id, guest_id)
    name_service = OwsNameService.new(hotel_id)

    message = OwsMessage.new
    message.append_guest_id(guest_id)

    name_service.delete_passport message, '//DeletePassportResponse'
  end

  # Delete an existing phone
  def self.delete_phone(hotel_id, external_id)
    name_service = OwsNameService.new(hotel_id)

    message = OwsMessage.new
    message.append_phone_id(external_id)

    name_service.delete_phone message, '//DeletePhoneResponse'
  end

  # Delete an existing preference
  def self.delete_preference(hotel_id, guest_id, preference_type, preference_value)
    name_service = OwsNameService.new(hotel_id)
    hotel = Hotel.find(hotel_id)

    mapped_preference_type = ExternalMapping.map_value(hotel, preference_type, Setting.mapping_types[:preference_type])
    mapped_preference_value = ExternalMapping.map_value(hotel, preference_value, Setting.mapping_types[:preference_value])

    message = OwsMessage.new
    message.append_guest_id(guest_id)
    message.append_preference(hotel_id, mapped_preference_type, mapped_preference_value)

    name_service.delete_preference message, '//DeletePreferenceResponse'
  end

  # Fetch the guest information from OWS
  def self.insert_update_privacy_option(hotel_id, guest_id, option_type, option_value)
    name_service = OwsNameService.new(hotel_id)

    message = OwsMessage.new
    message.append_guest_id(guest_id)
    message.append_privacy_option(option_type, option_value)

    # Calling the Fetch Profile API in SOAP
    name_service.insert_update_privacy_option message, '//InsertUpdatePrivacyOptionResponse'
  end
end
