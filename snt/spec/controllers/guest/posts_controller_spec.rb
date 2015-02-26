require 'spec_helper'

describe Guest::PostsController do
  before :each do
    @api_key = FactoryGirl.create(:api_key)
    @hotel_chain = FactoryGirl.create(:hotel_chain)
    @hotel = FactoryGirl.create(:hotel, hotel_chain_id: @hotel_chain.id)

    FactoryGirl.create(:role, name: 'admin')
    FactoryGirl.create(:role, name: 'hotel_admin')
    FactoryGirl.create(:role, name: 'front_office_staff')
    FactoryGirl.create(:role, name: 'manager')
    FactoryGirl.create(:role, name: 'guest')
    @user = FactoryGirl.create(:user, hotel_chain_id: @hotel_chain.id, role_id: Role.guest.id)
    @user.activate
    # TODO - Moch user login

    @pms_session = FactoryGirl.create(:pms_session, session_id: SecureRandom.hex, user_id: @user.id)
  end

  describe 'Create', type: :request do
    it 'should create a post' do
      params = { author_name: 'Test', author_email: 'test@test.com', body: 'This is a test' }
      post "guest/hotels/#{@hotel.id}/posts.json?access_token=#{@pms_session.session_id}&consumer_key=#{@api_key.key}", params.to_json,  'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'
      assert_not_nil response
    end
  end
end
