FactoryGirl.define do
  factory :setting do
    var 'pms_type'
    value 'OWS'
    thing_id do
      hotels(:one).id
    end
    thing_type 'Hotel'
  end
end
