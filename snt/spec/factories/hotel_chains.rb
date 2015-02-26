 FactoryGirl.define do
   factory :hotel_chain do
     sequence(:name) { |n| "Hotel chain#{n}" }
     sequence(:code) { |n| "code#{n}" }
   end

 end
