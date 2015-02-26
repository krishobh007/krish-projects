require 'spec_helper'
require 'factory_girl_rails'
require 'resque_spec'

describe Guest::SessionsController do

  before :each do
    @hotel_chain = FactoryGirl.create(:hotel_chain)

    FactoryGirl.create(:role, name: 'guest')
    FactoryGirl.create(:role, name: 'admin')
    FactoryGirl.create(:role, name: 'hotel_admin')
    FactoryGirl.create(:role, name: 'front_office_staff')
    FactoryGirl.create(:role, name: 'manager')
    @user = FactoryGirl.create(:user, hotel_chain_id: @hotel_chain.id, role_id: Role.guest.id)
    @user.activate
  end

  describe 'sign in user' do
    it 'Should sign in user successfully' do
      post :create, format: Mime::JSON, email: @user.email, password: 'admin123', chain_code: @hotel_chain.code
      User.find(PmsSession.last.user_id).email.should eq('johndoe1@example.com')
    end
  end

end
