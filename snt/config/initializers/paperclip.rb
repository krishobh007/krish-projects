Paperclip::Attachment.default_options[:storage] = :fog
Paperclip::Attachment.default_options[:fog_credentials] = { provider: 'Rackspace',
                                                            rackspace_username: 'stayntouch',
                                                            rackspace_api_key: '3ba1adf351d908583cddca1a5be957af',
                                                            rackspace_region: :ord }
Paperclip::Attachment.default_options[:fog_public] = true

