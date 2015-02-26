class Admin::PmsConnectionController < ApplicationController
  before_filter :check_session

  def save_pms_connection_config
    status, data, errors = $failure_status, {}, []
    if params[:pms_timeout].present?
       if params[:pms_timeout].to_i <= 0
         errors << t(:invalid_pms_timeout)
       end
    end
    if !errors.present?
      current_hotel.settings.pms_access_url = params[:pms_access_url]
      current_hotel.settings.pms_channel_code = params[:pms_channel_code]
      current_hotel.settings.pms_user_name = params[:pms_user_name]
      current_hotel.settings.pms_user_pwd = current_hotel.hotel_chain.encrypt_pswd(params[:pms_user_pwd])
      current_hotel.settings.pms_hotel_code = params[:pms_hotel_code]
      current_hotel.settings.pms_chain_code = params[:pms_chain_code]
      current_hotel.settings.pms_timeout = (params[:pms_timeout].present? && params[:pms_timeout].to_i > 0) ? params[:pms_timeout] : Setting.defaults[:default_pms_timeout]
      status = SUCCESS
    end
    respond_to do |format|
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  def get_pms_connection_config
    status, data, errors = FAILURE, {}, []
    data = {
      pms_access_url: current_hotel.settings.pms_access_url,
      pms_channel_code: current_hotel.settings.pms_channel_code,
      pms_user_name: current_hotel.settings.pms_user_name,
      pms_user_pwd: current_hotel.hotel_chain.decrypt_pswd(current_hotel.settings.pms_user_pwd),
      pms_hotel_code: current_hotel.settings.pms_hotel_code,
      pms_chain_code: current_hotel.settings.pms_chain_code,
      pms_timeout: current_hotel.settings.pms_timeout || Setting.defaults[:default_pms_timeout]
    }
    status = SUCCESS
    respond_to do |format|
      format.html { render partial: 'admin/ows_connectivity/connectivity', locals: { data: data,  errors: errors } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  def test_pms_connection
    status, errors, data = FAILURE, [], {}
    begin
      response = current_hotel.get_business_date_from_external_pms(params)
      if response && response[:status]
        status = SUCCESS
        data = { business_date: Date.parse(response[:data]) }
      end
      render json: { status: status, errors: errors, data: data }
    rescue PmsException::ExternalPmsError
      render json: [t(:invalid_pms_connection_settings)], status: 520
    end
  end

end
