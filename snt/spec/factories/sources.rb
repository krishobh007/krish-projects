# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :source do
    code "MyString"
    description "MyString"
    hotel_id 1
    is_active false
  end
end
