# App ID: 1403063239924979
# App Secret: a67bd767a46fa71bd294a7c0b93eade1
OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1403063239924979', 'a67bd767a46fa71bd294a7c0b93eade1'
end
