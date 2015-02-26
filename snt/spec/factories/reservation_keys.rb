# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reservation_key do
    number_of_keys 1
    room_number 1
    qr_data ''
  end
end
