# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review, class: 'Reviews' do
    title 'MyString'
    description 'MyString'
  end
end
