  FactoryGirl.define do
    factory :user do
      sequence(:email) { |n| "johndoe#{n}@example.com" }
      sequence(:login) { |n| "johndoe#{n}@example.com" }
      sequence(:first_name) { |n| "john#{n}" }
      sequence(:last_name) { |n| "doe#{n}" }
      # email 'johndoe@example.com'
      # login 'johndoe'
      password 'admin123'
      password_confirmation 'admin123'
      phone '2527427'
      birthday { 30.years.ago.to_date }
      loc 'Washimgton'
      company 'Fischer Systems India'
      title 'Software Engineer'
      job_title 'Director'
      works_at 'StayNtouch'
      hotel_chain do
          FactoryGirl.create(:hotel_chain)
        end
      role do
        FactoryGirl.create(:role)
      end
      activated_at { Time.now }
      activation_code nil
      default_hotel_id nil
      preferences do
        [Ref::Feature.where(value: 'HIGH', feature_type_id: Ref::FeatureType.where(value: 'FLOOR', selection_type: 'boolean', is_system_type: true).first_or_create.id).first_or_create]
      end
    end
  end
