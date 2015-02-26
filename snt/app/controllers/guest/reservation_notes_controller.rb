class Guest::ReservationNotesController < ApplicationController
  before_filter :check_session

  # Create a reservation note
  def create
    errors = []
    reservation = Reservation.find(params[:reservation_id])
    reservation_note = reservation.notes.new
    reservation_note.note_type = :GENERAL
    reservation_note.is_guest_viewable = true
    reservation_note.description = params[:text]
    reservation_note.creator_id = current_user.id
    reservation_note.updater_id = current_user.id
    response = reservation_note.sync_note_with_external_pms(reservation) if reservation.hotel.is_third_party_pms_configured?
    errors += response[:errors]
    # Save the reservation note if no errors
    errors += reservation_note.errors.full_messages if errors.empty? && !reservation_note.save
    if errors.empty?
      render json: {
        status: SUCCESS,
        errors: [],
        data: {
          note_id: reservation_note.id,
          text: reservation_note.description,
          username: current_user.full_name,
          posted_time: reservation_note.updated_at.strftime('%I:%M%p'),
          posted_date: reservation_note.updated_at.strftime('%Y:%m:%d'),
          topic: '',
          user_image: current_user.detail ? current_user.detail.avatar.url(:thumb) : ''
        }
      }
    else
      render json: { status: FAILURE, data: {}, errors: errors }
    end
  end


end
