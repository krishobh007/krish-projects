require 'spec_helper'

describe 'UserMemberships' do
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

  describe 'GET /user_memberships' do
    it 'should get a list of all memberships' do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      sign_in_as_a_valid_staff(@staff_user)
      get staff_user_memberships_path, user_id: @guest_user.id
      expect(response.status).to eq(200)
    end
  end

  describe 'Add / Delete new user_membership' do
    it 'should add a new user_membership' do
      sign_in_as_a_valid_staff(@staff_user)
      post staff_user_memberships_path,
           user_id: @guest_user.id,
           guest_id: @reservation.guest_id,
           user_membership: {
             membership_type: 'AA',
             membership_card_number: '123232',
             membership_expiry_date: Date.today + 10.days,
             membership_level: 'GOLD',
             membership_class: 'FFP',
             card_name: 'Jon',
             external_id: '123' },
           format: :json
      expect(response.status).to eq(200)
    end
  end
end
