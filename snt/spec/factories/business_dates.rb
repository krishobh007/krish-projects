FactoryGirl.define do
  factory :hotel_business_date do
    business_date Date.today
    status 'OPEN'
    hotel nil
  end
end
