FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "Lenovo User conference #{n}" }
    group_code 'GMS'
    arrival_date  { 2.days.ago.strftime('%Y-%m-%d') }
    dep_date { 2.days.from_now.strftime('%Y-%m-%d') }

  end
end
