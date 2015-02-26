require 'test_helper'

class HotelsControllerTest < ActionController::TestCase
  setup do
    @hotel = hotels(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:hotels)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create hotel' do
    assert_difference('Hotel.count') do
      post :create, hotel: { code: @hotel.code, arr_grace_period: @hotel.arr_grace_period, checkin_bypass: @hotel.checkin_bypass, checkin_time: @hotel.checkin_time, checkout_time: @hotel.checkout_time, city: @hotel.city, dep_grace_period: @hotel.dep_grace_period, groups_count: @hotel.groups_count, guests_count: @hotel.guests_count, hotel_phone: @hotel.hotel_phone, icon_content_type: @hotel.icon_content_type, icon_file_name: @hotel.icon_file_name, icon_file_size: @hotel.icon_file_size, latitude: @hotel.latitude, longitude: @hotel.longitude, name: @hotel.name, number_of_rooms: @hotel.number_of_rooms, posts_month_count: @hotel.posts_month_count, posts_today_count: @hotel.posts_today_count, short_name: @hotel.short_name, sl_checkin_msg: @hotel.sl_checkin_msg, staffs_count: @hotel.staffs_count, state: @hotel.state, welcome_msg: @hotel.welcome_msg, welcome_msg_detail: @hotel.welcome_msg_detail, zipcode: @hotel.zipcode }
    end

    assert_redirected_to hotel_path(assigns(:hotel))
  end

  test 'should show hotel' do
    get :show, id: @hotel
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @hotel
    assert_response :success
  end

  test 'should update hotel' do
    put :update, id: @hotel, hotel: { code: @hotel.code, arr_grace_period: @hotel.arr_grace_period, checkin_bypass: @hotel.checkin_bypass, checkin_time: @hotel.checkin_time, checkout_time: @hotel.checkout_time, city: @hotel.city, dep_grace_period: @hotel.dep_grace_period, groups_count: @hotel.groups_count, guests_count: @hotel.guests_count, hotel_phone: @hotel.hotel_phone, icon_content_type: @hotel.icon_content_type, icon_file_name: @hotel.icon_file_name, icon_file_size: @hotel.icon_file_size, latitude: @hotel.latitude, longitude: @hotel.longitude, name: @hotel.name, number_of_rooms: @hotel.number_of_rooms, posts_month_count: @hotel.posts_month_count, posts_today_count: @hotel.posts_today_count, short_name: @hotel.short_name, sl_checkin_msg: @hotel.sl_checkin_msg, staffs_count: @hotel.staffs_count, state: @hotel.state, welcome_msg: @hotel.welcome_msg, welcome_msg_detail: @hotel.welcome_msg_detail, zipcode: @hotel.zipcode }
    assert_redirected_to hotel_path(assigns(:hotel))
  end

  test 'should destroy hotel' do
    assert_difference('Hotel.count', -1) do
      delete :destroy, id: @hotel
    end

    assert_redirected_to hotels_path
  end
end
