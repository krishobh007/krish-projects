FactoryGirl.define do
   factory :api_key do
     email 'test@test.com'
     key { Digest::MD5.hexdigest("wizards#{Time.now}:killed:test@test.com:my_family:#{rand(15_562)}") }
     expiry_date { 5.days.from_now.iso8601 }
   end

 end
