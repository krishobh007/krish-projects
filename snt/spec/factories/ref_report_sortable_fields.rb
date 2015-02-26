# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ref_report_sortable_field, :class => 'Ref::ReportSortableField' do
    value "MyString"
    description "MyString"
  end
end
