class  Staff::GuestCardsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  # Show the guest card. Fetches the data from the 3rd party PMS and creates user if necessary.
  def show
    reservation = Reservation.find(params[:id])
    guest_detail = reservation.primary_guest
    guest_id = guest_detail.external_id

    # Sync the guest attributes with the external PMS
    reservation.sync_guest_with_external_pms if current_hotel.is_third_party_pms_configured?

    contact_info = guest_detail.contact_info
    contact_info[:guest_id] = guest_id
    contact_info[:user_id] = guest_detail.id
    contact_info[:reservation_id] = reservation.id
    response = { status: SUCCESS, data: contact_info, errors: [] }
    render json: response
  end

  # Update the guest card. Called from the "Contact Information" tab.
  def update
    guest_detail = GuestDetail.find(params[:id])
    data = guest_detail.update_guest_profile(params, current_hotel)

    respond_to do |format|
      format.html
      format.json { render json: data }
    end
  end

  # Adds and removes user preferences selected from the "Likes" tab
  def update_preferences
    guest_detail = GuestDetail.find(params[:id])

    params = ActiveSupport::JSON.decode(request.body)

    guest_id = params['guest_id']

    selected_preference_params = params['preference']
    selected_preferences = selected_preference_params.map do |selected_preference|
      type = selected_preference['type']
      value = selected_preference['value']

      Feature.with_feature_type(type).where(value: value).first
    end.compact

    preferences_to_insert = []
    preferences_to_delete = []

    # Delete current preferences not in selected preferences
    guest_detail.preferences.each do |current_preference|
      type = current_preference.feature_type
      value = current_preference.value

      if selected_preferences.index { |selected_preference| selected_preference.feature_type === type && selected_preference.value == value }.nil?
        preferences_to_delete << { type: type.value, value: value }
      end
    end

    # Add selected preferences not in current preferences
    selected_preferences.each do |selected_preference|
      type = selected_preference.feature_type.value
      value = selected_preference.value

      if !guest_detail.preferences.with_feature_type(type).exists?(value: value) && type && value
        preferences_to_insert << { type: type, value: value }
      end
    end

    # Update the user's preferences to the selected ones
    guest_detail.preferences = selected_preferences

    # If we have a guest_id, update the 3rd party PMS
    if guest_id
      guest_api = GuestApi.new(current_hotel.id)
      guest_api.update_preferences(guest_id, preferences_to_insert, preferences_to_delete)
    end

    render json: { status: SUCCESS, data: [], errors: nil }
  end
end
