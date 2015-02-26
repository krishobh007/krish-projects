module SeedTestHotels
  def create_test_hotels
    chain = HotelChain.first
    country = Country.find_by_code('US')

    hotel1 = Hotel.find_by_code('DOZERQA')
    hotel2 = Hotel.find_by_code('DPTS')

    yesterday = Date.yesterday

    # Create the hotels if they do not exist yet.
    language = Ref::Language[:EN]
    date_format = Ref::DateFormat['DD-MM-YYYY']
    unless hotel1
      hotel1 = Hotel.create!(name: 'Dupont Circle Hotel',
                             short_name: 'hoteladmin', code: 'DOZERQA', number_of_rooms: 100,  zipcode: '20004',
                             street: '2113 Dupont Circle Park', hotel_phone: '239-252-7426', city: 'democity',
                             state: 'demostate', latitude: 123, longitude: 234, hotel_chain_id: chain.id,
                             default_currency_id: Ref::CurrencyCode[:USD].id, main_contact_phone: '12345',
                             main_contact_email: 'dupontcircle@stayntouch.com',
                             country_id: country.id, is_inactive: false, arr_grace_period: 3, dep_grace_period: 3, pms_type: :OWS,
                             domain_name: 'dozerqa.stayntouch.com',
                             key_system: :VINGCARD, tz_info: 'America/New_York', is_res_import_on: true,
                             auto_logout_delay: 5, main_contact_first_name: 'admin', main_contact_last_name: 'admin',
                             main_contact_email: 'admin@hotel.com', main_contact_phone: '5555555', hotel_from_address: 'admin@dozerqa.stayntouch.com',
                             language_id: language.id, day_import_freq: 5, night_import_freq: 60,
                             default_date_format_id: date_format.id
                             )
    end

    unless HotelBusinessDate.exists?(hotel_id: hotel1.id)
      HotelBusinessDate.create(hotel_id: hotel1.id, business_date: yesterday)
    end

    unless hotel2
      hotel2 = Hotel.create!(name: 'Dupont Square Hotel', short_name: 'hoteladmin',
                             code: 'DPTS', number_of_rooms: 100,  zipcode: '20004', street: '2113 Dupont Square Park', hotel_phone: '239-252-7426',
                             city: 'democity', state: 'demostate', latitude: 123, longitude: 234, hotel_chain_id: chain.id,
                             default_currency_id: Ref::CurrencyCode[:USD].id, main_contact_email: 'dupontsquare@stayntouch.com',
                             main_contact_phone: '12345', country_id: country.id, is_inactive: false, arr_grace_period: 4, dep_grace_period: 5,
                             domain_name: 'dpts.stayntouch.com', tz_info: 'America/New_York', auto_logout_delay: 5,
                             main_contact_first_name: 'admin', main_contact_last_name: 'admin',
                             main_contact_email: 'admin@hotel.com', main_contact_phone: '5555555', hotel_from_address: 'admin@dpts.stayntouch.com',
                             language_id: language.id, day_import_freq: 5, night_import_freq: 60,
                             default_date_format_id: date_format.id)
    end

    unless HotelBusinessDate.exists?(hotel_id: hotel2.id)
      HotelBusinessDate.create(hotel_id: hotel2.id, business_date: yesterday)
    end
  end
end
