FactoryGirl.define do
  factory :user_membership do
    user_id nil
    membership_type 'DL'
    membership_card_number '123456'
    membership_expiry_date '2014-12-31'
    membership_level 'Gold'
    membership_class 'AIR'
    card_name 'Kim'
    membership_start_date '2012-12-31'
    external_id '157515'
  end
end
