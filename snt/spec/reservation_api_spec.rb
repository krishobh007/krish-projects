require 'spec_helper'

describe 'ReservationApi' do
  describe 'get_booking' do
    before(:each) do
      ows_response = double('response')

      allow(ows_response).to receive(:body) {
        {
          fetch_booking_response: {
            result: { :@result_status_flag => 'SUCCESS' },
            hotel_reservation: {
              res_guests: {
                res_guest: {
                  profiles: {
                    profile: {
                      customer: {
                        person_name: {
                          first_name: 'Jon',
                          last_name: 'Herr'
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      OwsService.any_instance.stub(:soap_request) { ows_response }
    end

    fixtures :hotels, :settings

    it 'should return success' do
      hotel = hotels(:one)

      reservation_api = ReservationApi.new(hotel.id)

      assert_not_nil reservation_api

      response = reservation_api.get_booking('123456')

      assert_not_nil response
      assert_equal true, response[:status]
      assert_equal 'Jon', response[:first_name]
      assert_equal 'Herr', response[:last_name]
    end

  end
end
