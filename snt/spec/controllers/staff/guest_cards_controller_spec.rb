require 'spec_helper'
require 'factory_girl_rails'
require 'resque_spec'

describe Staff::GuestCardsController do

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
    @reservation = FactoryGirl.create(:reservation, user: @user, hotel_id: @user.default_hotel_id)
  end

  describe 'get guest card data' do
    it 'Should get the guest card data with job_title and works_at ' do
      get :show, format: Mime::JSON, id: @reservation.id
      assert_not_nil response
    end
  end

end
