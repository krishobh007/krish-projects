require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  test 'search for reservations with matching first_name' do
    reservation = reservations(:in_house)
    guests = Reservation.search_by_hotel(reservation.first_name, Setting.reservation_input_status[:checked_in], hotels(:one).id, 5.days.ago.midnight)
    assert_equal guests[0].first_name, reservation.first_name
  end

  test 'search for reservations with matching confirmation number' do
    reservation = reservations(:checked_out)
    guests = Reservation.search_by_hotel(reservation.confirm_no.to_s, Setting.reservation_input_status[:checked_out], hotels(:one).id, 5.days.ago.midnight)
    assert_equal guests[0].confirm_no, reservation.confirm_no
  end

  test 'search for reservations with matching room number' do
    reservation = reservations(:checked_out)
    guests = Reservation.search_by_hotel(reservation.room_no.to_s, nil, hotels(:one).id, 5.days.ago.midnight)
    assert_equal guests[0].room_no, reservation.room_no
  end

  test 'search for reservations with matching group_name' do
    reservation = reservations(:checked_out)
    guests = Reservation.search_by_hotel(reservation.group_name, nil, hotels(:one).id, 5.days.ago.midnight)
    assert_equal guests[0].group_name, reservation.group_name
  end

  test 'show DUEIN reservations' do
    reservation = reservations(:due_in)
    due_in_guests = Reservation.search_by_hotel(nil, Setting.reservation_input_status[:due_in], hotels(:one).id, hotels(:one).active_business_date)
    assert_equal due_in_guests[0].first_name, reservation.first_name
    assert_equal due_in_guests.length, 1
  end

  test 'show DUEOUT reservations' do
    reservation = reservations(:due_out)
    due_out_guests = Reservation.search_by_hotel(nil, Setting.reservation_input_status[:due_out], hotels(:one).id, hotels(:one).active_business_date)
    assert_equal due_out_guests[0].first_name, reservation.first_name
    assert_equal due_out_guests.length, 1
  end

  test 'show INHOUSE reservations' do
    reservation = reservations(:in_house)
    inhouse_guests = Reservation.search_by_hotel(nil, Setting.reservation_input_status[:in_house], hotels(:one).id, 5.days.ago.midnight)
    assert_equal inhouse_guests.length, 3
  end

  test 'scope due_in' do
    reservation = reservations(:due_in)
    hotel = hotels(:one)
    due_in_guests =  Reservation.due_in_list(hotel.id)
    assert_equal reservation.first_name, due_in_guests[0].first_name
    assert_equal due_in_guests.length, 1
  end

  test 'scope due_out' do
    reservation = reservations(:due_out)
    hotel = hotels(:one)
    due_out_guests =  Reservation.due_out_list(hotel.id)
    assert_equal due_out_guests[0].first_name, reservation.first_name
    assert_equal due_out_guests.length, 1
  end

  test 'scope in_house' do
    reservation = reservations(:in_house)
    hotel = hotels(:one)
    inhouse_guests =  Reservation.inhouse_list(hotel.id)
    assert_equal inhouse_guests[0].first_name, reservation.first_name
    assert_equal inhouse_guests.length, 2
  end

  test 'find reservations by user_id' do
    reservations = Reservation.by_user_and_hotel(users(:admin).id, nil, nil, nil)
    assert_equal 5, reservations.length
  end

  test 'find reservations by email and hotel_id' do
    reservations = Reservation.by_user_and_hotel(nil, 'test@snt.com', hotels(:one).id, nil)
    assert_equal 5, reservations.length
  end

  test 'find reservations by email and chain_id' do
    reservations = Reservation.by_user_and_hotel(nil, 'test@snt.com', nil, hotel_chains(:one))
    assert_equal 5, reservations.length
  end
end
