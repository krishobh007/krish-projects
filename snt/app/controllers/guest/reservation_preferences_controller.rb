class Guest::ReservationPreferencesController < ApplicationController
  before_filter :check_session

  # Method to Add/Delete Reservation newspaper feature
  def add_reservation_newspaper_preference
    data = {}
    newspaper_feature = Feature.find(params[:selected_newspaper]) if params[:selected_newspaper].present?
    selected_reservation = Reservation.find(params[:reservation_id])

    old_feature = selected_reservation.features.newspaper.first

    if old_feature || !params[:selected_newspaper]
      selected_reservation.features.delete(old_feature)
    end
    data = {
      'id' => newspaper_feature.present? ? newspaper_feature.id.to_s : '',
      'value' => newspaper_feature.present? ? newspaper_feature.value : ''
    }
    selected_reservation.features << newspaper_feature if newspaper_feature
    render json: { status: 'success', data: data, errors: [] }
  end
end
