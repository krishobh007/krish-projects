# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ref_report_filter, :class => 'Ref::ReportFilters' do
    value "MyString"
    description "MyString"
  end
end
