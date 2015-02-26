class LoginController < ApplicationController
  layout false
  def new
    received_base_url = root_url
    uri = URI.parse(received_base_url)
    received_mapping_url = "#{uri.scheme}://#{uri.host}/"
    mapping_url = UrlMapping.where('url = ?', received_mapping_url).first
    if session[:activation_period_expired]
      flash[:error] = session[:activation_period_expired]
      session.delete(:activation_period_expired)
    end
    if current_user
      if current_user.admin?
        redirect_to admin_root_path
      elsif current_user.hotel_staff? || current_user.hotel_admin?
        redirect_to staff_root_path
      end
      else
        if mapping_url.present?
          if mapping_url.hotel_chain.present?
            session[:hotel_chain_id] = mapping_url.hotel_chain.id
          end
        end
    end
  end

  def create
    errors, redirect_url, token   =  [], '', ''
    if !params[:email].present? && !params[:password].present?
      errors << I18n.t(:missing_credentials)
      resultant_response = {status: FAILURE, errors: errors }
    elsif !params[:email].present? && params[:password].present?
      errors << I18n.t(:missing_email)
      resultant_response = {status: FAILURE, errors: errors }
    elsif params[:email].present? && !params[:password].present?
      errors << I18n.t(:missing_password)
      resultant_response = {status: FAILURE, errors: errors }
    elsif params[:is_kiosk]
       resultant_response = User.authenticate_guest(params)
       resultant_response = {status: resultant_response[:status] ? SUCCESS : FAILURE, data: resultant_response[:status] ? {access_token: resultant_response[:data].andand.session_id } : {}, errors: resultant_response[:errors] }
    else
      resultant_response = User.authenticate(params[:email], params[:password])
      resultant_response = resultant_response ? resultant_response:  {status: errors.empty? ? SUCCESS : FAILURE, data: {redirect_url: redirect_url, token: token }, errors: errors }
    end
    render json: resultant_response
  end
end
