FactoryGirl.define do
  factory :membership_classes do
    value 'FFP'
    description 'Frequent Flyer Program'
    is_system_only true
  end
end
