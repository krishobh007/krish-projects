require 'spec_helper'

describe 'GuestApi' do
  describe 'fetch_guest' do
    before(:each) do
      ows_response = double('response')

      allow(ows_response).to receive(:body) {
        {
          fetch_profile_response: {
            result: { :@result_status_flag => 'SUCCESS' },
            profile_details: {
              :profile_i_ds => {
                :unique_id => %w(4834585 2649949),
                :@xmlns => 'http://webservices.micros.com/og/4.3/Name/'
              },
              :customer => {
                :person_name => {
                  :name_title => 'Mr.',
                  :first_name => 'Gopkumar',
                  :last_name => 'Sarangdharan',
                  :@active => 'true'
                },
                :government_id_list => {
                  government_id: {
                    :@xmlns => 'http://webservices.micros.com/og/4.3/Common/',
                    :@document_type => 'Passport',
                    :@document_number => '53468900',
                    :@effective_date => '0001-01-01'
                  }
                  },
                :@xmlns => 'http://webservices.micros.com/og/4.3/Name/',
                :@birth_date => '1975-04-17',
                :@profile_type => 'GUEST'
              },
              :credit_cards => {
                :name_credit_card => {
                  :card_code => 'AX',
                  :card_holder_name => 'GOPKUMAR SARANGDHARAN',
                  :card_number => '373344556677889',
                  :expiration_date => 'Wed,31Dec2014',
                  :@credit_card_type => 'CC',
                  :@opera_id => '859252',
                  :@primary => 'false',
                  :@display_sequence => '1',
                  :@insert_user => '2',
                  :@insert_date => '2013-09-27T00:01:19',
                  :@update_user => '2',
                  :@update_date => '2013-09-27T00:09:10'
                },
                :@xmlns => 'http://webservices.micros.com/og/4.3/Name/'
              },
              :addresses => {
                :name_address => {
                  :address_line => '19016 Noble Oak Dr',
                  :city_name => 'Germantown',
                  :state_prov => 'MD',
                  :country_code => 'US',
                  :postal_code => '20874',
                  :@address_type => 'H',
                  :@language_code => 'E',
                  :@opera_id => '2631860',
                  :@primary => 'true',
                  :@display_sequence => '0',
                  :@insert_user => '2',
                  :@insert_date => '2013-09-12T13:41:40',
                  :@update_user => '2',
                  :@update_date => '2013-10-11T10:44:41'
                },
                :@xmlns => 'http://webservices.micros.com/og/4.3/Name/'
              },
              :phones => {
                :name_phone => {
                  :phone_number => '2392392999',
                  :@phone_type => 'HOME',
                  :@phone_role => 'PHONE',
                  :@opera_id => '4854096',
                  :@primary => 'true',
                  :@display_sequence => '1',
                  :@insert_user => '2',
                  :@insert_date => '2013-09-27T00:00:24',
                  :@update_user => '2',
                  :@update_date => '2013-10-11T10:44:41'
                },
                :@xmlns => 'http://webservices.micros.com/og/4.3/Name/'
              },
              :preferences => {
                :preference => [
                  {
                    :preference_description => {
                      text: {
                        :text_element => 'Boston Herald',
                        :@xmlns => 'http://webservices.micros.com/og/4.3/Common/'
                      }
                    },
                    :@resort_code => 'DOZERQA',
                    :@preference_type => 'NEWSPAPER',
                    :@preference_value => 'BH',
                    :@insert_user => '2',
                    :@insert_date => '2013-10-11T10:21:50',
                    :@update_user => '2',
                    :@update_date => '2013-10-11T10:21:50'
                  },
                  {
                    :preference_description => {
                      text: {
                        :text_element => 'Balcony',
                        :@xmlns => 'http://webservices.micros.com/og/4.3/Common/'
                      }
                    },
                    :@resort_code => 'DOZERQA',
                    :@preference_type => 'ROOM FEATURES',
                    :@preference_value => 'BAL',
                    :@insert_user => '2',
                    :@insert_date => '2013-10-11T10:24:11',
                    :@update_user => '2',
                    :@update_date => '2013-10-11T10:24:11'
                  },
                  {
                    :preference_description => {
                      text: {
                        :text_element => 'Spa Bath in room',
                        :@xmlns => 'http://webservices.micros.com/og/4.3/Common/'
                      }
                    },
                    :@resort_code => 'DOZERQA',
                    :@preference_type => 'ROOM FEATURES',
                    :@preference_value => 'SPA',
                    :@insert_user => '2',
                    :@insert_date => '2013-10-11T10:24:11',
                    :@update_user => '2',
                    :@update_date => '2013-10-11T10:24:11'
                  },
                  {
                    :preference_description => {
                      text: {
                        :text_element => 'Non-Smoking',
                        :@xmlns => 'http://webservices.micros.com/og/4.3/Common/'
                      }
                    },
                    :@resort_code => 'DOZERQA',
                    :@preference_type => 'SMOKING',
                    :@preference_value => 'NS',
                    :@insert_user => '2',
                    :@insert_date => '2013-10-11T10:21:37',
                    :@update_user => '2',
                    :@update_date => '2013-10-11T10:21:37'
                  }
                ],
                :@xmlns => 'http://webservices.micros.com/og/4.3/Name/'
              },
              :e_mails => {
                :name_email => 'gop@stayntouch.com',
                :@xmlns => 'http://webservices.micros.com/og/4.3/Name/'
              },
              :memberships => {
                :name_membership => {
                  :membership_type => 'DL',
                  :membership_number => '56367383939303',
                  :member_name => 'GOPKUMAR SARANGDHARAN',
                  :effective_date => 'Thu,12Apr2012',
                  :expiration_date => 'Wed,31Dec2014',
                  :current_points => '0',
                  :@opera_id => '157512',
                  :@preferred => 'true',
                  :@membership_class => 'AIR',
                  :@points_label => 'Delta Miles',
                  :@display_sequence => '1',
                  :@insert_user => '2',
                  :@insert_date => '2013-10-11T10:23:05',
                  :@update_user => '2',
                  :@update_date => '2013-10-11T10:23:05'
                },
                :@xmlns => 'http://webservices.micros.com/og/4.3/Name/'
              },
              :privacy => {
                :privacy_option => [
                  {
                    :@option_type => 'MarketResearch',
                    :@option_value => 'NO'
                  },
                  {
                    :@option_type => 'ThirdParties',
                    :@option_value => 'NO'
                  },
                  {
                    :@option_type => 'LoyaltyProgram',
                    :@option_value => 'NO'
                  },
                  {
                    :@option_type => 'Promotions',
                    :@option_value => 'NO'
                  },
                  {
                    :@option_type => 'Privacy',
                    :@option_value => 'NO'
                  },
                  {
                    :@option_type => 'Email',
                    :@option_value => 'NO'
                  },
                  {
                    :@option_type => 'Mail',
                    :@option_value => 'NO'
                  },
                  {
                    :@option_type => 'Phone',
                    :@option_value => 'NO'
                  },
                  {
                    :@option_type => 'SMS',
                    :@option_value => 'NO'
                  }
                ],
                :@xmlns => 'http://webservices.micros.com/og/4.3/Name/'
              },
              :id => {
                :@xmlns => 'http://webservices.micros.com/og/4.3/Name/',
                :@document_number => '53468900'
              },
              :features => {
                :features => [
                  {
                    :@xmlns => 'http://webservices.micros.com/og/4.3/HotelCommon/',
                    :@feature => 'BAL'
                  },
                  {
                    :@xmlns => 'http://webservices.micros.com/og/4.3/HotelCommon/',
                    :@feature => 'SPA'
                  }
                ],
                :@xmlns => 'http://webservices.micros.com/og/4.3/Name/'
              },
              :@language_code => 'E',
              :@nationality => 'AM',
              :@vip_code => 'CEL',
              :@active => 'true'
            }

          }
        }
      }

      OwsService.any_instance.stub(:soap_request) { ows_response }
    end

    fixtures :hotels, :settings

    it 'should return success' do
      hotel = hotels(:one)
      guest_api = GuestApi.new(hotel.id)

      assert_not_nil guest_api

      response = guest_api.fetch_guest('4834585')
      assert_not_nil response
      assert_equal true, response[:status]
      assert_equal '4834585', response[:guest_id]
    end

  end
end
