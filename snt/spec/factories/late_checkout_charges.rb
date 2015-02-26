# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :late_checkout_charge do
    extended_checkout_time '2013-11-23 14:30:31'
    extended_checkout_charge 1.5
  end
end
