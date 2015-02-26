class Admin::HouseKeepingSettingsController < ApplicationController
  before_filter :check_session
  def index
    data = {}
    data[:use_pickup] = current_hotel.settings.use_pickup
    data[:use_inspected] = current_hotel.settings.use_inspected
    data[:checkin_inspected_only] = current_hotel.settings.checkin_inspected_only
    data[:enable_room_status_at_checkout] = current_hotel.settings.enable_room_status_at_checkout
    data[:is_queue_rooms_on] = current_hotel.settings.is_queue_rooms_on
    data[:email] =  current_hotel.staff_alert_emails.queue_reservation_alerts.present? ? current_hotel.staff_alert_emails.queue_reservation_alerts.pluck(:email).join(';') : ''
    result = { status: SUCCESS, data: data, errors: [] }
    respond_to do |format|
      format.html { render partial: '/admin/house_keeping_settings/index', locals: { data: result } }
      format.json { render json: result }
    end
  end

  def create
    current_hotel.settings.use_pickup = params[:use_pickup] == 'true'
    current_hotel.settings.use_inspected = params[:use_inspected] == 'true'
    current_hotel.settings.is_inspected_only = params[:checkin_inspected_only] == 'true'
    current_hotel.settings.is_queue_rooms_on = params[:is_queue_rooms_on] == 'true'
    current_hotel.settings.enable_room_status_at_checkout = params[:enable_room_status_at_checkout] == 'true'
    staff_emails = params[:email].to_s.split(';').map(&:strip) unless params[:email].empty?
    current_hotel.staff_alert_emails.queue_reservation_alerts.destroy_all if current_hotel.settings.is_queue_rooms_on
    staff_emails.each do |staff_email|
      current_hotel.staff_alert_emails.queue_reservation_alerts.create(email: staff_email)
    end if staff_emails && current_hotel.settings.is_queue_rooms_on
    respond_to do |format|
      format.json { render json: { status: SUCCESS,  data: {}, errors: [] } }
    end
  end
end
