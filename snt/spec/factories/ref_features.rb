FactoryGirl.define do
  factory :ref_feature_type do
    name 'NEWSPAPER'
    selection_type 'dropdown'
    is_system_type true
  end
end

FactoryGirl.define do
  factory :ref_feature do
    value 'BBC'
    ref_feature_type
  end
end
