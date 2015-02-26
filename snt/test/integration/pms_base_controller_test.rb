require 'test_helper'

class PmsBaseControllerTest < ActionDispatch::IntegrationTest
  fixtures :users, :roles, :hotels, :api_keys, :hotel_chains

  setup do
    # Get user
    @user = users(:admin)
    @user.roles << Role.admin
    @user.save

    @consumer_key = api_keys(:admin).key

    # Get access key
    post '/login', email: @user.email, password: 'test', chain_code: @user.hotel_chain.code, consumer_key: @consumer_key, format: :json
    json = JSON.parse(@response.body)
    @access_token = json['data']['access_token']
  end
end
