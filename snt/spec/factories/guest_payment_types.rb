# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment_method do
    associated_id 1
    associated_type 'GuestDetail'
    mli_token 'MyString'
    card_expiry 'MyString'
    card_cvv 'MyString'
    card_name 'MyString'
    bank_routing_no 'MyString'
    account_no 'MyString'
    is_primary false
    external_id 'MyString'
    payment_type_id 1
    credit_card_id 1
  end
end
