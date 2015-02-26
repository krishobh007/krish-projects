require 'test_helper'

class HotelBrandsControllerTest < ActionController::TestCase
  setup do
    @hotel_brand = hotel_brands(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:hotel_brands)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create hotel_brand' do
    assert_difference('HotelBrand.count') do
      post :create, hotel_brand: { icon_content_type: @hotel_brand.icon_content_type, icon_file_name: @hotel_brand.icon_file_name, icon_file_size: @hotel_brand.icon_file_size, name: @hotel_brand.name }
    end

    assert_redirected_to hotel_brand_path(assigns(:hotel_brand))
  end

  test 'should show hotel_brand' do
    get :show, id: @hotel_brand
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @hotel_brand
    assert_response :success
  end

  test 'should update hotel_brand' do
    put :update, id: @hotel_brand, hotel_brand: { icon_content_type: @hotel_brand.icon_content_type, icon_file_name: @hotel_brand.icon_file_name, icon_file_size: @hotel_brand.icon_file_size, name: @hotel_brand.name }
    assert_redirected_to hotel_brand_path(assigns(:hotel_brand))
  end

  test 'should destroy hotel_brand' do
    assert_difference('HotelBrand.count', -1) do
      delete :destroy, id: @hotel_brand
    end

    assert_redirected_to hotel_brands_path
  end
end
