FactoryGirl.define do
  factory :reservation do
    sequence(:first_name) { |n| "first_name#{n}" }
    sequence(:last_name) { |n| "last_name#{n}" }
    confirm_no 134_344
    arrival_date { 2.days.ago.utc.strftime('%Y-%m-%d') }
    dep_date { 2.days.from_now.utc.strftime('%Y-%m-%d') }
    created_at { 5.minutes.ago.strftime('%Y-%m-%d %H:%M:%S') }
    user
    hotel
    status 'RESERVED'
  end
end
