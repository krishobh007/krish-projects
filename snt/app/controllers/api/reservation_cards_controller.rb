class Api::ReservationCardsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  
  GUEST = 'guest'
  COMPANY = 'company'
  TRAVEL_AGENT = 'travel_agent'

  def replace
    errors = []

    reservation = Reservation.find(params[:reservation_id])

    old_type = params[:old].andand[:type]
    new_id = params[:new].andand[:id]
    new_type = params[:new].andand[:type]

    errors << I18n.t('reservation_cards.request_invalid') unless old_type.present? && new_id.present? && new_type.present?

    if errors.empty?
      Reservation.transaction do
        if params[:change_all_reservations]
          future_reservations(reservation, old_type).each do |future_reservation|
            unlink_card!(future_reservation, old_type)
            link_card!(future_reservation, new_id, new_type)
          end
        end

        unlink_card!(reservation, old_type)
        link_card!(reservation, new_id, new_type)
      end
    end

    render(json: errors, status: :unprocessable_entity) if errors.present?
  rescue ActiveRecord::RecordInvalid => e
    render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

  def remove
    errors = []

    reservation = Reservation.find(params[:reservation_id])
    type = params[:type]

    errors << I18n.t('reservation_cards.request_invalid') unless type.present?
    errors << I18n.t('reservation_cards.one_card_required') unless reservation.card_count > 1

    if errors.empty?
      unlink_card!(reservation, type)
    else
      render(json: errors, status: :unprocessable_entity) if errors.present?
    end
  rescue ActiveRecord::RecordInvalid => e
    render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

  private

  def unlink_card!(reservation, type)
    if type == GUEST
      reservation.reservations_guest_details.destroy_all
    elsif type == COMPANY
      reservation.update_attributes!(company_id: nil)
    elsif type == TRAVEL_AGENT
      reservation.update_attributes!(travel_agent_id: nil)
    end
  end

  def link_card!(reservation, id, type)
    if type == GUEST
      reservation.reservations_guest_details.destroy_all
      reservation.reservations_guest_details.create!(guest_detail_id: id, is_primary: true)
    elsif type == COMPANY
      reservation.update_attributes!(company_id: id)
    elsif type == TRAVEL_AGENT
      reservation.update_attributes!(travel_agent_id: id)
    end
  end

  def future_reservations(reservation, type)
    business_date = reservation.hotel.active_business_date

    if type == GUEST
      reservation.primary_guest.andand.future_reservations(business_date, reservation) || []
    elsif type == COMPANY
      reservation.company.andand.future_reservations(business_date, reservation) || []
    elsif type == TRAVEL_AGENT
      reservation.travel_agent.andand.future_reservations(business_date, reservation) || []
    end
  end
end
