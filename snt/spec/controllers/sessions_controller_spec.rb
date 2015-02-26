require 'spec_helper'

describe SessionsController do
  before :each do
  @hotel_chain = FactoryGirl.create(:hotel_chain)
  @hotel = FactoryGirl.create(:hotel, hotel_chain: @hotel_chain)
  @url_mapping = FactoryGirl.create(:url_mapping, hotel_chain: @hotel_chain)
end

  describe 'Hotel Chain Code ', type: :request do
    it 'should return valid hotel chain code for the url' do
      mapping_url = UrlMapping.first
      mapping_url.hotel.hotel_chain.id
    end
  end

end
