# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message, class: 'Messages' do
    message 'MyString'
    conversation_id 1
    parent_id 1
    sender_id 1
  end
end
