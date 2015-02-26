# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reservations_guest_detail do
    id 1
    is_primary false
    reservation_id 1
    guest_details_id 1
  end
end
