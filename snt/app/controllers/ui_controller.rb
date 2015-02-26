class UiController < ApplicationController
  # Render the mentioned haml with the JSON specified
  def show
    if params[:is_hash_map]
      data = json2symhash(params[:json_input])
    else
      json_input = File.read("#{Rails.root}/public/sample_json/#{params[:json_input]}") if params[:json_input]
      data = json_input
    end
    if params[:format] == 'json'
      render json: data
    elsif params[:is_partial]
      render partial: params[:haml_file], locals: { data: data }
    elsif params[:is_layout] == 'false'
      render params[:haml_file], locals: { data: data }, layout: false
    else
      render params[:haml_file], locals: { data: data }
    end
  end

  def updateAccountSettings
    user_name_and_email_hash = {}
    user_name_and_email_hash['name'] = 'Jon'
    user_name_and_email_hash['email'] = 'aa@kk.com'
    render partial: 'modals/updateAccountSettings', locals: { staff_settings_hash: user_name_and_email_hash }
  end

  def addKeys
    render partial: 'modals/addKeys'
  end

  # Method to call success modal
  def successModal
    render partial: 'modals/successModal'
  end

  # Method to call checkoutSuccessModal modal
  def checkoutSuccessModal
    render partial: 'modals/checkoutSuccessModal', locals: { data: current_hotel.settings.enable_room_status_at_checkout.to_s}
  end

  # Method to call failure modal
  def failureModal
    render partial: 'modals/failureModal'
  end
  
  # Method to call room assignment modal
  def roomAssignmentFailureModal
    render partial: 'modals/roomAssignmentFailureModal',locals: { data: t(:room_already_taken)}
  end
  
   # Method to call room assignment modal
  def autoRoomAssignmentModal
    render partial: 'modals/autoRoomAssignmentModal',locals: { data: t(:auto_assigned_room, room_number: params[:room])}
  end
  
  # Method to terms and conditions modal
  def terms_and_conditions
    render partial: 'modals/terms_and_conditions',locals: { data: current_hotel.settings.terms_and_conditions}
  end

  def bill_card
    @bill_card = json2hash('registration_card/registration_card.json')
    render layout: false, locals: { data: @bill_card }
  end

  # Method to call email opt modal for registration card
  def validateOptEmail
    render partial: 'modals/validateOptEmail'
  end
  
  # Method to get country list
  def country_list
     data = {}
     countries = Country.find(:all, order: 'name')
     data = countries.map do |country|
        {
          id: country.id,
          value: country.name
        }  
     end
     render json: data.to_json
  end

  # Method to call early departure
  def earlyDeparture
    render partial: 'modals/earlyDepartureModal'
  end
  # Method to call roomTypeChargeModal
  def roomTypeChargeModal
    render partial: 'modals/roomTypeChargeModal', locals: { data: current_hotel.default_currency.to_s}
  end
  # Method to call add_new_payment
  def add_new_payment
    render partial: 'admin/hotel_payment/add_new_payment'
  end
# Example Usage : http://localhost:3000/ui/show.json?haml_file=modals/setWakeUpCall&json_input=stay_card/wakeup_calls.json&is_hash_map=true&is_partial=true
# Please contact ROR team if the show function needs more features. Do not add additional functions.
end
