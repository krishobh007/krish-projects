require 'test_helper'

class UrlMappingsTest < ActiveSupport::TestCase
  test 'URL returns the correct hotel chain' do
    test_url = 'http://cha.stayntouch.com:3000/'
    mapping_url = UrlMapping.where('url = ?', test_url).first
    assert_equal mapping_url.hotel_chain_id, 1
  end
end
