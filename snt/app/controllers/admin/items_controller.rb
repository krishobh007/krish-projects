class Admin::ItemsController < ApplicationController
  before_filter :check_session
  def get_items
    data, errors, status = {}, [], FAILURE
    hotel = current_hotel
    data[:items] = []
    if hotel.items.present?
      data[:items] = hotel.items.map do|item|
        get_item_map_values(item)
      end
    end
    status = SUCCESS
    respond_to do |format|
      format.html { render partial:  '/admin/items/item_list', locals: { data: data,  errors: errors } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  def new_item
    data, errors, status = {}, [], FAILURE

    data[:charge_code] = []
    if current_hotel.charge_codes.present?
      data[:charge_code] = get_chage_code_for_item(current_hotel.charge_codes.charge)
    end
    status = SUCCESS
    respond_to do |format|
      format.html { render partial:  '/admin/items/add_items', locals: { data: data,  errors: errors } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  def save_item
    data, errors, status = {}, [], SUCCESS
    item_attributes = { charge_code_id: params[:charge_code], description: params[:item_description], unit_price: params[:unit_price], is_favorite: params[:is_favorite] }
    if params[:value].present?
      item = current_hotel.items.find(params[:value])
      unless  item.update_attributes(item_attributes)
        errors << 'Invalid Parameters'
        status = FAILURE
      end
    else
      begin
        current_hotel.items.create!(item_attributes)
    rescue ActiveRecord::RecordInvalid => ex
       errors << ex.message
       status = FAILURE
      end
    end
    render json: { status: status, data: data, errors: errors }
   end

  def edit_item
    data, errors, status = {}, [], FAILURE
    hotel = current_hotel
    item = Item.find(params[:id])
    data = get_item_map_values(item)
    data[:charge_code] = get_chage_code_for_item(current_hotel.charge_codes.charge)
    data[:selected_charge_code] = item.charge_code.id.to_s
    status = SUCCESS
    respond_to do |format|
      format.html { render partial:  '/admin/items/edit_items', locals: { data: data,  errors: errors } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  def delete_item
    data, errors, status = {}, [], FAILURE
    current_hotel.items.find(params[:id]).delete
    status = SUCCESS
    respond_to do |format|
      format.json { render json: { status: status, data: data, errors: errors } }
    end
 end

  def toggle_favorite
    data, errors, status = {}, [], FAILURE
    if current_hotel.items.find(params[:id]).update_attributes(is_favorite: params[:set_active])
      status = SUCCESS
     else
       errors << 'Unable to Update Item'
    end
    respond_to do |format|
      format.html { render partial:  'modals/', locals: { data: data,  errors: errors } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  private

  def get_chage_code_for_item(charge_codes)
    array_values = []
    array_values =  charge_codes.map do|charge_code|
      {
        value: charge_code.id.to_s,
        name: charge_code.description
      }

    end
    array_values
  end

  def get_item_map_values(item)
    {
      item_id: item.id.to_s,
      item_description: item.description,
      unit_price: ('%.2f' % item.unit_price).to_s,
      currency_code: item.hotel.default_currency.to_s,
      currency_symbol: item.hotel.default_currency.symbol.to_s,
      is_favourite: item.is_favorite,
      charge_code: item.charge_code.id.to_s,
      category_name: item.charge_code.charge_groups.present? ? item.charge_code.charge_groups.first.charge_group : ''

    }
  end
end
