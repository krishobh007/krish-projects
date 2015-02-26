# Story - CICO-657: This class will get/set the guest information from 3rd party PMS
class GuestApi < ConnectEngineApi
  # Get the details about the guest
  def fetch_guest(guest_id)
    @connect_api_class.fetch_guest(@hotel_id, guest_id)
  end

  # Update the guest information
  def update_guest(guest_id, user)
    @connect_api_class.update_guest(@hotel_id, guest_id, user)
  end

  def update_preferences(guest_id, preferences_to_insert, preferences_to_delete)
    @connect_api_class.update_preferences(@hotel_id, guest_id, preferences_to_insert, preferences_to_delete)
  end

  # Insert a new address
  def insert_address(guest_id, address_label, primary, street1, street2, city, state, postal_code, country)
    @connect_api_class.insert_address(@hotel_id, guest_id, address_label, primary, street1, street2, city, state, postal_code, country)
  end

  # Insert a new credit card
  def insert_credit_card(guest_id, card_type, primary, name, number, expiry_date, et2, etb, ksn, pan)
    @connect_api_class.insert_credit_card(@hotel_id, guest_id, card_type, primary, name, number, expiry_date, et2, etb, ksn, pan)
  end

  # Insert a new email
  def insert_email(guest_id, email_label, primary, email)
    @connect_api_class.insert_email(@hotel_id, guest_id, email_label, primary, email)
  end

  # Insert a new guest card
  def insert_guest_card(guest_id, membership_class, membership_type, membership_number, membership_level, member_name, expiry_date, start_date)
    @connect_api_class.insert_guest_card(@hotel_id, guest_id, membership_class, membership_type, membership_number, membership_level, member_name, expiry_date, start_date)
  end

  # Insert a new phone
  def insert_phone(guest_id, phone_type, primary, phone_number)
    @connect_api_class.insert_phone(@hotel_id, guest_id, phone_type, primary, phone_number)
  end

  # Insert a new preference
  def insert_preference(guest_id, preference_type, preference_value)
    @connect_api_class.insert_preference(@hotel_id, guest_id, preference_type, preference_value)
  end

  # Update an existing address
  def update_address(external_id, address_label, primary, street1, street2, city, state, postal_code, country)
    @connect_api_class.update_address(@hotel_id, external_id, address_label, primary, street1, street2, city, state, postal_code, country)
  end

  # Update an existing credit card
  def update_credit_card(external_id, card_type, primary, name, number, expiry_date)
    @connect_api_class.update_credit_card(@hotel_id, external_id, card_type, primary, name, number, expiry_date)
  end

  # Update an existing email
  def update_email(external_id, email_label, primary, email)
    @connect_api_class.update_email(@hotel_id, external_id, email_label, primary, email)
  end

  # Update an existing guest card
  def update_guest_card(external_id, membership_class, membership_type, membership_number, membership_level, member_name, expiry_date, start_date)
    @connect_api_class.update_guest_card(@hotel_id, external_id, membership_class, membership_type, membership_number, membership_level, member_name, expiry_date, start_date)
  end

  # Update an existing name
  def update_name(guest_id, first_name, last_name, gender, birthday, language, nationality)
    @connect_api_class.update_name(@hotel_id, guest_id, first_name, last_name, gender, birthday, language, nationality)
  end

  # Update an existing passport
  def update_passport(guest_id, passport_number, country, expiry_date)
    @connect_api_class.update_passport(@hotel_id, guest_id, passport_number, country, expiry_date)
  end

  # Update an existing phone
  def update_phone(external_id, phone_type, primary, phone_number)
    @connect_api_class.update_phone(@hotel_id, external_id, phone_type, primary, phone_number)
  end

  # Delete an existing address
  def delete_address(external_id)
    @connect_api_class.delete_address(@hotel_id, external_id)
  end

  # Delete an existing credit card
  def delete_credit_card(external_id)
    @connect_api_class.delete_credit_card(@hotel_id, external_id)
  end

  # Delete an existing email
  def delete_email(external_id)
    @connect_api_class.delete_email(@hotel_id, external_id)
  end

  # Delete an existing guest card
  def delete_guest_card(external_id)
    @connect_api_class.delete_guest_card(@hotel_id, external_id)
  end

  # Delete an existing passport
  def delete_passport(guest_id)
    @connect_api_class.delete_passport(@hotel_id, guest_id)
  end

  # Delete an existing phone
  def delete_phone(external_id)
    @connect_api_class.delete_phone(@hotel_id, external_id)
  end

  # Delete an existing preference
  def delete_preference(guest_id, preference_type, preference_value)
    @connect_api_class.delete_preference(@hotel_id, guest_id, preference_type, preference_value)
  end

  # Insert or update a privacy option
  def insert_update_privacy_option(guest_id, option_type, option_value)
    @connect_api_class.insert_update_privacy_option(@hotel_id, guest_id, option_type, option_value)
  end
end
