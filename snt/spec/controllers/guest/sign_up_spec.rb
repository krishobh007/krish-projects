require 'spec_helper'
require 'factory_girl_rails'
require 'resque_spec'

describe Guest::SessionsController do

  before :each do
    @hotel_chain = FactoryGirl.create(:hotel_chain)

    FactoryGirl.create(:role, name: 'admin')
    FactoryGirl.create(:role, name: 'hotel_admin')
    FactoryGirl.create(:role, name: 'front_office_staff')
    FactoryGirl.create(:role, name: 'manager')
    FactoryGirl.create(:role, name: 'guest')
  end

  describe 'Sign up' do
    it 'Should sign up user successfully' do
      post :sign_up, format: Mime::JSON,
                     user: {
                       email: 'hadm@sample.com',
                       password: 'hadm123',
                       password_confirmation: 'hadm123',
                       first_name: 'Rose',
                       last_name: 'Margret' },
                     chain_code: @hotel_chain.code
      user = User.last
      user.email.should eq('hadm@sample.com')
      PmsSession.last.user_id.should eq(user.id)
    end
  end

end
