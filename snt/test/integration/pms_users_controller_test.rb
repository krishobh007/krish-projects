class PmsUsersControllerTest < PmsBaseControllerTest
  # Get the current hotel for the signed in user and verify it is the default hotel
  test 'get_current_hotel' do
    get '/users/get_current_hotel', access_token: @access_token, consumer_key: @consumer_key, format: :json
    assert_response :success

    json = JSON.parse(@response.body)
    assert_equal @user.default_hotel.id, json['current_hotel_id']
  end

  # Set the current hotel for the signed in user, then get it and verify it is the new hotel
  test 'set_current_hotel' do
    post '/users/set_current_hotel', access_token: @access_token, consumer_key: @consumer_key, hotel_code: hotels(:two).code, format: :json
    assert_response :success

    get '/users/get_current_hotel', access_token: @access_token, consumer_key: @consumer_key, format: :json
    assert_response :success

    json = JSON.parse(@response.body)
    assert_equal hotels(:two).id, json['current_hotel_id']
  end
end
