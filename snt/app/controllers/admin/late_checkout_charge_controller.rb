class Admin::LateCheckoutChargeController < ApplicationController
  before_filter :check_session

  def get_late_checkout_setup
    late_checkout_data = ViewMappings::UpsellMapping.map_late_checkout_setup_and_charges(current_hotel)
    late_checkout_setup_response = { 'status' => SUCCESS, 'data' => late_checkout_data, 'errors' => [] }

    respond_to do |format|
      format.html { render locals: { data: late_checkout_data }, partial: '/admin/hotels/upsell_late_checkout' }
      format.json { render json: late_checkout_setup_response }
    end
  end

  def update_late_checkout_setup
    status, data, errors = SUCCESS, {}, []

    setup_params = ViewMappings::UpsellMapping.map_late_checkout_setup_config(params, current_hotel)
    setup = LateCheckoutSetup.new(setup_params)
    setup.hotel = current_hotel

    params['room_types'].andand.map do |value|
      current_hotel.room_types.find(value[:id]).update_attributes(max_late_checkouts: value[:max_late_checkouts])
    end
    params['deleted_room_types'].andand.each do |room_type|
      current_hotel.room_types.find(room_type).update_attributes(max_late_checkouts: nil)
    end

    if setup.save
      data = ViewMappings::UpsellMapping.map_late_checkout_setup_and_charges(current_hotel)
    else
      status = FAILURE
      errors = setup.errors.full_messages
    end

    respond_to do |format|
      format.json { render json: { 'status' => status, 'data' => data, 'errors' => errors } }
    end
  end
end
