# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :guest_web_token do
    guest_id 1
    access_token 'MyString'
  end
end
