# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :membership_type do
    value 'MyString'
    membership_class_id 1
    thing_id 1
    thing_type 'MyString'
  end
end
