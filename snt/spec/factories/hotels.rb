FactoryGirl.define do
   factory :hotel do
     sequence(:name) { |n| "Hotel Name#{n}" }
     sequence(:code) { |n| "Code#{n}" }
     street 'Bethesda'
     zipcode '20810'
     city 'Bethesda'
     state do
        @state = FactoryGirl.create(:state)
      end
     country do
        @country = FactoryGirl.create(:country)
      end
     number_of_rooms 233
     hotel_phone '2527427'
     latitude 38.9176607
     longitude -77.045858
     checkin_bypass false
     hotel_chain do
       FactoryGirl.create(:hotel_chain)
     end
     features do
       [FactoryGirl.create(:ref_feature)]
     end
   end

 end
