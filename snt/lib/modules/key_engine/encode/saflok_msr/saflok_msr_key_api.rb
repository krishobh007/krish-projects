class SaflokMsrKeyApi
  def self.request_key(reservation, room_no, no_of_keys, options)
    logger.debug 'SAFLOK_MSR: Requesting key'

    errors = []

    if !options[:encoder_id]
      errors << 'encoder_id is a required field'
      { status: false, data: [], errors: errors }
    else
      SaflokKeyApi.request_key(reservation, room_no, no_of_keys, options)
    end
  end
end
