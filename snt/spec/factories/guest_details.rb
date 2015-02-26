# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :guest_detail do
    id 1
    user_id 1
    birthday '2013-12-14'
    gender 'MyString'
    is_vip false
    title 'MyString'
    company 'MyString'
    works_at 'MyString'
    job_title 'MyString'
    external_id 'MyString'
    passport_no 'MyString'
    passport_expiry '2013-12-14'
    image_url 'MyString'
  end
end
