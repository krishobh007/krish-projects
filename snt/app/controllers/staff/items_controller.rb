class Staff::ItemsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  def get_items
    data, errors, status = {}, [], FAILURE
    data[:non_item_linked_charge_codes] = []
    data[:charge_groups] = current_hotel.charge_groups.map do|charge_group|
      {
        value: charge_group.id.to_s,
        name: charge_group.charge_group
      }
    end
    data[:items] = current_hotel.items.order('lower(description) ASC').map do|item|
      {
        value: item.id.to_s,
        item_name: item.description,
        unit_price: item.unit_price.to_s,
        charge_code_name: item.charge_code.andand.charge_code.to_s,
        currency_code: current_hotel.default_currency.andand.value.to_s,
        is_favorite: item.is_favorite ? 'true' : 'false',
        charge_group_value: item.charge_code && item.charge_code.charge_groups.present? ? item.charge_code.charge_groups.first.id : ''
      }
    end
    # Non item linked charge codes should be returned only for standalone hotels
    # This should be an empty array for connected hotels - CICO-13500 #See Comments
    data[:non_item_linked_charge_codes] = current_hotel.charge_codes.charge.non_item_linked_charge_codes.map do |charge_code|
      {
        value: charge_code.id,
        description: charge_code.description.to_s,
        charge_code: charge_code.charge_code.to_s,
      }
    end unless current_hotel.is_third_party_pms_configured?
    status = SUCCESS
    respond_to do |format|
      format.html { render partial:  'modals/postChargeToGuestBill', locals: { data: data,  errors: errors } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  def post_items_to_bill
    
    data, errors, status = {}, [], FAILURE
    post_items = []
    reservation = Reservation.find(params[:reservation_id])
    failed_updation = false
    bill_no = params[:bill_no] || '1'
    amount_total = params[:total]
    charge_items = params[:items]
    begin
      charge_items.each do |charge_item|
        item_hash = {}
        item_hash[:item] = Item.find(charge_item[:value]) if charge_item[:is_item] 
        item_hash[:amount] = charge_item[:amount]
        item_hash[:is_item] = charge_item[:is_item] 
        item_hash[:item] = current_hotel.charge_codes.find(charge_item[:value]) unless charge_item[:is_item]
        item_hash[:description] = "#{item_hash[:item].description} (#{charge_item[:quantity]})"
        post_items << item_hash
      end
    rescue ActiveRecord::RecordNotFound 
      errors << I18n.t(:item_not_found)
      failed_updation = true
    end
    if errors.empty?
      post_items.each do |post_item|
        
        if current_hotel.is_third_party_pms_configured?
          post_ows = PostChargesApi.new(reservation.hotel.id)
          posting_attr_hash = { posting_date: reservation.hotel.active_business_date, posting_time: Time.now, long_info: post_item[:description], charge: post_item[:amount], bill_no: bill_no }
          post_charge_code =  post_item[:is_item] ? post_item[:item].charge_code.charge_code : post_item[:item].charge_code
          result = post_ows.update_post_charges(post_charge_code, reservation.external_id, posting_attr_hash)
          failed_updation = !result[:status]
          errors << 'Unable to update all Charges in External PMS' if result[:status]
        else
          charge_code = post_item[:is_item] ? post_item[:item].charge_code : post_item[:item]
          options = {
            is_eod: false,
            amount: post_item[:amount],
            rate_id: nil,
            bill_number: bill_no,
            charge_code: charge_code,
            is_item_charge: true,
            item_details: post_item
          }
          reservation.post_charge(options)
        end
      end
    end
    if !failed_updation
      status = SUCCESS
      # If the request indicates to fetch the total balance, then make call to OWS to retrieve it and return in response
      if params[:fetch_total_balance] == true
        reservation.sync_bills_with_external_pms if current_hotel.is_third_party_pms_configured?
        data[:total_balance_amount] = reservation.current_balance
        data[:currency_code] = reservation.hotel.default_currency.to_s
        data[:confirmation_number] = reservation.confirm_no
      end
    end
    render json: { status: status, data: data, errors: errors }
  end
end
