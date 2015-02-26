require 'spec_helper'

describe 'ReservationPayments' do
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
    @membership_type = FactoryGirl.create(:membership_type, chain_id: @hotel_chain.id, hotel_id: @hotel.id)

    @user_membership = FactoryGirl.create(:user_membership, user_id: @guest_user.id)
    # controller.stub!(:current_user).and_return(@staff_user)
    # @staff_user.stub!(:update_attributes => false)
    @api_key = FactoryGirl.create(:api_key)
    @staff_user.activate
  end
  describe 'POST create reservation payment' do
    it 'should create a new reservation payment' do
      sign_in_as_a_valid_staff(@staff_user)
      post '/staff/reservation/save_payment', user_id: @staff_user.id,
                                              guest_id: @reservation.guest_id,
                                              confirmno: @reservation.confirm_no,
                                              payment_type: 'CC',
                                              credit_card: 'AX',
                                              mli_token: '371449635398431',
                                              card_expiry: '10/2020',
                                              name_on_card: 'Smith'
      expect(JSON.parse(response.body)['status']).to eq('success')
    end
  end
end
