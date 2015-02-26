class Admin::RoomUpsellsController < ApplicationController
  before_filter :check_session

  layout 'admin'

  def room_upsell_options
    initialize_upsell_amounts unless current_hotel.upsell_amounts.present?
    data = ViewMappings::UpsellMapping.map_hotel_upsell_options(current_hotel)

    result = { 'status' => SUCCESS, 'data' => data, 'errors' => [] }

    respond_to do |format|
      format.html { render partial: '/admin/hotels/upsell_rooms', locals: { data: result } }
      format.json { render json: result}
    end
  end

  def update_upsell_options
    errors = []
    status = SUCCESS

    upsell_params = params[:upsell_setup]

    setup_params = {
      hotel: current_hotel,
      upsell_is_on: upsell_params[:is_upsell_on] == 'true',
      upsell_is_one_night_only: upsell_params[:is_one_night_only] == 'true',
      upsell_is_force: upsell_params[:is_force_upsell] == 'true',
      upsell_total_target_amount: upsell_params[:total_upsell_target_amount],
      upsell_total_target_rooms: upsell_params[:total_upsell_target_rooms],
      upsell_charge_code_id: params[:charge_code],
      upsell_amounts: params[:upsell_amounts].map do |upsell_amount_params|
        upsell_amount = current_hotel.upsell_amounts.where(level_from: upsell_amount_params[:level_from], level_to: upsell_amount_params[:level_to]).first

        if !upsell_amount
          upsell_amount_params[:hotel_id] = current_hotel.id
          upsell_amount = UpsellAmount.new(upsell_amount_params)
        else
          upsell_amount.amount = upsell_amount_params[:amount]
        end

        upsell_amount
      end,
      upsell_room_levels: params[:upsell_room_levels]
    }

    setup = UpsellSetup.new(setup_params)
    if setup.save
      data = ViewMappings::UpsellMapping.map_hotel_upsell_options(current_hotel)
    else
      status = FAILURE
      errors = setup.errors.full_messages
    end

    render json: { status: status,  data: data, errors: errors }
  end

  private

  # Method to setup default upsell amount to return the keys in response for angular
  def initialize_upsell_amounts
    levels_available = [1, 2, 3]
    levels_available.each do |base_level|
      higher_levels = levels_available.select { |higher_level| higher_level > base_level }
      higher_levels.each do |higher_level|
        upsell_params = {
          'level_from' => base_level,
          'level_to' => higher_level
        }
        current_hotel.upsell_amounts.create(upsell_params)
      end
    end
  end
end
