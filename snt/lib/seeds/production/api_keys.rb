module SeedApiKeys
  def create_api_keys
    api_key = ApiKey.new(email: 'admin@stayntouch.com', expiry_date: Date.today + 365.days)
    api_key.key = '85a59b343f11949b3b204708039d781e' # Digest::MD5.hexdigest("wizards#{Time.now}:killed:#{api_key.email}:my_family:#{rand(15562)}")
    api_key.save
  end
end
