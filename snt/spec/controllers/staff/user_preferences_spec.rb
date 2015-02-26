require 'spec_helper'
require 'factory_girl_rails'
require 'resque_spec'

describe Staff::PreferencesController do

  before :each do

    FactoryGirl.create(:role, name: 'admin')
    FactoryGirl.create(:role, name: 'hotel_admin')
    FactoryGirl.create(:role, name: 'front_office_staff')
    FactoryGirl.create(:role, name: 'manager')
    FactoryGirl.create(:role, name: 'guest')
    @hotel_chain = FactoryGirl.create(:hotel_chain)
    @hotel = FactoryGirl.create(:hotel)
    @user = FactoryGirl.create(:user, hotel_chain_id: @hotel_chain.id, role_id: Role.guest.id, default_hotel_id: @hotel.id)
    @user.activate
  end

  describe 'get user preferences' do
    it 'Should get the list of user preferences' do
      get :likes, format: Mime::JSON, user_id: @user.id
      assert_not_nil response
      # assert_not_nil response[:preferences]
    end
  end

end
