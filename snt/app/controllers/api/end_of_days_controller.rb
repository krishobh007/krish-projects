class Api::EndOfDaysController < ApplicationController
  before_filter :check_session
  before_filter :check_business_date
  after_filter :load_business_date_info

  def authenticate_user
    errors = []
    user_session =  UserSession.new(login: current_user.email, password: params[:password])
    unless user_session.save
      errors << I18n.t(:invalid_login)
    end
      render(json: errors, status: :unprocessable_entity) if errors.present?
  end

  def change_business_date
    current_hotel.update_attributes({:is_eod_in_progress => true, :is_eod_manual_started => true}) if !current_hotel.is_third_party_pms_configured?
    Resque.enqueue(UpdateHotelBusinessDate, current_hotel.id)
  end

end