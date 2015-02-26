json.array! @key_encoders do |key_encoder|
  json.call(key_encoder, :id, :description, :location, :encoder_id)
end
