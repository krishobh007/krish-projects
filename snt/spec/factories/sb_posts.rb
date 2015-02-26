FactoryGirl.define do
  factory :sb_post do
    body 'This is a test post'
    body_html 'This is a test post'
    author_email 'john@doe.com'
    author_name 'John Doe'
    author_ip '127.0.0.1'
    created_at '12-12-2013'
    user_id 1
    group_id 2
    hotel_id 2
  end
end
