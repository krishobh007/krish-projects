class Staff::UserMembershipsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  def index
    # current_hotel = Hotel.first
    # params[:confirmno] = 4813095

    # reservation = Reservation.find(params[:reservation_id])
    guest = GuestDetail.find(params[:user_id])
    @ffps = guest.get_ffps
    @hlps = guest.get_hlps(current_hotel)
    @loyalty = { 'frequentFlyerProgram' => @ffps, 'hotelLoyaltyProgram' => @hlps }

    respond_to do |format|
      format.html { render partial: 'shared/loyalty' }
      format.json { render json: { 'status' => SUCCESS, 'data' => @loyalty, 'errors' => [] } }
    end
  end

  def new_ffp
    @loyalty_id = params[:id]
    @loyalty_type = params[:type]
    render partial: 'modals/newFrequentFlyerProgram'
  end

  def new_hlp
    @loyalty_id = params[:id]
    @loyalty_type = params[:type]
    render partial: 'modals/newHotelLoyaltyProgram'
  end

  def new_loyalty
    respond_to do |format|
      format.html { render partial: 'modals/newLoyaltyProgram' }
      format.json { render json: { 'status' => SUCCESS, 'data' => {}, 'errors' => [] } }
    end
  end

  def delete_membership
    @loyalty_id = params[:id]
    @loyalty_type = params[:type]
    render partial: 'modals/loyaltyDelete'
  end

  def create
    guest_detail_id = params[:user_id]
    guest_id = params[:guest_id]

    # If reservation id is available then initialize it.
    if params[:reservation_id].present?
      @reservation = Reservation.find(params[:reservation_id])
      reservation_memberships = @reservation.memberships
    end

    errors = []
    result = { status: false }
    changed_attributes = {}
    guest_membership = GuestMembership.new(params[:user_membership].except(:membership_level, :membership_type, :membership_class))
    guest_membership.guest_detail_id = guest_detail_id
    membership_types = current_hotel.membership_types.where(value: params[:user_membership][:membership_type]).with_membership_class(params[:user_membership][:membership_class]) + current_hotel.hotel_chain.membership_types.where(value: params[:user_membership][:membership_type]).with_membership_class(params[:user_membership][:membership_class])
    guest_membership.membership_type_id = membership_types.count > 0 ? membership_types.first.id : nil
    guest_membership.membership_level_id = MembershipLevel.where(membership_type_id: guest_membership.membership_type_id, membership_level: params[:user_membership][:membership_level]).first.andand.id

    if guest_membership.valid?
      if current_hotel.is_third_party_pms_configured?
        # if guest id is not sent then assign from reservation
        unless guest_id
          guest_id = @reservation.primary_guest.external_id
        end
        if guest_id
          guest_api = GuestApi.new(current_hotel.id)

          api_result = guest_api.insert_guest_card(guest_id, guest_membership.membership_type.membership_class.value,
                                                   guest_membership.membership_type.value, guest_membership.membership_card_number,
                                                   guest_membership.membership_level.andand.membership_level, guest_membership.guest_detail.full_name,
                                                   guest_membership.membership_expiry_date, guest_membership.membership_start_date)

          if api_result[:status]
            guest_membership.external_id = api_result[:external_id]
          else
            if api_result[:message].starts_with?('Invalid Card Number')
              errors << I18n.t(:external_pms_invalid_membership_code)
            else
              errors << I18n.t(:external_pms_failed)
            end
          end
        end
      end

      if errors.empty?

        guest_membership.save!

        # Link this membership to reservation too
        if params[:reservation_id].present?

          if @reservation.hotel.is_third_party_pms_configured?

            changed_attributes[:memberships] = [{ membership_type: guest_membership.membership_type.value, membership_class: guest_membership.membership_type.membership_class.value,
                                                  membership_number: guest_membership.membership_card_number, member_name: guest_membership.guest_detail.full_name,
                                                  membership_level: guest_membership.membership_level.andand.membership_level, start_date: guest_membership.membership_start_date,
                                                  expiry_date: guest_membership.membership_expiry_date, external_id: guest_membership.external_id }]

            result = @reservation.modify_booking_of_external_pms(changed_attributes)

          else
            result[:status] = true

          end
          if result[:status]
            @reservation.memberships = [guest_membership]
            @reservation.save!
          else
            errors << 'Error in attaching the membership to 3p PMS reservation'
          end
        end
      end
    else
      errors += guest_membership.errors.full_messages
    end

    respond_to do |format|
      if errors.empty?
        format.json { render json: { status: SUCCESS, data: { id: guest_membership.id }, errors: [] } }
      else
        format.json { render json: { status: FAILURE, data: {}, errors: errors } }
      end
    end
  end

  # Delete the user membership
  def destroy
    guest_membership = GuestMembership.find(params[:id])
    external_id = guest_membership.external_id

    errors = []

    if external_id
      guest_api = GuestApi.new(current_hotel.id)
      api_result = guest_api.delete_guest_card(external_id)

      errors << I18n.t(:external_pms_failed) unless api_result[:status]
    end

    guest_membership.destroy if errors.empty?

    respond_to do |format|
      if errors.empty?
        format.json { render json: { status: SUCCESS, data: {}, errors: errors } }
      else
        format.json { render json: { status: FAILURE, data: {}, errors: errors } }
      end
    end
  end

  def get_available_hlps
    errors = []
    @data = []
    @hlps = current_hotel.get_active_hlps
    @hlps.each do |hlp|
      @hlp_data = Hash.new
      @hlp_data[:hl_description] = hlp.description
      @hlp_data[:hl_value] = hlp.value
      @hlp_data[:levels] = MembershipLevel.where(membership_type_id: hlp.id).select([:membership_level, :description])
      @data << @hlp_data
    end
    respond_to do |format|
      format.json { render json: { status: SUCCESS, data: @data, errors: errors } }
    end
  end

  def get_available_ffps
    errors = []
    @data = []
    @ffps = current_hotel.get_active_ffps
    @ffps.each do |ffp|
      @ffp_data = Hash.new
      @ffp_data[:ff_description] = ffp.description
      @ffp_data[:ff_value] = ffp.value
      @ffp_data[:levels] = MembershipLevel.where(membership_type_id: ffp.id).select([:membership_level, :description])
      @data << @ffp_data
    end
    respond_to do |format|
      format.json { render json: { status: SUCCESS, data: @data, errors: errors } }
    end
  end

  def link_to_reservation
    # URL - /user_memberships/link_to_reservation
    # Parameters - :reservation_id, :user_membership_id
    # Method - POST
    errors = []
    result = { status: false }
    changed_attributes = {}

    @reservation = Reservation.find(params[:reservation_id])
    reservation_memberships = @reservation.memberships

    if params[:membership_id].present?
      user_membership = GuestMembership.find(params[:membership_id])

      if @reservation.hotel.is_third_party_pms_configured?

        changed_attributes[:memberships] = [{ membership_type: user_membership.membership_type.value, membership_class: user_membership.membership_type.membership_class.value,
                                              membership_number: user_membership.membership_card_number, member_name: user_membership.guest_detail.full_name,
                                              membership_level: user_membership.membership_level.andand.membership_level, start_date: user_membership.membership_start_date,
                                              expiry_date: user_membership.membership_expiry_date, external_id: user_membership.external_id }]

        result = @reservation.modify_booking_of_external_pms(changed_attributes)

      else
        result[:status] = true

      end
      if result[:status]
        @reservation.memberships = [user_membership]
        @reservation.save!
        render json: { 'status' => SUCCESS, 'errors' => errors }
      else
        errors << 'Error in attaching the membership to 3p PMS reservation'
        render json: { 'status' => FAILURE, 'errors' => errors }
      end
    else
      @reservation.memberships.delete_all
      render json: { 'status' => SUCCESS, 'errors' => errors }
    end
  end
end
