FactoryGirl.define do
  factory :comment do
    sequence(:title) { |n| "Title#{n}" }
    sequence(:comment) { |n| "Comment#{n}" }
    author_name 'John Doe'
  end
end
