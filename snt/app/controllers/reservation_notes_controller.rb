# This controller handles the reservation note CRUD operations
class ReservationNotesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  # Create a reservation note
  def create
    errors, is_already_existing = [], false
    reservation = Reservation.find(params[:reservation_id])
    reservation_note = reservation.notes.new
    reservation_note.note_type =  :GENERAL
    reservation_note.is_guest_viewable =  false
    reservation_note.description =  params[:text]
    reservation_note.is_from_external_system =  false
    response = reservation_note.sync_note_with_external_pms(reservation) if reservation.hotel.is_third_party_pms_configured?
    errors += response[:errors] if reservation.hotel.is_third_party_pms_configured?
    # Save the reservation note if no errors
    reservation_note.external_id = response[:result][:data].last[:external_id] if response && response[:result] && response[:result][:status]
    Time.zone = reservation.hotel.tz_info
    reservation_note.updated_at = Time.zone.parse(reservation.hotel.andand.active_business_date.strftime('%Y-%m-%d') + ' ' +
                                    Time.zone.now.andand.strftime('%I:%M %p')).utc
   if reservation.hotel.is_third_party_pms_configured?
    unless reservation.notes.find_by_external_id(reservation_note.external_id)
      reservation_note.save
      errors += reservation_note.errors.full_messages if reservation_note.errors.present?
    else
      is_already_existing = true
    end
   else
     reservation_note.save
     errors += reservation_note.errors.full_messages if reservation_note.errors.present?
   end
    if errors.empty?
      render json: {
        status: SUCCESS,
        errors: [],
        data: {
          note_id: reservation_note.id,
          text: reservation_note.description,
          username: reservation_note.user ? reservation_note.user.andand.full_name : 'FROM PMS' ,
          is_already_existing: is_already_existing,
          posted_time: reservation_note.updated_at.andand.in_time_zone(reservation.hotel.tz_info).andand.strftime('%I:%M %p'),
          posted_date: reservation_note.updated_at.in_time_zone(reservation.hotel.tz_info).andand.strftime('%Y-%m-%d'),
          topic: '',
          user_image: current_user.detail ? current_user.detail.avatar.url(:thumb) : ''
        }
      }
    else
      render json: { status: FAILURE, data: {}, errors: errors }
    end
  end

  # Update a reservation note
  def update
    errors = []

    reservation_note = Note.find(params[:id])
    reservation = reservation_note.associated

    reservation_note.note_type = :GENERAL
    reservation_note.description = params[:text]

    if reservation.hotel.is_third_party_pms_configured?
      comments = [{ description: reservation_note.description, external_id: reservation_note.external_id }]
      result = reservation.modify_notes_of_external_pms('UPDATE', comments)

      errors << I18n.t(:external_pms_failed) unless result[:status]
    end

    # Save the reservation note if no errors
    if errors.empty? && !reservation_note.save
      errors += reservation_note.errors.full_messages
    end

    if errors.empty?
      render json: { status: SUCCESS,
                     errors: [],
                     data: {
                       note_id: reservation_note.id,
                       text: reservation_note.description,
                       username: current_user.full_name,
                       posted_time: reservation_note.updated_at.strftime('%I:%M %p'),
                       posted_date: reservation_note.updated_at.strftime('%m-%d-%Y'),
                       topic: '',
                       user_image: current_user.detail ? current_user.detail.avatar.url(:thumb) : ''
        }
      }
    else
      render json: { status: FAILURE, data: {}, errors: errors }
    end
  end

  # Delete a reservation note
  def destroy
    errors = []

    reservation_note = Note.find(params[:id])
    reservation = reservation_note.associated

    if reservation.hotel.is_third_party_pms_configured?
      comments = [{ description: reservation_note.description, external_id: reservation_note.external_id }]
      result = reservation.modify_notes_of_external_pms('DELETE', comments)

      errors << I18n.t(:external_pms_failed) unless result[:status]
    end

    if errors.empty?
      reservation_note.destroy
      render json: { status: SUCCESS, errors: [] }
    else
      render json: { status: FAILURE, errors: errors }
    end
  end
end
