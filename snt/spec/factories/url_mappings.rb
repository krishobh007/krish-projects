# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :url_mapping do
    url 'http://dozerqa.stayntouch.com'
    hotel nil
    hotel_chain nil
  end
end
