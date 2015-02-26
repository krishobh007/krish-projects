FactoryGirl.define do
  factory :wakeup do
    room_no '234'
    start_date Date.today
    end_date Date.today
    status 'REQUESTED'
    time '10:00 PM'
  end
end
