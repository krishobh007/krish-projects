require 'spec_helper'
# require 'authlogic_helpers'
require 'factory_girl_rails'
require 'resque_spec'

# include Authlogic::TestHelper

describe Staff::DashboardController do
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
  @wakeup = FactoryGirl.create(:wakeup, hotel: @hotel, reservation: @reservation, status: 'REQUESTED')
  @api_key = FactoryGirl.create(:api_key)
  @staff_user.activate
end

end
