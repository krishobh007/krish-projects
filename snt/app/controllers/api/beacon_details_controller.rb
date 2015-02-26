class Api::BeaconDetailsController < ApplicationController
  before_filter :check_session, except: [:index, :proximity, :show]
  before_filter :set_beacon_details, only: [:show, :activate, :destroy, :update, :link]
  before_filter :check_business_date
  after_filter :load_business_date_info
  
  def index
    if params[:hotel_major_id].present? && params[:chain_proximity_id].present?
      current_hotel_chain = HotelChain.find_by_beacon_uuid_proximity(params[:chain_proximity_id])
      hotel = Hotel.find_by_beacon_uuid_major(params[:hotel_major_id])
      is_chain_valid = (hotel.hotel_chain = current_hotel_chain) ? true : false if hotel && current_hotel_chain
    else
      check_session
      hotel = current_hotel
      is_chain_valid = true
    end
    @beacon_details = hotel.beacons.page(params[:page]).per(params[:per_page]).sort_by(params[:sort_field], params[:sort_dir]) if hotel && is_chain_valid
    @last_updated = hotel.beacons.order("updated_at DESC").first.andand.updated_at
  end

  def activate
    @beacon_detail.update_attributes(:is_active => params[:status]) ||
    render(json: @beacon_detail.errors.full_messages, status: :unprocessable_entity)
  end

  def show
   @is_beacon_valid = false
   if !validate_consumer_key(params[:consumer_key])
     check_session
   elsif validate_consumer_key(params[:consumer_key]) && params[:access_token].present?
    check_session
    if @beacon_detail.type === :CHECKOUT
      checkout_reservation = current_user.guest_detail.andand.reservations.due_out(@beacon_detail.hotel.active_business_date).first
      @has_late_checkouts = checkout_reservation.present? ? checkout_reservation.is_late_checkout_available? : 'false'
      @is_beacon_valid = checkout_reservation.present? && checkout_reservation.valid_primary_card? && @beacon_detail.is_active
      @notification_detail = NotificationDetail.find_by_notification_id_and_notification_section(checkout_reservation.id, Setting.notification_section_text[:beacon_checkout]) if @is_beacon_valid
      @notification_detail = @notification_detail || NotificationDetail.create_reservation_notification(checkout_reservation, Setting.notification_section_text[:beacon_checkout], nil, true, true) if @is_beacon_valid && !@notification_detail.present?
    elsif @beacon_detail.type === :CHECKIN
      checkin_reservation = current_user.guest_detail.reservations.with_status(:CHECKIN).first
      @is_beacon_valid = checkout_reservation.present?
      @has_upgrades = checkin_reservation.present? ? checkin_reservation.current_daily_instance.andand.room_type.andand.upsell_available?(checkin_reservation) : 'false'
    end
  end
  if @beacon_detail.type === :PROMOTION
    @is_beacon_valid = current_user.present? ? current_user.notification_preference.andand.is_alert_promotions : true
  end
  @last_updated = @beacon_detail.hotel.beacons.order("updated_at DESC").first.updated_at
  uuid = @beacon_detail.uuid
  @estimote_id = uuid.split('-')
end

def create
  if params[:type] == Setting.beacon_types[:promotion]
    promo_detail = current_hotel.promotions.create(title: params[:title], description: params[:description])
    if params[:picture].present?
     promo_detail.picture_from_base64(params[:picture])
   end
 end
 @beacon_detail = current_hotel.beacons.new(location: params[:location], uuid: params[:uuid],
  type_id: Ref::BeaconType[params[:type]].andand.id, is_active: params[:status],
  trigger_range_id: Ref::BeaconRange[params[:trigger_range]].andand.id, notification_text: params[:message],
  promotion_id: promo_detail.present? ? promo_detail.id : nil)
 if params[:neighbours].present?
  params[:neighbours].each do |neighbour_id|
    neighbour = Beacon.find(neighbour_id)
    @beacon_detail.add_neighbour(neighbour)
  end
end
@beacon_detail.save || render(json: @beacon_detail.errors.full_messages, status: :unprocessable_entity)
end

def update
  if params[:neighbours].present?
    @beacon_detail.remove_neighbours
    params[:neighbours].each do |neighbour_id|
      neighbour = Beacon.find(neighbour_id)
      @beacon_detail.add_neighbour(neighbour)
    end
  elsif params[:neighbours].empty?
    @beacon_detail.remove_neighbours
  end
  @beacon_detail.type = Ref::BeaconType[params[:type]]
  promo = @beacon_detail.promotion
  if @beacon_detail.type_id_changed?
   if params[:type] == Setting.beacon_types[:promotion]
     promo_detail = current_hotel.promotions.create(title: params[:title], description: params[:description])
     @beacon_detail.promotion_id = promo_detail.id if promo_detail
     promo_detail.picture_from_base64(params[:picture]) if params[:picture].present?
   else
     @beacon_detail.promotion_id = nil
     promo.destroy if promo
   end
   @beacon_detail.save!
 else
   promo.update_attributes(title: params[:title],
    description: params[:description]) if promo
   @beacon_detail.update_attributes(updated_at: Time.now)
   if promo && params[:picture].present?
    promo.picture_from_base64(params[:picture])
  end
end
@beacon_detail.update_attributes(location: params[:location], uuid: params[:uuid],
  type_id: Ref::BeaconType[params[:type]].andand.id, is_active: params[:status],
  trigger_range_id: Ref::BeaconRange[params[:trigger_range]].andand.id,
  notification_text: params[:message]) ||

render(json: @beacon_detail.errors.full_messages, status: :unprocessable_entity)
end

def link
  @beacon_detail.update_attributes(is_linked: params[:is_linked])
end

def ranges
 @ranges = Ref::BeaconRange.page(params[:page]).per(params[:per_page])
end

def types
 @types = Ref::BeaconType.page(params[:page]).per(params[:per_page])
end

def uuid_values
 random = Random.new
 @hotel = current_hotel
 @random_number = random.rand(1...65535)
end

  # ZEST API - Fetch Proximity ID for a hotel
  def proximity
   @hotel_chain = HotelChain.find_by_code(params[:chain_code])
   fail I18n.t(:chain_not_found) unless @hotel_chain
 end

 def destroy
  @beacon_detail.delete || render(json: @beacon_detail.errors.full_messages, status: :unprocessable_entity)
end


private

def set_beacon_details
  params[:neighbours] ||= []
  @beacon_detail = Beacon.find(params[:id])
  fail I18n.t(:invalid_origin_id) unless @beacon_detail.present?
end


end