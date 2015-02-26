class ReservationPreferencesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  # Method to Add/Delete Reservation newspaper feature
  def add_reservation_newspaper_preference
    result = { status: false }
    changed_attributes = {}

    newspaper_feature = Feature.find(params[:selected_newspaper]) if params[:selected_newspaper].present?
    selected_reservation = Reservation.find(params[:reservation_id])

    old_features = selected_reservation.features.newspaper

    if selected_reservation.hotel.is_third_party_pms_configured?
      changed_attributes[:preferences] = [{ preference_value: newspaper_feature.andand.value, preference_type: newspaper_feature.andand.feature_type.andand.value }]
      result = selected_reservation.modify_booking_of_external_pms(changed_attributes)
    else
      result[:status] = true
    end

    if result[:status]
      selected_reservation.features -= old_features

      selected_reservation.features << newspaper_feature if newspaper_feature
      render json: { status: 'success', data: newspaper_feature, errors: [] }
    else
      render json: { status: 'failure', data: {}, errors: [] }
    end
  end
end
