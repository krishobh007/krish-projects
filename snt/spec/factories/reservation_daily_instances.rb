FactoryGirl.define do
  factory :reservation_daily_instance do
    reservation_id nil
    reservation_date nil
    status 'CHECKEDIN'
    room '5025'
    room_type_id 1
    original_room_type_id 1
    rate_amount 1500.00
    rate_id 1
    original_rate_amount 1500.00
    market_segment 'CTA'
    adults 1
    children 1
  end
end
