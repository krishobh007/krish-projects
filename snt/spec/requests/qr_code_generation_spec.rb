require 'spec_helper'

describe 'QR Code Generation' do
  before :each do

    FactoryGirl.create(:role, name: 'admin')
    FactoryGirl.create(:role, name: 'hotel_admin')
    FactoryGirl.create(:role, name: 'front_office_staff')
    FactoryGirl.create(:role, name: 'manager')
    FactoryGirl.create(:role, name: 'guest')

    @membership_class  = FactoryGirl.create(:membership_class)
    @membership_level = FactoryGirl.create(:membership_level)

    @hotel_chain = FactoryGirl.create(:hotel_chain)
    @hotel = FactoryGirl.create(:hotel, hotel_chain: @hotel_chain)

    @external_mapping = FactoryGirl.create(:external_mapping, external_value: 'AIR', value: 'FFP', mapping_type: 'MEMBER_CLASS', hotel_id: @hotel.id, hotel_chain_id: @hotel_chain.id)

    @staff_user = FactoryGirl.create(:user, hotel_chain_id: @hotel_chain.id, role_id: Role.front_office_staff.id, default_hotel_id: @hotel.id)
    @guest_user = FactoryGirl.create(:user, hotel_chain_id: @hotel_chain.id, role_id: Role.guest.id)

    @setting = FactoryGirl.create(:setting, thing_id: @hotel.id)

    @reservation = FactoryGirl.create(:reservation, user: @guest_user, hotel: @hotel, status: 'CHECKEDIN')
    @reservation_daily_instance = FactoryGirl.create(:reservation_daily_instance, reservation_id: @reservation.id, reservation_date: @reservation.arrival_date)
    @business_date = FactoryGirl.create(:hotel_business_date, hotel: @hotel, business_date: @reservation.arrival_date)
    @membership_type = FactoryGirl.create(:membership_type, chain_id: @hotel_chain.id, hotel_id: @hotel.id)

    @user_membership = FactoryGirl.create(:user_membership, user_id: @guest_user.id)
    # controller.stub!(:current_user).and_return(@staff_user)
    # @staff_user.stub!(:update_attributes => false)
    @api_key = FactoryGirl.create(:api_key)
    @staff_user.activate

    @setting = FactoryGirl.create(:setting, var: 'rover_staff_key_setup', thing_id: @hotel.id)
  end

  describe 'Add new reservation key' do
    it 'should add a new reservation key' do
      sign_in_as_a_valid_staff(@staff_user)
      post staff_reservation_print_key_path,
           reservation_id: @reservation.id,
           email: @guest_user.email,
           key: 3,
           format: :json
      reservation_key = ReservationKey.first
      expect(reservation_key.reservation_id).to eq(@reservation.id)
      expect(response.status).to eq(200)
    end
  end

  describe 'Add additional reservation key' do
    it 'should add additional reservation key' do
      sign_in_as_a_valid_staff(@staff_user)
      post staff_reservation_print_key_path,
           reservation_id: @reservation.id,
           email: @guest_user.email,
           key: 3,
           format: :json
      post staff_reservation_print_key_path,
           reservation_id: @reservation.id,
           email: @guest_user.email,
           key: 3,
           is_additional: 'true',
           format: :json
      reservation_keys = ReservationKey.all
      expect(reservation_keys[0].reservation_id).to eq(reservation_keys[1].reservation_id)
      expect(reservation_keys.count).to eq(2)
      expect(response.status).to eq(200)
    end
  end

end
