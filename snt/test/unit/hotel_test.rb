require 'test_helper'

class HotelTest < ActiveSupport::TestCase
  test 'should update review score' do
    hotel = hotels(:one)
    reservation = reservations(:checked_out)
    assert_equal reservation.reviews.count, 2

    Review.create(
      review_category_id: 3,
      reservation: reservations(:checked_out),
      rating: 5
    )

    assert_equal hotel.average_review_score(hotel.active_business_date), '4.0'

  end

  test 'should return upsell target amount' do
    hotel = hotels(:one)
    assert_equal hotel.upsell_target_amount, '1000'
  end

  test 'should return upsell target rooms' do
    hotel = hotels(:one)
    assert_equal hotel.upsell_target_rooms, '100'
  end

  test 'should return upsell revenue amount' do
    hotel = hotels(:one)
    assert_equal hotel.total_upsell_revenue(hotel.active_business_date), 588.34
  end

  test 'should return upsold rooms count' do
    hotel = hotels(:one)
    assert_equal hotel.total_upsell_rooms_sold(hotel.active_business_date), 1
  end
end
