module SeedURLMappings
  def create_url_mappings
    # Mappings for URLS

    # For SNT admin
    UrlMapping.create(url: 'http://pms.stayntouch.com/')
  end
end
